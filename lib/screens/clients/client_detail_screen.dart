import 'package:flutter/material.dart';
import 'package:flutter9ids1/services/clients_service.dart';
import 'package:flutter9ids1/utils/geolocator_util.dart';
import 'package:flutter9ids1/utils/snackbar_util.dart';
import 'package:geolocator/geolocator.dart';

class ClientDetailScreen extends StatefulWidget {
  final Map? todo; //Se examina los parametros
  const ClientDetailScreen({super.key, this.todo});

  @override
  State<ClientDetailScreen> createState() => _ClientDetailScreenState();
}

class _ClientDetailScreenState extends State<ClientDetailScreen> {
  TextEditingController txtNombreController = TextEditingController();
  TextEditingController txtTelefonoController = TextEditingController();
  TextEditingController txtDireccionController = TextEditingController();
  TextEditingController txtUbicacionLatitudController = TextEditingController();
  TextEditingController txtUbicacionLongitudController =
      TextEditingController();

  bool esEdicion = false;

  @override
  void initState() {
    super.initState();
    final todo = widget.todo;
    if (todo != null) {
      esEdicion = true;
      txtNombreController.text = todo["nombre"];
      txtTelefonoController.text = todo["telefono"];
      txtDireccionController.text = todo["direccion"];
      txtUbicacionLatitudController.text = todo["ubicacion_latitud"];
      txtUbicacionLongitudController.text = todo["ubicacion_longitud"];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(esEdicion
            ? "Editar Cliente"
            : "Agregar Cliente"), //esEdicion = true se coloca Editar
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            autocorrect: false,
            controller: txtNombreController,
            decoration: const InputDecoration(
                border: UnderlineInputBorder(), hintText: 'Nombre'),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: txtTelefonoController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
                border: UnderlineInputBorder(), hintText: 'Teléfono'),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: txtDireccionController,
            keyboardType: TextInputType.streetAddress,
            decoration: const InputDecoration(
                border: UnderlineInputBorder(), hintText: 'Dirección'),
          ),
          const SizedBox(height: 40),
          Text("Ubicación", style: TextStyle(fontSize: 25.0)),
          TextField(
            controller: txtUbicacionLatitudController,
            decoration: const InputDecoration(
                border: UnderlineInputBorder(), hintText: 'Latitud'),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: txtUbicacionLongitudController,
            decoration: const InputDecoration(
                border: UnderlineInputBorder(), hintText: 'Longitud'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            //onPressed: esEdicion ? fnActualizarCliente : fnAgregarCliente,
            onPressed: fnObtenerUbicacion,
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                  const Color.fromRGBO(36, 82, 204, 1.0)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(esEdicion ? "Actualizar ubicación" : "Obtener ubicación",
                  style: const TextStyle(color: Colors.white, fontSize: 20)),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: esEdicion ? fnActualizarCliente : fnAgregarCliente,
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                  const Color.fromRGBO(192, 8, 18, 1)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(esEdicion ? "Actualizar" : "Agregar",
                  style: const TextStyle(color: Colors.white, fontSize: 20)),
            ),
          ),
        ],
      ),
    );
  }

  void fnObtenerUbicacion() async{
    Position position = await fnDeterminarUbicacion();
    print(position.latitude);
    print(position.longitude);
    txtUbicacionLatitudController.text = position.latitude.toString();
    txtUbicacionLongitudController.text = position.longitude.toString();
  }

  Future<void> fnAgregarCliente() async {
    //Obtener datos del formulario
    final nombre = txtNombreController.text;
    final telefono = txtTelefonoController.text;
    final direccion = txtDireccionController.text;
    final ubicacionLatitud = txtUbicacionLatitudController.text;
    final ubicacionLongitud = txtUbicacionLongitudController.text;
    final body = {
      "nombre": nombre,
      "telefono": telefono,
      "direccion": direccion,
      "ubicacion_latitud": ubicacionLatitud,
      "ubicacion_longitud": ubicacionLongitud,
    };

    //Enviar información al servidor
    final isSuccess = await ClientsService.agregarCliente(body);

    //Mostrar respuesta segun el estado devuelto
    if (isSuccess) {
      txtNombreController.text = "";
      txtTelefonoController.text = "";
      txtDireccionController.text = "";
      txtUbicacionLatitudController.text = "";
      txtUbicacionLongitudController.text = "";

      mostrarMensajeExito(context, "Agregado con éxito");

      Navigator.pop(context);
    } else {
      mostrarMensajeError(context, "Error al agregar el elemento");
    }
  }

  Future<void> fnActualizarCliente() async {
    //Obtener datos del formulario
    final todo = widget.todo;
    if (todo == null) {
      mostrarMensajeError(context, "No puedes realizar está acción");
      return;
    }
    final id = todo["id"];
    final nombre = txtNombreController.text;
    final telefono = txtTelefonoController.text;
    final direccion = txtDireccionController.text;
    final ubicacionLatitud = txtUbicacionLatitudController.text;
    final ubicacionLongitud = txtUbicacionLongitudController.text;
    final body = {
      "nombre": nombre,
      "telefono": telefono,
      "direccion": direccion,
      "ubicacion_latitud": ubicacionLatitud,
      "ubicacion_longitud": ubicacionLongitud,
    };

    //Enviar información ACTUALIZADA al servidor
    final isSuccess = await ClientsService.actualizarCliente(id, body);

    //Mostrar respuesta segun el estado devuelto
    if (isSuccess) {
      mostrarMensajeExito(context, "Actualizado con éxito");
      Navigator.pop(context);
    } else {
      mostrarMensajeError(context, "Error al actualizar el elemento");
    }
  }
}
