import 'package:flutter/widgets.dart';
import 'package:flutter9ids1/models/product_model.dart';

class OrderClientProvider extends ChangeNotifier {
  int idCliente, idProducto, idPedido, cantidad;
  double total, totalCarrito;
  String nombreCliente, descripcionProducto;

  List<Map<String, dynamic>> productosCarrito = [];

  OrderClientProvider({
    this.idCliente = 0,
    this.nombreCliente = "",
    this.idProducto = 0,
    this.descripcionProducto = "",
    this.cantidad = 0,
    this.total = 0.0,
    this.totalCarrito = 0.0,
    this.idPedido = 0,
    List<Map<String, dynamic>>? productosCarrito,
  }) : this.productosCarrito = productosCarrito ?? [];

  void changeClient({required int newIdCliente, required String newNombreCliente}) async {
    idCliente = newIdCliente;
    nombreCliente = newNombreCliente;
    notifyListeners();
  }

  void changeClientId({required int newIdCliente}) async {
    idCliente = newIdCliente;
    notifyListeners();
  }

  void changeOrderId({required int newIdPedido}) async {
    idPedido = newIdPedido;
    notifyListeners();
  }

  void addToCart({required Producto nuevoProducto}) {
    idProducto = nuevoProducto.id.toInt();
    descripcionProducto = nuevoProducto.descripcion.toString();
    cantidad = nuevoProducto.cantidad.toInt();
    total = nuevoProducto.total.toDouble();

    /*
    print(idProducto);
    print(cantidad);
    print(total);

     */

    Map<String, dynamic> productoMap = {
      'id': idProducto,
      'descripcion': descripcionProducto,
      'cantidad': cantidad,
      'total': total,
    };
    //print("producto map: $productoMap");

    productosCarrito.add(productoMap);

    //print("añadido");
    //print(productosCarrito);
    print("Carrito: $productosCarrito");

    totalCarrito += total;
    print("Total carrito: $totalCarrito");
    notifyListeners();
  }

  void removeFromCart({required int productId}) {
    print("removeFromCart");
    // Encuentra el índice del producto en el carrito
    int index = productosCarrito.indexWhere((producto) => producto['id'] == productId);

    if (index != -1) {
      // Resta el total del producto eliminado del total del carrito
      totalCarrito -= productosCarrito[index]['total'];

      // Elimina el producto del carrito
      productosCarrito.removeAt(index);

      print("Producto eliminado del carrito");
      print("Carrito: $productosCarrito");
      print("Total carrito: $totalCarrito");

      notifyListeners();
    } else {
      print("Producto no encontrado en el carrito");
    }
  }

  void changeTotalCarrito({required double newTotalCarrito}) async {
    totalCarrito = newTotalCarrito;
    notifyListeners();
  }

  void clearData(){
    idProducto = 0;
    descripcionProducto = "";
    cantidad = 0;
    total = 0.0;
    totalCarrito = 0.0;
    productosCarrito = [];
  }
}

