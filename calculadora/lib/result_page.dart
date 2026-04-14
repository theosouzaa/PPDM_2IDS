import 'package:flutter/material.dart';

class ResultPage  extends StatelessWidget{
  final double num1;
  final double num2;
  final String operacao;
  final double resultado;

  const ResultPage({super.key,
  required this.num1,
  required this.num2,
  required this.operacao,
  required this.resultado
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Resultado')),
      body: Center(
        child: Card(
          elevation: 5, margin: EdgeInsets.all(20),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Equação: '),
                SizedBox(height: 10),
                Text('$num1 $operacao $num2'),
                Text('$resultado')
              ],
            ),
          ),
        ),
      ),
    );
  }
}