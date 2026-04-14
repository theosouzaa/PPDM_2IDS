import 'package:flutter/material.dart';

class SegundaTela extends StatelessWidget{
  String nome;
  int idade;

  SegundaTela({super.key, required this.nome, required this.idade});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Segunda Tela'),
      backgroundColor: Colors.green.shade800,
      ),
      body: Center(
        child: Column(
          children: [
            Text('Nome: $nome'),
            Text('Idade: $idade'),
            ElevatedButton(onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Voltar para primeira Tela'),
            )
          ],
        ),
      ),
    );
  }
}