import 'package:cauculadora/result_page.dart';
import 'package:flutter/material.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

  class _CalculatorPageState extends State<CalculatorPage>{
    // Controlador dos input
    final TextEditingController numero1Controlador = TextEditingController();
    final TextEditingController numero2Controlador = TextEditingController();
  
  // Criando variavel
  String operacao = '+';

  // Função Vazia
  void calcular(){
    // Verificação se os campos estão vazios
    if (numero1Controlador.text.isEmpty || numero2Controlador.text.isEmpty) return;
  
  // Pegando os valores Digitados no campo de texto
    double num1 = double.parse(numero1Controlador.text);
    double num2 = double.parse(numero2Controlador.text);

    double resultado = 0;
    
    // Faz a operação apartir do que foi selecionado
    switch (operacao){
      case '+':
        resultado = num1 + num2;
        break;
      case '-':
        resultado = num1 - num2;
        break;
      case '*':
        resultado = num1 * num2;
        break;
      case '/':
        resultado = num1 / num2;
        break;
    }

  // Navega para tela de resultado levando as variaveis
  Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => ResultPage(num1: num1, num2: num2, operacao: operacao, resultado: resultado))
    );
    
  }

    @override
    Widget build(BuildContext context){
      return Scaffold(
        appBar: AppBar(title: Text('Calculadora do terceirão'),),
        body: Padding(padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Campos formulário
            TextField(
              controller: numero1Controlador,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Némero 1',
                border: OutlineInputBorder()
              ),
            ),
            SizedBox(height: 16),
            // Outro campo
            TextField(
              controller: numero2Controlador,
              keyboardType: TextInputType.number,
            decoration: InputDecoration(
                labelText: 'Némero 2',
                border: OutlineInputBorder()
              ),
            ),
            SizedBox(height: 16),
            // Dropdow (Select do HTML)
            DropdownButtonFormField(
              decoration: InputDecoration(
                labelText: 'Operação',
                border: OutlineInputBorder()
              ),
              items: [
                DropdownMenuItem(value: '+', child: Text('Adição ➕')),
                DropdownMenuItem(value: '-', child: Text('Subtração ➖')),
                DropdownMenuItem(value: '*', child: Text('Multiplicação ✖️')),
                DropdownMenuItem(value: '/', child: Text('Divisão ➗'))
              ],
              onChanged: (value) {
                setState(() {
                  // Aqui vamos trocar a operação
                  operacao = value!;
                });
              },
              ),
              SizedBox(height: 16),
              // Botão para fazer a operação
              ElevatedButton(
                onPressed: calcular,
                child: Text('Calcular 🍯')
                ),
          ],
        ),
        ),
      );
    }
  }