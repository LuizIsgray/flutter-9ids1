import 'package:flutter/material.dart';
import 'package:flutter9ids1/providers/order_client_provider.dart';
import 'package:flutter9ids1/screens/orders/order_detail_screen.dart';
import 'package:flutter9ids1/services/orders_service.dart';
import 'package:flutter9ids1/widgets/drawer_widget.dart';
import 'package:flutter9ids1/utils/snackbar_util.dart';
import 'package:flutter9ids1/widgets/floating_actionbutton_widget.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  bool datosCargados = false;
  List pedidos = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fnListarPedidos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerWidget(),
      appBar: AppBar(
        title: Text("Pedidos: ${context.watch<OrderClientProvider>().idPedido.toString()}"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton:
          FloatingActionButtonWidget(onPressed: fnNavegarPaginaNuevoPedido),
      body: Visibility(
        visible:
            datosCargados, //Por defecto false, cuando se cargan true y muestra
        replacement: const Center(child: CircularProgressIndicator()),
        child: RefreshIndicator(
          onRefresh: fnListarPedidos,
          child: Visibility(
            visible: pedidos.isNotEmpty,
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
              itemCount: pedidos.length,
              padding: const EdgeInsets.all(12),
              itemBuilder: (context, index) {
                final pedido = pedidos[index]
                    as Map; //Map es para usar todos los datos en pedidos
                final id = pedido["id"]
                    as int; //Se obtiene el valor "id" del pedido seleccionado
                final clienteNombre = pedido["cliente"]["nombre"];
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Text(
                          pedido["id"].toString(),
                          style: const TextStyle(color: Colors.black),
                        )),
                    title: Text(pedido["numero_pedido"]),
                    subtitle: Column(
                      children: [
                        Row(children: [
                          Text("Cliente: $clienteNombre"),
                          const SizedBox(width: 20),
                        ]),
                        Row(
                          children: [
                            Text(pedido["fecha_hora"].toString()),
                          ],
                        ),
                      ],
                    ),
                    trailing: PopupMenuButton(
                      onSelected: (value) {
                        if (value == "edit") {
                          fnNavegarPaginaEditarPedido(pedido);
                        } else if (value == "delete") {
                          QuickAlert.show(
                            context: context,
                            type: QuickAlertType.confirm,
                            title: "Eliminar elemento",
                            text: "Esta acción es irreversible",
                            confirmBtnText: "Eliminar",
                            confirmBtnColor: Colors.red,
                            onConfirmBtnTap: () {
                              fnEliminarPedido(id);
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
                            child: Text(
                              "Eliminar",
                              style: TextStyle(color: Colors.red),
                            ),
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

  Future<void> fnNavegarPaginaNuevoPedido() async {
    await Navigator.pushNamed(context, "orders/nuevo");
    //await Navigator.push(context, MaterialPageRoute(builder: (context)=> const OrderDetailScreen()));
    setState(() {
      datosCargados = true;
    });
    fnListarPedidos();
    //SE comentó
    //context.read<OrderClientProvider>().addToCart(nuevoProducto: const[]);
  }

  Future<void> fnNavegarPaginaEditarPedido(Map pedido) async {
    final route = MaterialPageRoute(
        builder: (context) => OrderDetailScreen(
            todo: pedido)); //Se manda el pedido seleccionado a la pagina
    await Navigator.push(context, route);
    setState(() {
      datosCargados = true;
    });
    fnListarPedidos();
  }

  Future<void> fnEliminarPedido(int id) async {
    //Borrar elemento usando servicio
    final isSuccess = await OrdersService.borrarPedido(id);
    if (isSuccess) {
      //Remover elemento de la lista
      final filtrado = pedidos.where((element) => element["id"] != id).toList();
      setState(() {
        pedidos = filtrado;
      });
      mostrarMensajeExito(context, "Eliminado con éxito");
    } else {
      mostrarMensajeError(context, "Error al eliminar el elemento");
    }
  }

  Future<void> fnListarPedidos() async {
    final respuesta = await OrdersService.listarPedidos();

    if (respuesta != null) {
      setState(() {
        pedidos = respuesta;
      });
    } else {
      mostrarMensajeError(context, "Error al consultar los elementos");
    }
    setState(() {
      datosCargados = true;
    });
  }
}
