import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter9ids1/screens/home.dart';
import 'package:flutter9ids1/screens/products/crudProductScreen.dart';
import 'package:http/http.dart' as http;

class productsScreen extends StatefulWidget {
  const productsScreen({super.key});

  @override
  State<productsScreen> createState() => _productsScreenState();
}

class _productsScreenState extends State<productsScreen> {
  final ip = "192.168.8.4";

  bool estaCargando = true;
  List productos = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listarProductos();
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
        onPressed: navegarPaginaNuevoProducto,
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
                  MaterialPageRoute(builder: (context) => home()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.shopping_bag),
              title: Text("Productos"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => productsScreen()),
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
            !estaCargando, //Lo contrario, si visible = true no muestra, visible = false muestra
        replacement: Center(child: CircularProgressIndicator()),
        child: RefreshIndicator(
          onRefresh: listarProductos,
          child: ListView.builder(
            itemCount: productos.length,
            itemBuilder: (context, index) {
              final producto = productos[index]
                  as Map; //Map es para usar todos los datos en productos
              final id = producto["id"]
                  as int; //Se obtiene el valor "id" del producto seleccionado
              return ListTile(
                leading: CircleAvatar(
                    backgroundColor: Colors.white, child: Text("${index + 1}")),
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
                      navegarPaginaEditarProducto(producto);
                    } else if (value == "delete") {
                      borrarProducto(id);
                    }
                  },
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(child: Text("Editar"), value: "edit"),
                      PopupMenuItem(child: Text("Eliminar"), value: "delete"),
                    ];
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> navegarPaginaNuevoProducto() async {
    final route = MaterialPageRoute(builder: (context) => crudProductScreen());
    await Navigator.push(context, route);
    setState(() {
      estaCargando = false;
    });
    listarProductos();
  }

  Future<void> navegarPaginaEditarProducto(Map producto) async{
    final route = MaterialPageRoute(builder: (context) => crudProductScreen(todo: producto)); //Se manda el producto seleccionado a la pagina
    await Navigator.push(context, route);
    setState(() {
      estaCargando = true;
    });
    listarProductos();
  }

  Future<void> borrarProducto(int id) async {
    //Borrar elemento
    final url = "http://$ip:8000/api/productos/$id";
    final uri = Uri.parse(url);
    final response = await http.delete(uri);
    if (response.statusCode == 200) {
      //Remover elemento de la lista
      final filtrado =
          productos.where((element) => element["id"] != id).toList();
      setState(() {
        productos = filtrado;
      });
    } else {
      print("Error al borrar el elemento");
      print(response.body);
    }
  }

  Future<void> listarProductos() async {
    final url = "http://$ip:8000/api/productos";
    final uri = Uri.parse(url);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      //En caso de encontrarse dentro de otro lista seria:  final resultado = json["nombre de la sub lista"] as List;
      final resultado = json as List;
      setState(() {
        productos = resultado;
      });
    }
    setState(() {
      estaCargando = false;
    });
    print(response.statusCode);
  }
}
