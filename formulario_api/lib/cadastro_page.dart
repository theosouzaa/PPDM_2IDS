import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CadastroPage extends StatefulWidget{
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  // Chave de validação do formulário
  final _formKey = GlobalKey<FormState>();

  // Declaração das variáveis dos controladores dos campos
  final nomeController = TextEditingController(); 
  final cpfController = TextEditingController();
  final emailController = TextEditingController();
  final cepController = TextEditingController();
  final logradouroController = TextEditingController();
  final numeroController = TextEditingController();
  final bairroController = TextEditingController();
  final cidadeController = TextEditingController();
  final estadoController = TextEditingController();

  // Criando variáveis das mascaras dos campos
  final cpfMask = MaskTextInputFormatter(mask: '###.###.###-##');
  final cepMask = MaskTextInputFormatter(mask: '#####-###');

  // Função que vai buscar o CEP no site do VIACEP
  void buscarCep() async{
    try {
      // Pegar o valor do CEP digitado e pesquisar o site no VIACEP
      Dio dio = Dio();
      String url = 'https://viacep.com.br/ws/${cepController.text}/json/';

      // Pesquisa no site do viacep
      Response respostaSite = await dio.get(url);

      // Verificar se deu certo
      if (respostaSite.statusCode == 200 && respostaSite.data['erro'] != true) {  // Se entrar a requisição deu certo
        setState(() {
          // coloca as informações no campo do Logradouro
          logradouroController.text = respostaSite.data['logradouro'] ?? "";
          // Coloca as informações no campo do bairro
          bairroController.text = respostaSite.data['bairro'] ?? "";
          // Coloca as informações no campo do cidade
          cidadeController.text = respostaSite.data['localidade'] ?? "";
          // Coloca as informações no campo do estado
          estadoController.text = respostaSite.data['uf'] ?? "";
        });

      } else {
        // Se o CEP não for encontrado manda uma mensagem para o usuário
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('CEP não encontrado! Tente novamente')));
      }

    } catch (e) {
      // Se não conseguir buscar no site
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao buscar o CEP!')));

      }
    }
  
  Widget _campo({
    required String label,
    required TextEditingController controller,
    List<TextInputFormatter>? mask,
    String? Function(String?)? validator,
    bool bloqueado = false,
  }){
    // Campos do formulário
      return Padding(
        padding: EdgeInsets.only(bottom: 12),
        child: TextFormField(
          controller: controller,
          keyboardType: TextInputType.text,
          inputFormatters: mask,
          validator: validator,
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(),
            filled: bloqueado,
            fillColor: bloqueado ? Colors.grey[200]: null
          ),
        ),
      );
    }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Página de Cadastro'),
        centerTitle: true,
        backgroundColor: Colors.pink,
        titleTextStyle: TextStyle(color: Colors.white),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          // Campo chave para as validações do formulário
          key: _formKey,
          child: ListView(
            children: [
              // Campo nome completo com o whidget _campo
              _campo(
                label: 'Nome Completo',
                controller: nomeController,
                validator: (value) => value!.isEmpty? 'Informe o nome completo.' : null
              ),
            _campo(
              label: 'CPF',
              controller: cpfController,
              mask: [cpfMask],
              validator: (value) => value!.length < 14 ? 'Digite um CPF válido!' : null
             ),

             // Campo E-mail com o whidget _campo
             _campo(
              label: 'E-mail',
             controller: emailController,
             validator: (value) => value!.contains('@') ? null : 'Digite um E-mail válido.'
             ),

            // Campo CEP + botão para pesquisa
            Row(
              children: [
                Expanded(
                  child: _campo(
                    label: 'CEP',
                    controller: cepController,
                    mask: [cepMask],
                    validator: (value) => value!.length < 9 ? 'CEP inválido' : null
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: buscarCep,
                    child: Text('Buscar CEP'),
                    ),
              ]
            ),

            // Reutilizando o widget do campo form
            _campo(
              label: 'Logadrouro',
              controller: logradouroController,
              bloqueado: true,
              validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null
              ),

              // Campo Número
              _campo(
              label: 'Número',
              controller: numeroController,
              validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null
              ),

              // Campo Bairro
              _campo(
              label: 'Bairro',
              controller: bairroController,
              bloqueado: true,
              validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null
              ),

              // Campo Cidade
              _campo(
              label: 'Cidade',
              controller: cidadeController,
              bloqueado: true,
              validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null
              ),

              // Campo estado
              _campo(
              label: 'Estado',
              controller: estadoController,
              bloqueado: true,
              validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null
              ),

              // Caixa de espaço
              SizedBox(height: 20),
              // Botão de envio do formulário
              ElevatedButton(onPressed: () {
                if (_formKey.currentState!.validate()) {
                  ScaffoldMessenger.of(context).
                  showSnackBar(SnackBar(content: Text('Cadastro efetuado!')));
                }
              },
              child: Text('Cadastrar')
              )
            ],
          ),
        ),
      ),
    );
  }
}