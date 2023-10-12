import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter9ids1/models/ModelLogin.dart';
import 'package:flutter9ids1/screens/home.dart';
import 'package:quickalert/quickalert.dart';

class login extends StatefulWidget {
  const login({Key? key}) : super(key: key);

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  final ip = "192.168.8.4";

  final txtUserController = TextEditingController();
  final txtPasswordController = TextEditingController();

  Future<void> fnLogin() async {
    var response = await http.post(
        Uri.parse('http://$ip:8000/api/login'),
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
        MaterialPageRoute(builder: (context) => home()),
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
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
                border: OutlineInputBorder(), hintText: 'Usuario'),
          ),
          TextField(
            controller: txtPasswordController,
            obscureText: true,
            keyboardType: TextInputType.visiblePassword,
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