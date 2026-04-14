import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MeuAplicativo());
}

class MeuAplicativo extends StatelessWidget{
  const MeuAplicativo({Key? key}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TelaPrincipal(),
    );
  }
}

class TelaPrincipal extends StatefulWidget{
  const TelaPrincipal({Key? key}) : super(key: key);

  @override
  State createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal>{
  final List<String> _frases =[
    'Boa tarde, o dia está lindo! 🌞', 
    'Vou treinar costas 💪🏼', 
    'Vou treinar na minha moto🏍️',
    'Toda realidade foi sonhada🙏🏼', 
    'O SENAI é vida❤️🙌🏼'
  ];

  String _fraseGerada = "Clique abaixo para gerar uma frase reflexiva";

  void gerarFrase(){
    int numeroAleatrio = Random().nextInt(_frases.length);

    setState(() {
      _fraseGerada = _frases[numeroAleatrio];
    });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Frases do 3ºB 🌪️'),
        backgroundColor: Colors.purple[800],
        centerTitle: true,
        titleTextStyle: TextStyle(color: const Color.fromARGB(255, 224, 204, 27)),
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(_fraseGerada),
            ElevatedButton(onPressed: gerarFrase, style: ElevatedButton.styleFrom(backgroundColor: Colors.purple[800]), child: Text('Gerar um frase motivacional', style: TextStyle(color: Colors.white),))
          ],
        ),
      ),
    );
  }
}