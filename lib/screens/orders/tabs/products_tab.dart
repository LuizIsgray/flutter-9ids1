import 'package:flutter/material.dart';
import 'package:flutter9ids1/providers/order_client_provider.dart';
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
  List productos = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fnListarProductos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton:
      FloatingActionButtonWidget(onPressed: fnNavegarPaginaAgregarProducto),
      body: Visibility(
        visible:
            datosCargados, //Por defecto false, cuando se cargan true y muestra
        replacement: const Center(child: CircularProgressIndicator()),
        child: RefreshIndicator(
          onRefresh: fnListarProductos,
          child: Visibility(
            visible: productos.isNotEmpty,
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
              itemCount: productos.length,
              padding: const EdgeInsets.all(12),
              itemBuilder: (context, index) {
                final producto = productos[index]
                    as Map; //Map es para usar todos los datos en productos
                final id = producto["id"]
                    as int; //Se obtiene el valor "id" del producto seleccionado
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Text(
                          "${index + 1}",
                          style: const TextStyle(color: Colors.black),
                        )),
                    title: Text(producto["codigo"]),
                    subtitle: Row(
                      children: [
                        Text(producto["descripcion"]),
                        const SizedBox(width: 20),
                        Text(producto["precio"]),
                      ],
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

  Future<void> fnListarProductos() async {

    final respuesta = await ProductsService.listarProductos();
    //final respuesta = context.watch<OrderClientProvider>().productosCarrito;
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

  Future<void> fnNavegarPaginaAgregarProducto() async {
    await Navigator.pushNamed(context, "products/seleccionar");
    //await Navigator.push(context, MaterialPageRoute(builder: (context)=> const ProductDetailScreen()));
    setState(() {
      datosCargados = true;
    });
    fnListarProductos();
  }

}
