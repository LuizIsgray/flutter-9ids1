import 'package:flutter/material.dart';
import 'package:flutter9ids1/utils/screensIndexUtil.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final rutas = {
    "login": (context) => const LoginScreen(),
    "home": (context) => const HomeScreen(),
    "configuration": (context) => const ConfigurationScreen(),
    "products": (context) => const ProductsScreen(),
    "products/nuevo": (context) => const CrudProductScreen(),
  };

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true),
      title: 'Akiba Shop',
      initialRoute: "login",
      routes: rutas,
      /*
      onGenerateRoute: (settings) {
        return MaterialPageRoute(builder: (context)=>LoginScreen());
      },
       */
    );
  }
}
