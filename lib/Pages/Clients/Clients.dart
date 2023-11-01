import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter9ids1/Pages/Home.dart';
import 'package:flutter9ids1/Pages/Clients/NewClient.dart';
import 'package:flutter9ids1/Pages/Clients/EditClient.dart';
import 'package:flutter9ids1/Pages/Clients/NewClient.dart';
import 'package:flutter9ids1/Pages/Clients/Clients.dart';
import 'package:flutter9ids1/Pages/Products/Products.dart';
import 'package:flutter9ids1/Servicios/Ambiente.dart';
import 'package:http/http.dart' as http;

class Clients extends StatefulWidget {
  const Clients({super.key});

  @override
  State<Clients> createState() => _ClientsState();
}

class _ClientsState extends State<Clients> {

  List clientes = [];

  Future<void> fnObtenerClientes() async {
    final response =
    await http.get(Uri.parse('${Ambiente.urlServer}/api/clientes'));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final resultado = json as List;
      setState(() {
        clientes = resultado;
      });
    } else {
      print("Error al consultar los elementos");
    }
  }

  Future<void> fnNavegarPaginaEditarCliente(Map cliente) async {
    final route = MaterialPageRoute(
        builder: (context) => EditClient(
            todo: cliente)); //Se manda el cliente seleccionado a la pagina
    await Navigator.push(context, route);
    /*setState(() {
      datosCargados = true;
    });*/

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fnObtenerClientes();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("CLIENTES"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewClient()),
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
                  MaterialPageRoute(builder: (context) => const Products()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text("Clientes"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Clients()),
                );
              },
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
        onRefresh: fnObtenerClientes,
        child: ListView.builder(
          itemCount: clientes.length,
          itemBuilder: (context, index) {
            var client = clientes[index] as Map;
            return Card(
              child: ListTile(
                leading: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Text(
                      "${client["nombre"][0]}",
                      style: const TextStyle(color: Colors.black),
                    )),
                title: Text(client["telefono"]),
                subtitle: Column(
                  children: [
                    Row(
                      children: [
                        Text(client["direccion"]),
                      ],
                    ),
                    const SizedBox(width: 20),
                    Row(
                      children: [
                        Text(client["ubicacion_latitud"]),
                        const SizedBox(width: 10),
                        Text(client["ubicacion_longitud"]),
                      ],
                    ),
                  ],
                ),
                onTap: () {
                  fnNavegarPaginaEditarCliente(client as Map);
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
