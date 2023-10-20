import 'package:flutter/material.dart';
import 'package:flutter9ids1/screens/products/product_detail_screen.dart';
import 'package:flutter9ids1/services/products_service.dart';
import 'package:flutter9ids1/widgets/drawer_widget.dart';
import 'package:flutter9ids1/utils/snackbar_util.dart';
import 'package:flutter9ids1/widgets/floating_actionbutton_widget.dart';
import 'package:quickalert/quickalert.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
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
      drawer: const DrawerWidget(),
      appBar: AppBar(
        title: const Text("Productos"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      /*floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromRGBO(192, 8, 18, 1),
        //onPressed: fnNavegarPaginaNuevoProducto,
        onPressed: fnNavegarPaginaNuevoProducto,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      */
      floatingActionButton:
          FloatingActionButtonWidget(onPressed: fnNavegarPaginaNuevoProducto),
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
                    trailing: PopupMenuButton(
                      onSelected: (value) {
                        if (value == "edit") {
                          fnNavegarPaginaEditarProducto(producto);
                        } else if (value == "delete") {
                          QuickAlert.show(
                            context: context,
                            type: QuickAlertType.confirm,
                            title: "Eliminar elemento",
                            text: "Esta acción es irreversible",
                            confirmBtnText: "Eliminar",
                            confirmBtnColor: Colors.red,
                            onConfirmBtnTap: () {
                              fnEliminarProducto(id);
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

  Future<void> fnNavegarPaginaNuevoProducto() async {
    await Navigator.pushNamed(context, "products/nuevo");
    //await Navigator.push(context, MaterialPageRoute(builder: (context)=> const ProductDetailScreen()));
    setState(() {
      datosCargados = true;
    });
    fnListarProductos();
  }

  Future<void> fnNavegarPaginaEditarProducto(Map producto) async {
    final route = MaterialPageRoute(
        builder: (context) => ProductDetailScreen(
            todo: producto)); //Se manda el producto seleccionado a la pagina
    await Navigator.push(context, route);
    setState(() {
      datosCargados = true;
    });
    fnListarProductos();
  }

  Future<void> fnEliminarProducto(int id) async {
    //Borrar elemento usando servicio
    final isSuccess = await ProductsService.borrarProducto(id);
    if (isSuccess) {
      //Remover elemento de la lista
      final filtrado =
          productos.where((element) => element["id"] != id).toList();
      setState(() {
        productos = filtrado;
      });
      mostrarMensajeExito(context, "Eliminado con éxito");
    } else {
      mostrarMensajeError(context, "Error al eliminar el elemento");
    }
  }

  Future<void> fnListarProductos() async {
    final respuesta = await ProductsService.listarProductos();

    if (respuesta != null) {
      setState(() {
        productos = respuesta;
      });
    } else {
      mostrarMensajeError(context, "Error al consultar los elementos");
    }
    setState(() {
      datosCargados = true;
    });
  }
}
