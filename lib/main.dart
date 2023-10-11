import 'package:flutter/material.dart';
import 'package:flutter9ids1/screens/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Akiba Shop',
      theme: ThemeData.dark(),
      home: const login(),
    );
  }
}
