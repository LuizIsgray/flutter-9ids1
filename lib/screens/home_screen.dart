import 'package:flutter/material.dart';
import 'package:flutter9ids1/widgets/drawer_widget.dart';

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
        title: const Text("Home"),
      ),
      body: const Center(
        child: Image(image: AssetImage("assets/akiba_shop.png")),
      ),
    );
  }
}
