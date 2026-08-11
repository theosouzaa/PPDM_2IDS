import 'package:flutter/material.dart';
import 'package:industria_alimenticia/pages/json_page.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  // Chave utilizada para verificar o formulário
  final formKey = GlobalKey<FormState>();

  // Controladores dos compos do form
  final nomeController = TextEditingController();
  final quantidadeController = TextEditingController();
  String categoria = 'Lativínios';

  // Função que valida o form e cria um json na outra página.
  void enviarFormulario(){
    // verifica se algum campo está vazio
    if (!formKey.currentState!.validate()) {
      return;
    }

    // Cria um JSON com os dados que o usuário digitou
    final dadosProduto = {
      'nome': nomeController.text,
      'categoria': categoria,
      'quantidade': int.parse(quantidadeController.text),
    };

    // Mandar para página responsável por exibir o JSON
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => JsonPage(
        dadosProduto: dadosProduto
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            // Campo do nome produto
            TextFormField(
              controller: nomeController,
              decoration: InputDecoration(
                labelText: 'Nome do produto',
                border: OutlineInputBorder(),
              ),
              // Validação do campo
              validator: (value) {
                if (value == null) {
                  return 'Informe o nome';
                }
                return null;
              },
            ),
            // Espaço pro outro campo do form
            SizedBox(height: 20),
            TextFormField(
              controller: quantidadeController,
              decoration: InputDecoration(
                labelText: 'Quantidade',
                border: OutlineInputBorder(),
              ),
              // Validação do campo
              validator: (value) {
                if (int.tryParse(value ?? '') == null) {
                  return 'Informe uma quantidade válida';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            // Botão que valida o for e gerar um formato JSON
            ElevatedButton(
              onPressed: enviarFormulario,
              child: Text('Gerar JSON')
            )
          ],
        ),
      ),
    );
  }
}