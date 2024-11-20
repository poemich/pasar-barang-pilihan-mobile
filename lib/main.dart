import 'package:flutter/material.dart';
import 'package:pasar_barang_pilihan/screens/login.dart';
import 'package:pasar_barang_pilihan/screens/menu.dart'; // Adjusted import path
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) {
        CookieRequest request = CookieRequest();
        return request;
      },
      child: MaterialApp(
        title: 'Pasar Barang Pilihan',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.blue,
          ).copyWith(
            secondary: Colors.lightBlueAccent
          ),
        ),
        home: const LoginPage(),
      ),
    );
  }
}
