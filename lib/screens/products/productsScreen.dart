import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter9ids1/screens/home.dart';
import 'package:flutter9ids1/screens/products/crudProductScreen.dart';
import 'package:flutter9ids1/services/productsService.dart';
import 'package:flutter9ids1/widgets/snackbarUtil.dart';
import 'package:http/http.dart' as http;
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
      appBar: AppBar(
        title: Text("Productos"),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Colors.blue,
        onPressed: fnNavegarPaginaNuevoProducto,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
                decoration: BoxDecoration(color: Colors.blue),
                child: Column(
                  children: [
                    Expanded(
                        child: Image.network(
                            "https://drive.google.com/file/d/1EkjCn5unLp52tO58XWtDf6fuGN4xXiuq/view?usp=sharing")),
                    Text("Usuario"),
                  ],
                )),
            ListTile(
              leading: Icon(Icons.home),
              title: Text("Home"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Home()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.shopping_bag),
              title: Text("Productos"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProductsScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text("Clientes"),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.sell),
              title: Text("Ventas"),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: Visibility(
        visible:
            datosCargados, //Por defecto false, cuando se cargan true y muestra
        replacement: Center(child: CircularProgressIndicator()),
        child: RefreshIndicator(
          onRefresh: fnListarProductos,
          child: Visibility(
            visible: productos
                .isNotEmpty, //Cuando existen elementos = true y muestra los elementos
            replacement: Center(
              child: Text("No hay elementos registrados"),
            ),
            child: ListView.builder(
              itemCount: productos.length,
              padding: EdgeInsets.all(12),
              itemBuilder: (context, index) {
                final producto = productos[index]
                    as Map; //Map es para usar todos los datos en productos
                final id = producto["id"]
                    as int; //Se obtiene el valor "id" del producto seleccionado
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Text("${index + 1}")),
                    title: Text(producto["codigo"]),
                    subtitle: Row(
                      children: [
                        Text(producto["descripcion"]),
                        SizedBox(width: 20),
                        Text(producto["precio"]),
                      ],
                    ),
                    trailing: PopupMenuButton(
                      onSelected: (value) {
                        if (value == "edit") {
                          fnNavegarPaginaEditarProducto(producto);
                        } else if (value == "delete") {
                          fnEliminarProducto(id);
                        }
                      },
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem(child: Text("Editar"), value: "edit"),
                          PopupMenuItem(
                              child: Text("Eliminar"), value: "delete"),
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
    final route = MaterialPageRoute(builder: (context) => CrudProductScreen());
    await Navigator.push(context, route);
    setState(() {
      datosCargados = true;
    });
    fnListarProductos();
  }

  Future<void> fnNavegarPaginaEditarProducto(Map producto) async {
    final route = MaterialPageRoute(
        builder: (context) => CrudProductScreen(
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
