import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditarComponentePage extends StatefulWidget {
  // Variável para armazenar o componente a ser editado
  final Map<String, dynamic> componente;


  // Recebe o componente como parâmetro
  const EditarComponentePage({super.key, required this.componente});

  @override
  State<EditarComponentePage> createState() => _EditarComponentePageState();
}

class _EditarComponentePageState extends State<EditarComponentePage> {
  // variáveis para armazenar os campos do formulário
  final formKey = GlobalKey<FormState>();
  late final TextEditingController codigoController;
  late final TextEditingController nomeController;
  late final TextEditingController estoqueController;

  bool salvando = false;
  String? erro;

  @override
  void initState(){
    super.initState();

    // Inicializar os controladores de texto com os valores do componente recebido
    codigoController = TextEditingController(
      text: widget.componente['CODIGO']?.toString() ?? ''
    );

    nomeController = TextEditingController(
      text: widget.componente['NOME']?.toString() ?? ''
    );

    estoqueController = TextEditingController(
      text: widget.componente['ESTOQUE']?.toString() ?? ''
    );
  }

  // Criar a função que faz o envio (PUT) para a API
  Future<void> editarComponente() async{
    // validar o formuláio antes de enviar a API
    if(!formKey.currentState!.validate()){
      return;
    }

    // Criar um JSON com os dados do componente
    final dadosComponente = {
      'CODIGO': codigoController.text,
      'NOME': nomeController.text,
      'ESTOQUE': estoqueController.text,
    };

    // Atualiza o estado da tela para indicar que está sendo salvo e tembém limpa a mensagem deerro se estiver sendo exibida
    setState(() {
      salvando = true;
      erro = null;
    });

    // Tentar enviar os dados para a API
    try{
      // Capturar campo ID do registro para alteração
      final id = widget.componente['ID'];

      // Faz a requisição PUT para a API
      final response = await http.put(
        Uri.parse('http://127.0.0.1:8000/api/componentes/$id'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json'
        },
        body:  jsonEncode(dadosComponente)
      );

      // Capturar a resposta da API
      final resultado = response.body.isNotEmpty ?
      jsonDecode(response.body) : null;

      // Verifica se a atualização foi realizada com sucesso
      if(response.statusCode == 200){
      // Menssagem de sucesso
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(
          resultado['message'] ?? 'Componente atualizado!'
          ),
          backgroundColor: Colors.green,
        )
      );

      // Volta para a página de relatórios componente
      Navigator.pop(context, true);
    } else{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(
          'Erro ${response.statusCode}: ${response.body}'
        )
        )
      );
    }

    }catch (e){
      setState(() {
        erro = 'Erro ao acessar a API: $e';
        salvando = false;
      });
    }finally {
      if(mounted){
        setState(() {
          salvando = false;
        });
      }
    }
  }



  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF1F4E5F);
    const backgroundColor = Color(0xFFF2F4F5);
    const textColor = Color(0xFF263238);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: const Text(
          'Cadastro de Componentes',
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: const Color(0xFFE0E5E7),
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x12000000),
                    blurRadius: 14,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Dados do componente',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: codigoController,
                      maxLength: 20,
                      textCapitalization: TextCapitalization.characters,
                      decoration: const InputDecoration(
                        labelText: 'Código',
                        prefixIcon: Icon(Icons.qr_code_2_outlined),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Informe o código';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: nomeController,
                      maxLength: 100,
                      decoration: const InputDecoration(
                        labelText: 'Nome',
                        prefixIcon: Icon(Icons.memory_outlined),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Informe o nome';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: estoqueController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Estoque',
                        prefixIcon: Icon(Icons.inventory_2_outlined),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Informe o estoque';
                        }
                        final estoque = int.tryParse(value.trim());
                        if (estoque == null || estoque < 0) {
                          return 'Informe um estoque válido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 52,
                      child: FilledButton.icon(
                        onPressed: salvando ? null : editarComponente,
                        style: FilledButton.styleFrom(
                          backgroundColor: primaryColor,
                        ),
                        icon: const Icon(Icons.save_outlined),
                        label: const Text(
                          'ATUALIZAR',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
