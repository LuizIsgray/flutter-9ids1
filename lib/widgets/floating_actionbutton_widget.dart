import 'package:flutter/material.dart';

class FloatingActionButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;

  const FloatingActionButtonWidget({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: const Color.fromRGBO(192, 8, 18, 1),
      onPressed: onPressed, // Remove the () here
      child: const Icon(Icons.add, color: Colors.white),
    );
  }
}
