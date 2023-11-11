import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter9ids1/services/environment.dart';
import 'package:http/http.dart' as http;
import 'package:flutter9ids1/models/ModelLogin.dart';
import 'package:quickalert/quickalert.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final urlServer = Environment.urlServer;

  TextEditingController txtUserController = TextEditingController();
  TextEditingController txtPasswordController = TextEditingController();

  //final Future<Preferences> _prefs = Preferences().userPreferences;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Akiba Shop"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: txtUserController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.account_circle),
                    border: OutlineInputBorder(),
                    labelText: "Usuario",
                    hintText: 'Usuario'),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: txtPasswordController,
                obscureText: true,
                keyboardType: TextInputType.visiblePassword,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(),
                    labelText: "Contraseña",
                    hintText: 'Contraseña'),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  fnLogin();
                },
                label: const Text("ACCESAR",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                icon: const Icon(
                  Icons.login,
                  color: Colors.white,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(192, 8, 18, 1),
                ),
              ),

              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, "home");
                },
                label: const Text("TEST",
                    style: TextStyle(color: Colors.white, fontSize: 20)),
                icon: const Icon(
                  Icons.login,
                  color: Colors.white,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(192, 8, 18, 1),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  Future<void> fnLogin() async {
    var response = await http.post(Uri.parse('$urlServer/api/login'),
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

      Navigator.pushReplacementNamed(context, "home");
    } else {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Oops...',
        text: objResp.error,
      );
    }
  }

}
