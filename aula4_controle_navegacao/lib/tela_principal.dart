import 'package:aula4_controle_navegacao/segunda_tela.dart';
import 'package:flutter/material.dart';

class TelaPrincipal extends StatelessWidget{
  const TelaPrincipal({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text('Tela Principal'),
      backgroundColor: Colors.green.shade800,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(context, 
            MaterialPageRoute(builder: (context) => SegundaTela(nome: "Théo", idade: 18),
            )
            );
          },
          child: Text('Ir para a segunda tela'),
        ),
      ),
    );
  }
}