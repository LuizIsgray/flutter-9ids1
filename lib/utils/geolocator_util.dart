import 'package:geolocator/geolocator.dart';

Future<Position> fnDeterminarUbicacion() async {
  LocationPermission permission;
  permission = await Geolocator.checkPermission();
  if(permission == LocationPermission.denied){
    permission = await Geolocator.requestPermission();
    if(permission == LocationPermission.denied){
      //print('Error al obtener la ubicación');
      return Future.error('Error al obtener la ubicación');
    }
  }
  return await Geolocator.getCurrentPosition();
}
