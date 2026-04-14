import 'package:flutter/material.dart';
import 'package:mini_projeto_4/cadastro.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tela cadastro',
      home: TelaCadastro(),
    );
  }
}
