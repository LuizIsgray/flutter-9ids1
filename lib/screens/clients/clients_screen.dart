import 'package:flutter/material.dart';
import 'package:flutter9ids1/screens/clients/client_detail_screen.dart';
import 'package:flutter9ids1/services/clients_service.dart';
import 'package:flutter9ids1/utils/snackbar_util.dart';
import 'package:flutter9ids1/widgets/drawer_widget.dart';
import 'package:flutter9ids1/widgets/floating_actionbutton_widget.dart';
import 'package:quickalert/quickalert.dart';

class ClientsScreen extends StatefulWidget {
  const ClientsScreen({super.key});

  @override
  State<ClientsScreen> createState() => _ClientsScreenState();
}

class _ClientsScreenState extends State<ClientsScreen> {
  bool datosCargados = false;
  List clientes = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fnListarClientes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerWidget(),
      appBar: AppBar(
        title: const Text("Clientes"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton:
      FloatingActionButtonWidget(onPressed: fnNavegarPaginaNuevoCliente),
      body: Visibility(
        visible:
        datosCargados, //Por defecto false, cuando se cargan true y muestra
        replacement: const Center(child: CircularProgressIndicator()),
        child: RefreshIndicator(
          onRefresh: fnListarClientes,
          child: Visibility(
            visible: clientes.isNotEmpty,
            //Cuando existen elementos = true y muestra los elementos
            replacement: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.dangerous, size: 50.0),
                  Text(
                    "No hay elementos registrados",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            child: ListView.builder(
              itemCount: clientes.length,
              padding: const EdgeInsets.all(12),
              itemBuilder: (context, index) {
                final cliente = clientes[index]
                as Map; //Map es para usar todos los datos en clientes
                final id = cliente["id"]
                as int; //Se obtiene el valor "id" del cliente seleccionado
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Text(
                          "${cliente["nombre"][0]}",
                          style: const TextStyle(color: Colors.black),
                        )),
                    title: Text(cliente["telefono"]),
                    subtitle: Column(
                      children: [
                        Row(
                          children: [
                            Text(cliente["direccion"]),
                          ],
                        ),
                        const SizedBox(width: 20),
                        Row(
                          children: [
                            Text(cliente["ubicacion_latitud"]),
                            const SizedBox(width: 10),
                            Text(cliente["ubicacion_longitud"]),
                          ],
                        ),
                      ],
                    ),
                    trailing: PopupMenuButton(
                      onSelected: (value) {
                        if (value == "edit") {
                          fnNavegarPaginaEditarCliente(cliente);
                        } else if (value == "delete") {
                          QuickAlert.show(
                            context: context,
                            type: QuickAlertType.confirm,
                            title: "Eliminar elemento",
                            text: "Esta acción es irreversible",
                            confirmBtnText: "Eliminar",
                            confirmBtnColor: Colors.red,
                            onConfirmBtnTap: () {
                              fnEliminarCliente(id);
                              Navigator.pop(context);
                            },
                          );
                        }
                      },
                      itemBuilder: (context) {
                        return [
                          const PopupMenuItem(
                            value: "edit",
                            child: Text("Editar"),
                          ),
                          const PopupMenuItem(
                            value: "delete",
                            child: Text("Eliminar"),
                          ),
                        ];
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<void> fnNavegarPaginaNuevoCliente() async {
    await Navigator.pushNamed(context, "clients/nuevo");
    //await Navigator.push(context, MaterialPageRoute(builder: (context)=> const ClientDetailScreen()));
    setState(() {
      datosCargados = true;
    });
    fnListarClientes();
  }

  Future<void> fnNavegarPaginaEditarCliente(Map cliente) async {
    final route = MaterialPageRoute(
        builder: (context) =>
            ClientDetailScreen(
                todo: cliente)); //Se manda el cliente seleccionado a la pagina
    await Navigator.push(context, route);
    setState(() {
      datosCargados = true;
    });
    fnListarClientes();
  }

  Future<void> fnEliminarCliente(int id) async {
    //Borrar elemento usando servicio
    final isSuccess = await ClientsService.borrarCliente(id);
    if (isSuccess) {
      //Remover elemento de la lista
      final filtrado =
      clientes.where((element) => element["id"] != id).toList();
      setState(() {
        clientes = filtrado;
      });
      mostrarMensajeExito(context, "Eliminado con éxito");
    } else {
      mostrarMensajeError(context, "Error al eliminar el elemento");
    }
  }

  Future<void> fnListarClientes() async {
    final respuesta = await ClientsService.listarClientes();

    if (respuesta != null) {
      setState(() {
        clientes = respuesta;
      });
    } else {
      mostrarMensajeError(context, "Error al consultar los elementos");
    }
    setState(() {
      datosCargados = true;
    });
  }
}
