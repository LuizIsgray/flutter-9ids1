import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter9ids1/Models/ModelProductos.dart';
import 'package:flutter9ids1/Pages/Products/NewProduct.dart';
import 'package:flutter9ids1/Pages/Products/Products.dart';
import 'package:flutter9ids1/Servicios/Ambiente.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<ModelProductos> productos = [];

  Future<void> fnProductos() async {
    var response = await http.get(
        Uri.parse('${Ambiente.urlServer}/api/productos'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        });
    print(response.body);
    if (response.statusCode == 200) {
      Iterable l = jsonDecode(response.body);
      productos = List<ModelProductos>.from(
          l.map((model) => ModelProductos.fromJson(model)));
    } else {
      print("Ocurrio un error: " + response.statusCode.toString());
    }
  }

  Widget _listViewProductos(List<ModelProductos> prods){
    return ListView.builder(itemCount: prods.length,
        itemBuilder: (context, index){
      var prod = prods[index];
      return ListTile(
        leading: CircleAvatar(
          child: Text(prod.codigo[0]),
        ),
        title: Text(prod.descripcion),
        subtitle: Text("Precio: ${prod.precio}"),
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>const NewProduct()));
        },
      );

    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fnProductos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
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
                    Expanded(child: Image.network('')),
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
      body: _listViewProductos(productos),
    );
  }
}
