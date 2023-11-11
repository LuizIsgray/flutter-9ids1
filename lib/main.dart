import 'package:flutter/material.dart';
import 'package:flutter9ids1/utils/screens_index_util.dart';

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
    "products/nuevo": (context) => const ProductDetailScreen(),
    "clients": (context) => const ClientsScreen(),
    "clients/nuevo": (context) => const ClientDetailScreen(),
    "orders": (context) => const OrdersScreen(),
    "orders/nuevo": (context) => const OrderDetailScreen(),
  };

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromRGBO(192, 8, 18, 1),
          titleTextStyle: TextStyle(fontSize: 25.0, color: Colors.white),
        ),
        dividerTheme: const DividerThemeData(color: Colors.black87),
      ),
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
