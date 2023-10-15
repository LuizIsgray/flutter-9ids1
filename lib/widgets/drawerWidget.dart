import 'package:flutter/material.dart';
import 'package:flutter9ids1/screens/homeScreen.dart';
import 'package:flutter9ids1/screens/products/productsScreen.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Column(
                children: [
                  Expanded(child: Image.network("https://i.imgur.com/nMDaD07.jpg")),
                  Text("Usuario")
                ],
              )),
          ListTile(
            leading: Icon(Icons.home),
            title: Text("Home"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.shopping_bag),
            title: Text("Productos"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProductsScreen()),
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
    );
  }
}
