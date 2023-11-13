import 'package:flutter/material.dart';
import 'package:flutter9ids1/providers/order_client_provider.dart';
import 'package:flutter9ids1/screens/orders/tabs/client_tab.dart';
import 'package:flutter9ids1/screens/orders/tabs/products_tab.dart';
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
  TextEditingController txtCodigoController = TextEditingController();
  TextEditingController txtDescripcionController = TextEditingController();
  TextEditingController txtPrecioController = TextEditingController();

  bool esEdicion = false;

  String selectedOption = ""; // Variable para almacenar la opción seleccionada

  @override
  void initState() {
    super.initState();
    final todo = widget.todo;
    if (todo != null) {
      esEdicion = true;
      txtCodigoController.text = todo["codigo"];
      txtDescripcionController.text = todo["descripcion"];
      txtPrecioController.text = todo["precio"];
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
        body: const TabBarView(
          children: [
            ClientTab(),
            ProductsTab(),
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
                        //"Opción seleccionada: $selectedOption",
                        context
                            .watch<OrderClientProvider>()
                            .idCliente
                            .toString(),
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    Text(
                      //"Opción seleccionada: $selectedOption",
                      context.watch<OrderClientProvider>().nombreCliente,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  esEdicion ? fnActualizarPedido : fnAgregarPedido;
                  context.read<OrderClientProvider>().changeClient(
                        newIdCliente: 0,
                        newNombreCliente: "",
                      );
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
                        esEdicion ? "Actualizar" : "Agregar",
                        style:
                            const TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      const Text(
                        "Total a pagar: 5555",
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
    //Obtener datos del formulario
    final codigo = txtCodigoController.text;
    final descripcion = txtDescripcionController.text;
    final precio = txtPrecioController.text;
    final body = {
      "codigo": codigo,
      "descripcion": descripcion,
      "precio": precio,
    };

    //Enviar información al servidor
    final isSuccess = await OrdersService.agregarPedido(body);

    //Mostrar respuesta segun el estado devuelto
    if (isSuccess) {
      txtCodigoController.text = "";
      txtDescripcionController.text = "";
      txtPrecioController.text = "";

      mostrarMensajeExito(context, "Agregado con éxito");

      Navigator.pop(context);
    } else {
      mostrarMensajeError(context, "Error al agregar el elemento");
    }
    //print(response.statusCode);
    //print(response.body);
    /*
    var response = await http.post(
        Uri.parse('http://192.168.8.4:8000/api/productos/nuevo'),
        body: jsonEncode(<String, String>{
          'codigo': txtCodigoController.text,
          'descripcion': txtDescripcionController.text,
          'precio': txtPrecioController.text,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        });
    var respuesta = response.body;
    //Implementar quickalert
    if (respuesta == "OK") {
      //Mensaje ok depende de laravel
      Navigator.pop(context);
    } else {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Oops...',
        text: "No se pudo agregar el producto",
      );
    }
     */
  }

  Future<void> fnActualizarPedido() async {
    //Obtener datos del formulario
    final todo = widget.todo;
    if (todo == null) {
      mostrarMensajeError(context, "No puedes realizar está acción");
      return;
    }
    final id = todo["id"];
    final codigo = txtCodigoController.text;
    final descripcion = txtDescripcionController.text;
    final precio = txtPrecioController.text;
    final body = {
      "codigo": codigo,
      "descripcion": descripcion,
      "precio": precio,
    };

    //Enviar información ACTUALIZADA al servidor
    final isSuccess = await OrdersService.actualizarPedido(id, body);

    //Mostrar respuesta segun el estado devuelto
    if (isSuccess) {
      mostrarMensajeExito(context, "Actualizado con éxito");
      Navigator.pop(context);
    } else {
      mostrarMensajeError(context, "Error al actualizar el elemento");
    }
  }
}
