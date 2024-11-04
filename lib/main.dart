import 'package:flutter/material.dart';
import 'package:pasar_barang_pilihan/menu.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pasar Barang Pilihan',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blue,
        ).copyWith(
          secondary: Colors.lightBlueAccent
        ),
        useMaterial3: true,
      ),
      home: MyHomePage(),
    );
  }
}