class ModelProductos {
  final String codigo;
  final String descripcion;
  final double precio;

  ModelProductos(this.codigo, this.descripcion, this.precio);

  ModelProductos.fromJson(Map<String, dynamic> json)
      : codigo = json['codigo'],
        descripcion = json['descripcion'],
        precio = double.parse(json['precio']);

  Map<String, dynamic> toJson() => {
    'codigo': codigo,
    'descripcion': descripcion,
    'precio': precio,
  };
}