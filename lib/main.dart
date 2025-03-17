import 'package:flutter/material.dart';
import 'package:tugasuts/features/home/home-page.dart';

void main() {
  runApp(const Kasut());
}

class Kasut extends StatelessWidget {
  const Kasut({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: const HomePage());
  }
}
