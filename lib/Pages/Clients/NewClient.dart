import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter9ids1/Servicios/Ambiente.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/quickalert.dart';

class NewClient extends StatefulWidget {
  const NewClient({super.key});

  @override
  State<NewClient> createState() => _NewClientState();
}

class _NewClientState extends State<NewClient> {
  TextEditingController txtNombreController = TextEditingController();
  TextEditingController txtTelefonoController = TextEditingController();
  TextEditingController txtDireccionController = TextEditingController();
  TextEditingController txtUbicacionLatitudController = TextEditingController();
  TextEditingController txtUbicacionLongitudController = TextEditingController();

  Future<void> fnAgregarCliente() async {
    final nombre = txtNombreController.text;
    final telefono = txtTelefonoController.text;
    final direccion = txtDireccionController.text;
    final ubicacionLatitud = txtUbicacionLatitudController.text;
    final ubicacionLongitud = txtUbicacionLongitudController.text;
    var response = await http.post(
        Uri.parse('${Ambiente.urlServer}/api/clientes'),
        body: jsonEncode(<String, String>{
          "nombre": nombre,
          "telefono": telefono,
          "direccion": direccion,
          "ubicacion_latitud": ubicacionLatitud,
          "ubicacion_longitud": ubicacionLongitud,
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
        text: "No se pudo agregar el cliente",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Agregar Cliente"),
        backgroundColor: Colors.pink,
      ),
      body: Column(
        children: [
          Text("Inserta los datos del cliente por favor"),
          TextField(
            autocorrect: false,
            controller: txtNombreController,
            decoration: const InputDecoration(
                border: UnderlineInputBorder(), hintText: 'Nombre'),
          ),
          TextField(
            controller: txtTelefonoController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
                border: UnderlineInputBorder(), hintText: 'Teléfono'),
          ),
          TextField(
            controller: txtDireccionController,
            keyboardType: TextInputType.streetAddress,
            decoration: const InputDecoration(
                border: UnderlineInputBorder(), hintText: 'Dirección'),
          ),
          TextField(
            controller: txtUbicacionLatitudController,
            decoration: const InputDecoration(
                border: UnderlineInputBorder(), hintText: 'Latitud'),
          ),
          TextField(
            controller: txtUbicacionLongitudController,
            decoration: const InputDecoration(
                border: UnderlineInputBorder(), hintText: 'Longitud'),
          ),
          TextButton(
            onPressed: () {
              fnAgregarCliente();

            },
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.pink),
            ),
            child: const Text('Agregar'),
          )
        ],
      ),
    );
  }
}
