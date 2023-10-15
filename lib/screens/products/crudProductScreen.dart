import 'package:flutter/material.dart';
import 'package:flutter9ids1/services/productsService.dart';
import 'package:flutter9ids1/utils/snackbarUtil.dart';

class CrudProductScreen extends StatefulWidget {
  final Map? todo; //Se examina los parametros
  const CrudProductScreen({super.key, this.todo});

  @override
  State<CrudProductScreen> createState() => _CrudProductScreenState();
}

class _CrudProductScreenState extends State<CrudProductScreen> {

  TextEditingController txtCodigoController = TextEditingController();
  TextEditingController txtDescripcionController = TextEditingController();
  TextEditingController txtPrecioController = TextEditingController();

  //Mask para formatear la entrada del CODIGO
  //Comentada porque borra lo guardado en el campo al editar
  /*
  var codeMask = MaskTextInputFormatter(
      mask: 'AAA###',
      filter: { "#": RegExp(r'[0-9]'), "A": RegExp('[A-Z, a-z]') },

      //type: MaskAutoCompletionType.lazy
  );
   */

  bool esEdicion = false;

  @override
  void initState() {
    super.initState();
    final todo = widget.todo;
    if (todo != null) {
      esEdicion = true;
      txtCodigoController.text = todo["codigo"];
      txtDescripcionController.text = todo["descripcion"];
      txtPrecioController.text = todo["precio"];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(esEdicion
            ? "Editar Producto"
            : "Agregar Producto"), //esEdicion = true se coloca Editar
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            //inputFormatters: [codeMask],
            autocorrect: false,
            controller: txtCodigoController,
            decoration: const InputDecoration(
                border: UnderlineInputBorder(), hintText: 'Código'),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: txtDescripcionController,
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 10,
            decoration: const InputDecoration(
                border: UnderlineInputBorder(), hintText: 'Descripción'),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: txtPrecioController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
                border: UnderlineInputBorder(), hintText: 'Precio'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: esEdicion ? fnActualizarProducto : fnAgregarProducto,
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(const Color.fromRGBO(192, 8, 18, 1)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(esEdicion ? "Actualizar" : "Agregar",
                  style: const TextStyle(color: Colors.white, fontSize: 20)),
            ),
          )
        ],
      ),
    );
  }

  Future<void> fnAgregarProducto() async {
    //Obtener datos del formulario
    final codigo = txtCodigoController.text;
    final descripcion = txtDescripcionController.text;
    final precio = txtPrecioController.text;
    final body = {
      "codigo": codigo,
      "descripcion": descripcion,
      "precio": precio,
    };

    //Enviar información al servidor
    final isSuccess = await ProductsService.agregarProducto(body);

    //Mostrar respuesta segun el estado devuelto
    if (isSuccess) {
      txtCodigoController.text = "";
      txtDescripcionController.text = "";
      txtPrecioController.text = "";

      mostrarMensajeExito(context, "Agregado con éxito");

      Navigator.pop(context);
    } else {
      mostrarMensajeError(context, "Error al agregar el elemento");
    }
    //print(response.statusCode);
    //print(response.body);
    /*
    var response = await http.post(
        Uri.parse('http://192.168.8.4:8000/api/productos/nuevo'),
        body: jsonEncode(<String, String>{
          'codigo': txtCodigoController.text,
          'descripcion': txtDescripcionController.text,
          'precio': txtPrecioController.text,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        });
    var respuesta = response.body;
    //Implementar quickalert
    if (respuesta == "OK") {
      //Mensaje ok depende de laravel
      Navigator.pop(context);
    } else {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Oops...',
        text: "No se pudo agregar el producto",
      );
    }
     */
  }

  Future<void> fnActualizarProducto() async {
    //Obtener datos del formulario
    final todo = widget.todo;
    if (todo == null) {
      mostrarMensajeError(context, "No puedes realizar está acción");
      return;
    }
    final id = todo["id"];
    final codigo = txtCodigoController.text;
    final descripcion = txtDescripcionController.text;
    final precio = txtPrecioController.text;
    final body = {
      "codigo": codigo,
      "descripcion": descripcion,
      "precio": precio,
    };

    //Enviar información ACTUALIZADA al servidor
    final isSuccess = await ProductsService.actualizarProducto(id, body);

    //Mostrar respuesta segun el estado devuelto
    if (isSuccess) {
      mostrarMensajeExito(context, "Actualizado con éxito");
      Navigator.pop(context);
    } else {
      mostrarMensajeError(context, "Error al actualizar el elemento");
    }
  }
}
