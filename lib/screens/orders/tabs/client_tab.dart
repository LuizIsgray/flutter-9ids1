import 'package:flutter9ids1/providers/order_client_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter9ids1/screens/orders/order_detail_screen.dart';
import 'package:flutter9ids1/services/clients_service.dart';
import 'package:flutter9ids1/utils/snackbar_util.dart';
import 'package:provider/provider.dart';

class ClientTab extends StatefulWidget {
  const ClientTab({super.key});

  @override
  State<ClientTab> createState() => _ClientTabState();
}

class _ClientTabState extends State<ClientTab> {
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
    return Visibility(
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
                color: cliente["id"] == context.watch<OrderClientProvider>().idCliente ? const Color.fromRGBO(192, 8, 18, 1) : null,

                child: ListTile(
                  onTap: () {
                    context.read<OrderClientProvider>().changeClient(
                      newIdCliente: cliente["id"],
                      newNombreCliente: cliente["nombre"].toString(),);
                    print("seleccionado: ${cliente["nombre"]}");
                  },
                  leading: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Text(
                        "${cliente["nombre"][0]}",
                        style: const TextStyle(color: Colors.black),
                      )),
                  title: Text(cliente["telefono"]),
                  textColor:
                  cliente["id"] == context.watch<OrderClientProvider>().idCliente ?
                  Colors.white : null,
                  subtitle: Column(
                    children: [
                      Row(
                        children: [
                          Text(cliente["direccion"]),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
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
