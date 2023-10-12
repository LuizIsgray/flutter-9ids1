import 'package:flutter/material.dart';

void mostrarMensajeExito(BuildContext context, String mensaje) {
  final snackBar = SnackBar(
      content: Text(mensaje));
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void mostrarMensajeError(BuildContext context, String mensaje) {
  final snackBar = SnackBar(content: Text(mensaje, style: TextStyle(color: Colors.white)),
      backgroundColor: Colors.red);
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
