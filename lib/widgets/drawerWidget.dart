import 'package:flutter/material.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const UserAccountsDrawerHeader(
            accountEmail: Text("example.com"),
            accountName: Text("Luis"),
            currentAccountPicture: CircleAvatar(foregroundImage: NetworkImage("https://i.imgur.com/nMDaD07.jpg")),
            decoration: BoxDecoration(color: Colors.redAccent),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text("Home"),
            onTap: () {
              Navigator.pushReplacementNamed(context, "home");
            },
          ),
          ListTile(
            leading: const Icon(Icons.shopping_bag),
            title: const Text("Productos"),
            onTap: () {
              Navigator.pushReplacementNamed(context, "products");
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("Clientes"),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.sell),
            title: const Text("Ventas"),
            onTap: () {},
          ),
          const Divider(color: Colors.white),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text("Configuración"),
            onTap: () {
              Navigator.pushNamed(context, "configuration");
            },
          ),
          const Divider(color: Colors.white),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Cerrar sesión"),
            onTap: () {
              Navigator.pushReplacementNamed(context, "login");
            },
          ),
        ],
      ),
    );
  }
}
