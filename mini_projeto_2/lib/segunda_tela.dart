import 'package:flutter/material.dart';

class SegundaTela extends StatelessWidget{
  String nome;
  int idade;
  String contato;
  String cursos;
  String filmes;
  String serie;

  SegundaTela({super.key, required this.nome, required this.idade, required this.contato,
  required this.cursos, required this.filmes, required this.serie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Segunda Tela'),
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      titleTextStyle: TextStyle(color: const Color.fromARGB(255, 255, 255, 255)),
      ),
      body: Center(
        child: Column(
          children: [
            Text('Nome: $nome'),
            Text('Idade: $idade'),
            Text('Contato: $contato'),
            Text('Cursos: $cursos'),
            Text('Filmes: $filmes'),
            Text('Série: $serie'),
            Image.asset('curintia.jpg', height: 300,),
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