import 'package:flutter/material.dart';
import 'package:cadastro_usuarios/cadastro_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CadastroPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}