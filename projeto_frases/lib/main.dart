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
  final List<String> _dicas =[
    'Use a técnica 25–30 minutos estudando + 5 minutos de pausa. Isso ajuda o cérebro a manter o foco e evita cansaço. ⏱️', 
    'Evite copiar tudo. Use palavras-chave, esquemas ou mapas mentais para fixar melhor. 📝', 
    'Só ler não é suficiente.Resolver exercícios faz o cérebro aprender de verdade. ✍️',
    'Deixe o celular longe ou em modo silencioso. Menos distração = mais aprendizado. 📵', 
    '💡 Dica bônus: Antes de começar a estudar, defina uma meta clara, por exemplo: “Hoje vou entender 2 capítulos.” “Hoje vou resolver 20 exercícios.”'
  ];

  String _dicaGerada = "Clique abaixo para gerar uma dica de estudo bem eficiente";

  void gerarDica(){
    int numeroAleatrio = Random().nextInt(_dicas.length);

    setState(() {
      _dicaGerada = _dicas[numeroAleatrio];
    });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Dicas eficientes para melhorar seus estudos 🧑🏼‍🎓📚'),
        backgroundColor: Colors.blue[900],
        centerTitle: true,
        titleTextStyle: TextStyle(color: Colors.white),
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('meninoEstudando.jpg', width: 300),
            Text(_dicaGerada),
            ElevatedButton(onPressed: gerarDica, style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[900]), child: Text('Gerar uma dica eficiente', style: TextStyle(color: Colors.white),))
          ],
        ),
      ),
    );
  }
}