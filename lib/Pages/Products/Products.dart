import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter9ids1/Pages/Home.dart';
import 'package:flutter9ids1/Pages/Products/NewProduct.dart';
import 'package:flutter/material.dart';
import 'package:flutter9ids1/Pages/Products/EditProduct.dart';
import 'package:flutter9ids1/Pages/Products/NewProduct.dart';
import 'package:flutter9ids1/Pages/Products/Products.dart';
import 'package:flutter9ids1/Servicios/Ambiente.dart';
import 'package:http/http.dart' as http;

class Products extends StatefulWidget {
  const Products({super.key});

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {

  List productos = [];

  Future<void> fnObtenerProductos() async {
    final response =
    await http.get(Uri.parse('${Ambiente.urlServer}/api/productos'));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final resultado = json as List;
      setState(() {
        productos = resultado;
      });
    } else {
      print("Error al consultar los elementos");
    }
  }

  Future<void> fnNavegarPaginaEditarProducto(Map producto) async {
    final route = MaterialPageRoute(
        builder: (context) => EditProduct(
            todo: producto)); //Se manda el producto seleccionado a la pagina
    await Navigator.push(context, route);
    /*setState(() {
      datosCargados = true;
    });*/

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fnObtenerProductos();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("PRODUCTOS"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewProduct()),
          );
        },
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
                decoration: BoxDecoration(color: Colors.blue),
                child: Column(
                  children: [
                    //Expanded(child: Image.network('')),
                    Text("Usuario")
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
                  MaterialPageRoute(builder: (context) => Products()),
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
      body: RefreshIndicator(
        onRefresh: fnObtenerProductos,
        child: ListView.builder(
          itemCount: productos.length,
          itemBuilder: (context, index) {
            var prod = productos[index] as Map;
            return ListTile(
              leading: CircleAvatar(
                child: Text(prod["codigo"][0]),
              ),
              title: Text(prod["descripcion"]),
              subtitle: Text("Precio: ${prod["precio"]}"),
              onTap: () {
                fnNavegarPaginaEditarProducto(prod as Map);
              },
            );
          },
        ),
      ),
    );
  }
}
