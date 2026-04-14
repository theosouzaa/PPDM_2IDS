import 'package:mini_projeto_2/tela_principal.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Tela sobre Mim👍🏼',
      home: TelaPrincipal()
    );
  }
}
