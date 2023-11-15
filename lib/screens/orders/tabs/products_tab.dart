import 'package:flutter/material.dart';
import 'package:flutter9ids1/providers/order_client_provider.dart';
import 'package:flutter9ids1/services/order_details_service.dart';
import 'package:flutter9ids1/services/products_service.dart';
import 'package:flutter9ids1/utils/snackbar_util.dart';
import 'package:flutter9ids1/widgets/floating_actionbutton_widget.dart';
import 'package:provider/provider.dart';

class ProductsTab extends StatefulWidget {
  const ProductsTab({super.key});

  @override
  State<ProductsTab> createState() => _ProductsTabState();
}

class _ProductsTabState extends State<ProductsTab> {
  bool datosCargados = false;
  List productosCarrito = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fnActualizarCarrito();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton:
          FloatingActionButtonWidget(onPressed: fnNavegarPaginaAgregarProducto),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(right: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text("Actualizar Carrito"),
                IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: () {
                    print('Botón presionado');
                    fnActualizarCarrito();
                    //fnAgregarPedido();
                  },
                ),
              ],
            ),
          ),
          Visibility(
            visible: productosCarrito.isNotEmpty,
            //Cuando existen elementos = true y muestra los elementos
            replacement: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.dangerous, size: 50.0),
                  Text(
                    "No hay elementos en el carrito",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            child: Expanded(
              child: ListView.builder(
                itemCount: productosCarrito.length,
                padding: const EdgeInsets.all(12),
                itemBuilder: (context, index) {
                  final producto = productosCarrito[index] as Map;
                  print(producto);
                  final id = producto["id"] as int;
                  print("el final: $id");
                  print(producto["id"]);

                  print(productosCarrito);
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Text(
                          "${producto["id"]}",
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                      title: Text(producto["id"].toString()),
                      subtitle: Row(
                        children: [
                          Text(producto["cantidad"].toString()),
                          const SizedBox(width: 20),
                          Text(producto["total"].toString()),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> fnActualizarCarrito() async {
    //final respuesta = await ProductsService.listarProductos();
    //Provider.of<OrderClientProvider>(context, listen: false);
    // Obtener la instancia de OrderClientProvider sin escuchar cambios
    final orderClientProvider =
        Provider.of<OrderClientProvider>(context, listen: false);
    final respuesta = orderClientProvider.productosCarrito;
    //print(respuesta);
    if (respuesta != null) {
      setState(() {
        productosCarrito = respuesta as List;
      });
    } else {
      mostrarMensajeError(context, "Error al consultar los elementos");
    }

    print("fnActualizar: $productosCarrito");
    setState(() {
      datosCargados = true;
    });
  }

  Future<void> fnAgregarDetallesPedido() async {
    print("fnAgregarPedido: $productosCarrito");
    for (var producto in productosCarrito) {
      print("fnAgregarPedidoFOR: ${productosCarrito[0]["id"]}");
      //Obtener datos del formulario
      final producto_id = producto["id"];
      final cantidad = producto["cantidad"];
      final total = producto["total"];

      final body = {
        "producto_id": producto_id,
        "cantidad": cantidad,
        "total": total,
      };
      //Enviar información al servidor
      final isSuccess = await OrderDetailsService.agregarDetallePedido(body);

      //Mostrar respuesta segun el estado devuelto
      if (isSuccess) {
        /*
        txtCodigoController.text = "";
        txtDescripcionController.text = "";
        txtPrecioController.text = "";
        */
        context.read<OrderClientProvider>().clearData();

        mostrarMensajeExito(context, "Agregado con éxito");

        Navigator.pop(context);
      } else {
        mostrarMensajeError(context, "Error al agregar el elemento");
      }
    }

    //print(response.statusCode);
    //print(response.body);
    /*
    var response = await http.post(
        Uri.parse('http://192.168.8.4:8000/api/productos/nuevo'),
        body: jsonEncode(<String, String>{
          'producto_id': txtCodigoController.text,
          'cantidad': txtDescripcionController.text,
          'total': txtPrecioController.text,
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

  /*Future<void> fnListarProductos() async {

    //final respuesta = await ProductsService.listarProductos();
    final respuesta = context.watch<OrderClientProvider>().productosCarrito;
    //print(respuesta);
    if (respuesta != null) {
      setState(() {
        productos = respuesta as List;
      });
    } else {
      mostrarMensajeError(context, "Error al consultar los elementos");
    }

    setState(() {
      datosCargados = true;
    });
  }

   */

  Future<void> fnNavegarPaginaAgregarProducto() async {
    await Navigator.pushNamed(context, "products/seleccionar");
    //await Navigator.push(context, MaterialPageRoute(builder: (context)=> const ProductDetailScreen()));
    setState(() {
      datosCargados = true;
    });
    //fnListarProductos();
  }
}
