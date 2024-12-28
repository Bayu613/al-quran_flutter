import 'package:flutter/material.dart';
import 'halaman_artikel.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Halamanartikel(), // Make sure Halamanartikel is the home screen
    );
  }
}
