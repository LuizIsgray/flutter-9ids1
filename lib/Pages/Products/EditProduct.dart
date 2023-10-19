import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter9ids1/Servicios/Ambiente.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/quickalert.dart';

class EditProduct extends StatefulWidget {
  final Map? todo; //Se examina los parametros
  const EditProduct({super.key, this.todo});

  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  final txtCodigoController = TextEditingController();
  final txtDescripcionController = TextEditingController();
  final txtPrecioController = TextEditingController();

  Future<void> fnGuardarProducto() async {

    //Obtener datos del formulario
    final todo = widget.todo;
    if (todo == null) {
      print("No puedes realizar está acción");
      return;
    }
    final id = todo["id"];

    var response = await http.put(
        Uri.parse('${Ambiente.urlServer}/api/productos/$id'),
        body: jsonEncode(<String, String>{
          'id': id.toString(),
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
        text: "No se pudo editar el producto",
      );
    }
  }

  Future<void> fnEliminarProducto() async {

    //Obtener datos del formulario
    final todo = widget.todo;
    if (todo == null) {
      print("No puedes realizar está acción");
      return;
    }
    final id = todo["id"];

    var respuesta = await http.delete(
        Uri.parse('${Ambiente.urlServer}/api/productos/$id'));

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
      txtCodigoController.text = todo["codigo"];
      txtDescripcionController.text = todo["descripcion"];
      txtPrecioController.text = todo["precio"];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar Producto"),
        backgroundColor: Colors.pink,
      ),
      body: Column(
        children: [
          const Text("Inserta los datos del producto por favor"),
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
              fnGuardarProducto();
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
                  fnEliminarProducto();
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
