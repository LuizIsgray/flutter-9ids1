import 'package:flutter/material.dart';
import 'package:flutter9ids1/widgets/drawerWidget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerWidget(),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(192, 8, 18, 1),
        title: const Text("Home"),
      ),
    );
  }
}
