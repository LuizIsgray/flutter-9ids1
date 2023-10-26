import 'dart:convert';

import 'package:flutter9ids1/services/environment.dart';
import 'package:http/http.dart' as http;

//Uso de la API en laravel de Products
class ClientsService {
  //Variable para la dirección IP, para usar en todos los request
  final urlServer = Environment.urlServer;

  static Future<List?> listarClientes() async {
    //List? vuelve la lista nullable, puede devolver null

    //Se crea una variable instanciando la clase principal y obteniendo ip
    final url = "${ClientsService().urlServer}/api/clientes";
    final uri = Uri.parse(url);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final resultado = json as List;
      return resultado;
    } else {
      return null;
    }
  }

  static Future<bool> agregarCliente(Map body) async{
    final url = "${ClientsService().urlServer}/api/clientes";
    final uri = Uri.parse(url);
    final response = await http.post(uri,
        body: jsonEncode(body),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        });
    return response.statusCode == 200;
  }

  static Future<bool> actualizarCliente(int id, Map body) async{
    final url = "${ClientsService().urlServer}/api/clientes/$id";
    final uri = Uri.parse(url);
    final response = await http.put(uri,
        body: jsonEncode(body),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        });
    return response.statusCode == 200;
  }

  static Future<bool> borrarCliente(int id) async {
    //Se crea una variable instanciando la clase principal y obteniendo ip
    //Borrar elemento
    final url = "${ClientsService().urlServer}/api/clientes/$id";
    final uri = Uri.parse(url);
    final response = await http.delete(uri);

    return response.statusCode == 200; //Si el statusCode es 200 devuelve true
  }

}
