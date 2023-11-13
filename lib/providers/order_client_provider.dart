import 'package:flutter/widgets.dart';

class OrderClientProvider extends ChangeNotifier {
  int idCliente;
  String nombreCliente;

  OrderClientProvider({
    this.idCliente = 0,
    this.nombreCliente = "",
  });

  void changeClient({required int newIdCliente, required String newNombreCliente}) async {
    idCliente = newIdCliente;
    nombreCliente = newNombreCliente;
    notifyListeners();
  }

}
