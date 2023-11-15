import 'package:flutter/widgets.dart';
import 'package:flutter9ids1/models/product_model.dart';

class OrderClientProvider extends ChangeNotifier {
  int idCliente, idProducto, cantidad;
  double total, totalCarrito;
  String nombreCliente;

  List<Map<String, dynamic>> productosCarrito = [];

  OrderClientProvider({
    this.idCliente = 0,
    this.nombreCliente = "",
    this.idProducto = 0,
    this.cantidad = 0,
    this.total = 0.0,
    this.totalCarrito = 0.0,
    List<Map<String, dynamic>>? productosCarrito,
  }) : this.productosCarrito = productosCarrito ?? [];

  void changeClient({required int newIdCliente, required String newNombreCliente}) async {
    idCliente = newIdCliente;
    nombreCliente = newNombreCliente;
    notifyListeners();
  }

  void addToCart({required Producto nuevoProducto}) {
    idProducto = nuevoProducto.id.toInt();
    cantidad = nuevoProducto.cantidad.toInt();
    total = nuevoProducto.total.toDouble();

    print(idProducto);
    print(cantidad);
    print(total);

    Map<String, dynamic> productoMap = {
      'id': idProducto,
      'cantidad': cantidad,
      'total': total,
    };
    print("producto map: $productoMap");

    productosCarrito.add(productoMap);

    print("añadido");
    print(productosCarrito);
    print("Carrito: $productosCarrito");

    totalCarrito += total;
    print("total carrito: $totalCarrito");
    notifyListeners();
  }

  void clearData(){
    idProducto = 0;
    cantidad = 0;
    total = 0.0;
    totalCarrito = 0.0;
    productosCarrito = [];
  }
}

