import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter9ids1/models/product_model.dart';
import 'package:flutter9ids1/providers/order_client_provider.dart';
import 'package:flutter9ids1/screens/orders/tabs/client_tab.dart';
import 'package:flutter9ids1/screens/orders/tabs/products_tab.dart';
import 'package:flutter9ids1/services/order_details_service.dart';
import 'package:flutter9ids1/services/orders_service.dart';
import 'package:flutter9ids1/services/products_service.dart';
import 'package:flutter9ids1/utils/snackbar_util.dart';
import 'package:provider/provider.dart';

class OrderDetailScreen extends StatefulWidget {
  final Map? todo; //Se examina los parametros
  const OrderDetailScreen({super.key, this.todo});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  bool esEdicion = false;
  bool pedidoAgregado = false;

  int pedidoId = 0; // Variable para almacenar la opción seleccionada
  int clienteId = 0;
  List productosCarrito = [];

  @override
  void initState() {
    super.initState();
    final todo = widget.todo;
    if (todo != null) {
      esEdicion = true;
      clienteId = 0;
      //print(todo);
      pedidoId = todo["id"];
      print("pedidoId: $pedidoId");
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: Text(esEdicion
              ? "Editar Pedido"
              : "Agregar Pedido"), //esEdicion = true se coloca Editar
          bottom: const TabBar(tabs: [
            Tab(
              icon: Icon(Icons.person, color: Colors.white),
            ),
            Tab(
              icon: Icon(Icons.shopping_bag, color: Colors.white),
            ),
          ]),
        ),
        body: TabBarView(
          children: [
            const ClientTab(),
            ProductsTab(esEdicionCarrito: esEdicion, idPedidoCarrito: pedidoId),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          height: 155.0,
          surfaceTintColor: Colors.redAccent,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              // Mostrar la opción seleccionada encima del botón "Agregar"
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    if (context.watch<OrderClientProvider>().idCliente != 0)
                      Text(
                        //"Opción seleccionada: $cliente_id",
                        context.watch<OrderClientProvider>().idCliente.toString(),
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    Text(
                      //"Opción seleccionada: $cliente_id",
                      context.watch<OrderClientProvider>().nombreCliente,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  //esEdicion ? fnActualizarPedido() : fnAgregarPedido();
                  final todo = widget.todo;
                  final orderClientProvider = Provider.of<OrderClientProvider>(
                    context,
                    listen: false,
                  );
                  if (esEdicion) {
                    //orderClientProvider.changeClient(newIdCliente: todo?["cliente_id"], newNombreCliente: todo?["cliente"]["nombre"]);
                    fnActualizarPedido();
                  } else {
                    if (!pedidoAgregado) {
                      //orderClientProvider.changeClient(newIdCliente: 0, newNombreCliente: "");
                      print("Pedido Agregado FALSE");
                      await fnAgregarPedido();

                      if (pedidoAgregado) {
                        print("if TRUE");
                        await fnAgregarDetallesPedido();
                      }
                    } else {
                      print("Pedido Agregado TRUE");
                    }

                    //fnAgregarDetallesPedido();
                  }
                  //esEdicion ? fnActualizarPedido() : fnAgregarPedido();
                  Navigator.pop(context);

                  context.read<OrderClientProvider>().changeClient(
                        newIdCliente: 0,
                        newNombreCliente: "",
                      );

                  //context.read<OrderClientProvider>().clearData();
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      const Color.fromRGBO(192, 8, 18, 1)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      Text(
                        esEdicion ? "Actualizar Pedido" : "Agregar Pedido",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      Text("Total Carrito: ${context.watch<OrderClientProvider>().totalCarrito.toString()}",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> fnAgregarPedido() async {
    //try {
    print("fnAgregarPedido Order_Detail");
    pedidoAgregado = false;
    print("Estado Pedido: $pedidoAgregado");

    final orderClientProvider =
        Provider.of<OrderClientProvider>(context, listen: false);
    //Obtener datos del formulario
    final numero_pedido = orderClientProvider.idPedido+1; //Toma el valor del id del ultimo pedido + 1
    final fecha_hora = DateTime.now().toLocal().toString();
    final cliente_id = orderClientProvider.idCliente;
    if (cliente_id != null || cliente_id >= 1) {
      final body = {
        "numero_pedido": numero_pedido,
        "fecha_hora": fecha_hora,
        "cliente_id": cliente_id,
      };
      //Enviar información al servidor
      final response = await OrdersService.agregarPedido(body);
      print(response.body);
      Map<String, dynamic> jsonResp = jsonDecode(response.body);
      print("pedidoId antes del IF: $pedidoId");
      print(response.statusCode);

      //Mostrar respuesta segun el estado devuelto
      if (response.statusCode == 200 || response.statusCode == 201) {
        pedidoId = jsonResp["id"];
        print("pedidoId dentro IF: $pedidoId");
        orderClientProvider.changeOrderId(newIdPedido: pedidoId);
        //context.read<OrderClientProvider>().changeOrderId(newIdPedido: pedidoId);
        //fnAgregarDetallesPedido();
        pedidoAgregado = true;
        print("Estado Pedido: $pedidoAgregado");
        /*
      context.read<OrderClientProvider>().changeClient(
            newIdCliente: 0,
            newNombreCliente: "",
          );

       */
        //print(response.body);

        //mostrarMensajeExito(context, "Agregado con éxito");

        //Navigator.pop(context);
      } else {
        pedidoAgregado = false;
        //mostrarMensajeError(context, "Error al agregar el elemento");
      }
    }

    /*
    }catch (e) {
      // Handle any exceptions, you can log or handle them appropriately
      print("Error: $e");
    }

       */

    //print(response.statusCode);
    //print(response.body);
  }

  Future<void> fnActualizarPedido() async {
    final orderClientProvider = Provider.of<OrderClientProvider>(
      context,
      listen: false,
    );
    print("Cliente Id preactu: $clienteId");


    //Obtener datos del formulario
    final todo = widget.todo;
    clienteId = orderClientProvider.idCliente;
    print("Cliente Id postactu: $clienteId");

    if (todo == null) {
      mostrarMensajeError(context, "No puedes realizar está acción");
      return;
    }
    final id = todo["id"];
    print("TODO id: $id");
    final numero_pedido = todo["numero_pedido"];
    final fecha_hora = todo["fecha_hora"];
    //final cliente_id = todo["cliente_id"];
    final cliente_id = clienteId;
    final body = {
      "numero_pedido": numero_pedido,
      "fecha_hora": fecha_hora,
      "cliente_id": cliente_id,
    };

    //Enviar información ACTUALIZADA al servidor
    final isSuccess = await OrdersService.actualizarPedido(id, body);

    //Mostrar respuesta segun el estado devuelto
    if (isSuccess) {
      //mostrarMensajeExito(context, "Actualizado con éxito");
      //Navigator.pop(context);
    } else {
      //mostrarMensajeError(context, "Error al actualizar el elemento");
    }
  }

  Future<void> fnAgregarDetallesPedido() async {
    print("fnAgregarDetallesPedido");
    final orderClientProvider =
        Provider.of<OrderClientProvider>(context, listen: false);
    final newPedidoId = orderClientProvider.idPedido;
    print("newPedidoId: $newPedidoId");
    final respuesta = orderClientProvider.productosCarrito;
    //print(respuesta);
    if (respuesta != null) {
      setState(() {
        productosCarrito = respuesta as List;
      });
    } else {
      mostrarMensajeError(context, "Error al consultar los elementos");
    }
    print("fnAgregarPedido MOSTRAR CARRITO: $productosCarrito");
    for (var producto in productosCarrito) {
      print("fnAgregarPedidoFOR: ${productosCarrito[0]["id"]}");
      //Obtener datos del formulario
      //print("newPedidoId: $newPedidoId");
      final pedido_id = newPedidoId;
      final producto_id = producto["id"];
      final descripcion = producto["descripcion"];
      final cantidad = producto["cantidad"];
      final total = producto["total"];

      final body = {
        "pedido_id": pedido_id,
        "producto_id": producto_id,
        "descripcion": descripcion,
        "cantidad": cantidad,
        "total": total,
      };
      //Enviar información al servidor
      final isSuccess = await OrderDetailsService.agregarDetallePedido(body);
      //Mostrar respuesta segun el estado devuelto
      if (isSuccess) {
        print("Detalle de Producto Agregado: $pedido_id");

        //orderClientProvider.clearData();

        //mostrarMensajeExito(context, "Agregado con éxito");

        //Navigator.pop(context);
      } else {
        print("Detalle de Producto ERROR no agregado: $pedido_id");
        //mostrarMensajeError(context, "Error al agregar el elemento");
      }
    }
    orderClientProvider.clearData();
  }
}
