
import 'package:flutter/material.dart';
import 'package:mini_projeto_2/segunda_tela.dart';

class TelaPrincipal extends StatelessWidget{
  const TelaPrincipal({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text('Tela Principal de curiosidades sobre mim'),
      backgroundColor: Colors.black,
      titleTextStyle: TextStyle(color: const Color.fromARGB(255, 255, 255, 255)),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(context, 
            MaterialPageRoute(builder: (context) => SegundaTela(nome: "Théo", idade: 18,
            contato: "(19) 89677-3455", cursos: "Técnico de desenvolvimento de sistemas",
            filmes: "Gente grande e Se beber não case", serie: "Yellowstone")
            )
            );
          },
          child: Text('Ir para a segunda tela com as curiosidades.'),
        ),
      ),
    );
  }
}