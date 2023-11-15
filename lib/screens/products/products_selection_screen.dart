import 'package:flutter/material.dart';
import 'package:flutter9ids1/models/product_model.dart';
import 'package:flutter9ids1/providers/order_client_provider.dart';
import 'package:flutter9ids1/screens/products/product_detail_screen.dart';
import 'package:flutter9ids1/services/products_service.dart';
import 'package:flutter9ids1/utils/snackbar_util.dart';
import 'package:provider/provider.dart';
import 'package:flutter/widgets.dart';

class ProductsSelectionScreen extends StatefulWidget {
  const ProductsSelectionScreen({super.key});

  @override
  State<ProductsSelectionScreen> createState() =>
      _ProductsSelectionScreenState();
}

class _ProductsSelectionScreenState extends State<ProductsSelectionScreen> {
  bool datosCargados = false;
  List productos = [];

  int cantidad = 0;
  double total = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fnListarProductos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Seleccione un producto ^^"),
      ),
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
                final precio = double.parse(producto["precio"]);
                return Card(
                  child: ListTile(
                    onTap: () {
                      cantidad = 0;
                      total = 0;
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return StatefulBuilder(
                            builder: (context, setState) {
                              return SizedBox(
                                height: 400,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Text("Producto: ${producto["descripcion"]}"),
                                      Text("Cantidad"),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              setState(() {
                                                if(cantidad > 0){
                                                  cantidad--;
                                                  total = cantidad * precio;
                                                }
                                              });
                                            },
                                            icon: const Icon(Icons.arrow_left_outlined, size: 40.0,),
                                          ),
                                          Text(cantidad.toString(), style: TextStyle(fontSize: 25.0),),
                                          IconButton(
                                            onPressed: () {
                                              setState(() {
                                                cantidad++;
                                                total = cantidad * precio;
                                              });
                                            },
                                            icon: const Icon(Icons.arrow_right_outlined, size: 40.0,),
                                          ),
                                        ],
                                      ),
                                      Text("Total: ${total}", style: const TextStyle(fontSize: 20.0)),
                                      ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all(
                                            const Color.fromRGBO(192, 8, 18, 1),
                                          ),
                                        ),
                                        child: const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                            "AÑADIR",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                            ),
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);

                                          /*final Producto nuevoProducto = Producto(
                                            id: producto["id"],
                                            codigo: producto["codigo"],
                                            descripcion: producto["descripcion"],
                                            precio: double.parse(producto["precio"]),
                                            created_at: producto["created_at"],
                                            updated_at: producto["updated_at"],
                                          );*/

                                          //context.read<OrderClientProvider>().addToCart(nuevosProductos: [nuevoProducto]);

                                          fnAgregarProductoCarrito(producto, cantidad, total);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );

                      print("${producto["id"]} ${producto["descripcion"]}");
                    },
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
                    trailing: const Icon(
                      Icons.keyboard_arrow_right,
                      size: 30.0,
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

  Future<void> fnAgregarProductoCarrito(Map<dynamic, dynamic> producto, int cantidad, double total) async {
    final id = producto["id"];
    print("producto id: $id");
    print("cantidad: $cantidad");
    print ("total: $total");

    // Assuming Producto is your model class for products
    final nuevoProducto = Producto(id: id, cantidad: cantidad, total: total);

    print(nuevoProducto);

    // Pass the created product instance to addToCart
    context.read<OrderClientProvider>().addToCart(nuevoProducto: nuevoProducto);

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
