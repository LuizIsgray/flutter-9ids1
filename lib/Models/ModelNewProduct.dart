class ModelNewProduct {
  final String exito;
  final String error;

  ModelNewProduct(this.exito, this.error);

  ModelNewProduct.fromJson(Map<String, dynamic> json)
      : exito = json['exito'],
        error = json['error'];

  Map<String, dynamic> toJson() => {
    'exito': exito,
    'error': error,
  };
}