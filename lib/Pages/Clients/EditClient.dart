import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter9ids1/Servicios/Ambiente.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/quickalert.dart';

class EditClient extends StatefulWidget {
  final Map? todo; //Se examina los parametros
  const EditClient({super.key, this.todo});

  @override
  State<EditClient> createState() => _EditClientState();
}

class _EditClientState extends State<EditClient> {
  TextEditingController txtNombreController = TextEditingController();
  TextEditingController txtTelefonoController = TextEditingController();
  TextEditingController txtDireccionController = TextEditingController();
  TextEditingController txtUbicacionLatitudController = TextEditingController();
  TextEditingController txtUbicacionLongitudController = TextEditingController();

  Future<void> fnGuardarCliente() async {

    //Obtener datos del formulario
    final todo = widget.todo;
    if (todo == null) {
      print("No puedes realizar está acción");
      return;
    }
    final id = todo["id"];
    final nombre = txtNombreController.text;
    final telefono = txtTelefonoController.text;
    final direccion = txtDireccionController.text;
    final ubicacionLatitud = txtUbicacionLatitudController.text;
    final ubicacionLongitud = txtUbicacionLongitudController.text;

    var response = await http.put(
        Uri.parse('${Ambiente.urlServer}/api/clientes/$id'),
        body: jsonEncode(<String, String>{
          'id': id.toString(),
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
        text: "No se pudo editar el cliente",
      );
    }
  }

  Future<void> fnEliminarCliente() async {

    //Obtener datos del formulario
    final todo = widget.todo;
    if (todo == null) {
      print("No puedes realizar está acción");
      return;
    }
    final id = todo["id"];

    var respuesta = await http.delete(
        Uri.parse('${Ambiente.urlServer}/api/clientes/$id'));

    if (respuesta.statusCode == 200) {
      //Remover elemento de la lista
      print( "Eliminado con éxito");
    } else {
      print("Error al eliminar el elemento");
    }

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final todo = widget.todo;
    if (todo != null) {
      txtNombreController.text = todo["nombre"];
      txtTelefonoController.text = todo["telefono"];
      txtDireccionController.text = todo["direccion"];
      txtUbicacionLatitudController.text = todo["ubicacion_latitud"];
      txtUbicacionLongitudController.text = todo["ubicacion_longitud"];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar Cliente"),
        backgroundColor: Colors.pink,
      ),
      body: Column(
        children: [
          const Text("Inserta los datos del cliente por favor"),
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
              fnGuardarCliente();
            },
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.pink),
            ),
            child: const Text('Guardar'),
          ),
          TextButton(
            onPressed: () {
              QuickAlert.show(
                context: context,
                type: QuickAlertType.confirm,
                title: "Eliminar elemento",
                text: "Esta acción es irreversible",
                confirmBtnText: "Eliminar",
                confirmBtnColor: Colors.red,
                onConfirmBtnTap: () {
                  fnEliminarCliente();
                  Navigator.pop(context);
                },
              );

            },
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.red),
            ),
            child: const Text('Eliminar'),
          )
        ],
      ),
    );
  }
}
