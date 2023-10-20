import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter9ids1/Pages/Products/NewProduct.dart';
import 'package:flutter9ids1/Pages/Products/Products.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CASA"),
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
    );
  }
}
