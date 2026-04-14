import "package:flutter/material.dart";

class TelaCadastro extends StatefulWidget {
  const TelaCadastro({super.key});

  @override
  State<TelaCadastro> createState() => _TelaCadastroState();
}

class _TelaCadastroState extends State<TelaCadastro>{
  // Controlador para pegar os calores
  final TextEditingController nomeFerramentaController = TextEditingController();
  final TextEditingController idFerramentaController = TextEditingController();
  final TextEditingController tipoFerramentaController = TextEditingController();
  final TextEditingController fabricanteFerramentaController = TextEditingController();
  final TextEditingController qntestoqueFerramentaController = TextEditingController();
  final TextEditingController localizacaoFerramentaController = TextEditingController();
  final TextEditingController dataaquisicaoFerramentaController = TextEditingController();
  final TextEditingController obsFerramentaController = TextEditingController();

void cadastrar(){
    Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => exibir()));
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tela de cadastro'),),
      body: Padding(padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Campos do formulário
          // Campo nome
          TextField(
            controller: nomeFerramentaController,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: 'Nome da Ferramenta',
              border: OutlineInputBorder()
            ), 
          ),
          SizedBox(height: 16),

          // Campo ID
          TextField(
            controller: tipoFerramentaController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'ID da Ferramenta',
              border: OutlineInputBorder()
            ), 
          ),
          SizedBox(height: 16),

          // Dropdow ferramenta
          DropdownButtonFormField(
              decoration: InputDecoration(
                labelText: 'Tipo ferramenta',
                border: OutlineInputBorder()
              ),
              items: [
                DropdownMenuItem(value: 'Manual', child: Text('Manual')),
                DropdownMenuItem(value: 'Eletrica', child: Text('Elétrica')),
                DropdownMenuItem(value: 'Medição', child: Text('Medição')),
                DropdownMenuItem(value: 'Outros', child: Text('Outros...'))
              ],
              onChanged: (value) {
                setState(() {
                  value!;
                });
              }
              ),
          SizedBox(height: 16),

        // Campo fabricante
          TextField(
            controller: fabricanteFerramentaController,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: 'Fabricante da ferramenta',
              border: OutlineInputBorder()
            ), 
          ),
          SizedBox(height: 16),

        // Campo quantidade estoque  
          TextField(
            controller: qntestoqueFerramentaController,
            keyboardType: TextInputType.number, //
            decoration: InputDecoration(
              labelText: 'Quantidade no estoque',
              border: OutlineInputBorder()
            ), 
          ),
          SizedBox(height: 16),

        // Campo localização no depósito
          TextField(
            controller: localizacaoFerramentaController,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: 'Localização',
              border: OutlineInputBorder()
            ), 
          ),
          SizedBox(height: 16),

        // Campo data de aquisção
          TextField(
            controller: dataaquisicaoFerramentaController,
            keyboardType: TextInputType.datetime, // ajuda
            decoration: InputDecoration(
              labelText: 'Quando foi adquirida',
              border: OutlineInputBorder()
            ), 
          ),
          SizedBox(height: 16),

        // Campo obs
          TextField(
            controller: obsFerramentaController,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
              labelText: 'Observação',
              border: OutlineInputBorder()
            ), 
          ),
          SizedBox(height: 16),

          ElevatedButton(
            onPressed: cadastrar,
            child: Text('Cadastrar 🔧')
            ),
        ],
      ),
      ),
      );
  }
}
