import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter9ids1/Pages/Home.dart';
import 'package:http/http.dart' as http;
import 'package:flutter9ids1/Models/ModelNewProduct.dart';
import 'package:quickalert/quickalert.dart';

class NewProduct extends StatefulWidget {
  const NewProduct({super.key});

  @override
  State<NewProduct> createState() => _NewProductState();
}

class _NewProductState extends State<NewProduct> {
  final txtCodigoController = TextEditingController();
  final txtDescripcionController = TextEditingController();
  final txtPrecioController = TextEditingController();

  Future<void> fnAgregarProducto() async {
    var response = await http.post(
        Uri.parse('http://192.168.43.158:8000/api/productos/nuevo'),
        body: jsonEncode(<String, String>{
          'codigo': txtCodigoController.text,
          'descripcion': txtDescripcionController.text,
          'precio': txtPrecioController.text,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        });

    var respuesta = response.body;
    //Implementar quickalert

    if (respuesta == "OK") {
      //Mensaje ok depende de laravel
      Navigator.pop(context);
    } else {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Oops...',
        text: "No se pudo agregar el producto",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Agregar Producto"),
      ),
      body: Column(
        children: [
          TextField(
            controller: txtCodigoController,
            decoration: const InputDecoration(
                border: OutlineInputBorder(), hintText: 'Código'),
          ),
          TextField(
            controller: txtDescripcionController,
            decoration: const InputDecoration(
                border: OutlineInputBorder(), hintText: 'Descripción'),
          ),
          TextField(
            controller: txtPrecioController,
            decoration: const InputDecoration(
                border: OutlineInputBorder(), hintText: 'Precio'),
          ),
          TextButton(
            onPressed: () {
              fnAgregarProducto();
              /*
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Home()));
                  */

            },
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
            ),
            child: const Text('Agregar'),
          )
        ],
      ),
    );
  }
}
