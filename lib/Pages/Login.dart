import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter9ids1/Servicios/Ambiente.dart';
import 'package:http/http.dart' as http;
import 'package:flutter9ids1/Models/ModelLogin.dart';
import 'package:flutter9ids1/Pages/Home.dart';
import 'package:quickalert/quickalert.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final txtUserController = TextEditingController();
  final txtPasswordController = TextEditingController();

  Future<void> fnLogin() async {
    var response = await http.post(
        Uri.parse('${Ambiente.urlServer}/api/login'),
        body: jsonEncode(<String, String>{
          'email': txtUserController.text,
          'password': txtPasswordController.text,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        });

    Map<String, dynamic> jsonResp = jsonDecode(response.body);
    var objResp = ModelLogin.fromJson(jsonResp);
    //Implementar quickalert
    if (objResp.acceso == "OK") {
      //Mensaje ok depende de laravel
      /*QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        text: 'Usuario existe!',
      */
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );
    } else {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Oops...',
        text: objResp.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bienvenido =D"),
      ),
      body: Column(
        children: [
          TextField(
            controller: txtUserController,
            decoration: const InputDecoration(
                border: OutlineInputBorder(), hintText: 'Usuario'),
          ),
          TextField(
            controller: txtPasswordController,
            obscureText: true,
            decoration: const InputDecoration(
                border: OutlineInputBorder(), hintText: 'Contraseña'),
          ),
          TextButton(
            onPressed: () {
              fnLogin();
            },
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
            ),
            child: const Text('Accesar'),
          )
        ],
      ),
    );
  }
}
