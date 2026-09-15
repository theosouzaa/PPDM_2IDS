import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditarModeloPage extends StatefulWidget {
  // Variável para armazenar o modelo a ser editado
  final Map<String, dynamic> modelo;


  // Recebe o modelo como parâmetro
  const EditarModeloPage({super.key, required this.modelo});

  @override
  State<EditarModeloPage> createState() => _EditarModeloPageState();
}

class _EditarModeloPageState extends State<EditarModeloPage> {
  // variáveis para armazenar os campos do formulário
  final formKey = GlobalKey<FormState>();
  late final TextEditingController nomeController;
  late final TextEditingController anoController;
  bool ativo = true;
  String? categoria;

  final categorias = [
    'HATCH',
    'SEDAN',
    'SUV',
    'PICAPE',
  ];

  bool salvando = false;
  String? erro;

  @override
  void initState(){
    super.initState();

    // Inicializar os controladores de texto com os valores do modelo recebido
    nomeController = TextEditingController(
      text: widget.modelo['NOME']?.toString() ?? ''
    );

    anoController = TextEditingController(
      text: widget.modelo['ANO_MODELO']?.toString() ?? ''
    );

    categoria = widget.modelo['CATEGORIA']?.toString();

    // Se for igual a 1, então o checkbox fica marcado (ativo), caso contrário, fica desmarcado
    ativo = widget.modelo['ATIVO'].toString() == '1';
  }

  // Criar a função que faz o envio (PUT) para a API
  Future<void> editarModelo() async{
    // validar o formuláio antes de enviar a API
    if(!formKey.currentState!.validate()){
      return;
    }

    // Criar um JSON com os dados do modelo
    final dadosModelo = {
      'NOME': nomeController.text,
      'ANO_MODELO': anoController.text,
      'ATIVO': ativo ? '1' : '0',
    };

    // Atualiza o estado da tela para indicar que está sendo salvo e tembém limpa a mensagem deerro se estiver sendo exibida
    setState(() {
      salvando = true;
      erro = null;
    });

    // Tentar enviar os dados para a API
    try{
      // Capturar campo ID do registro para alteração
      final id = widget.modelo['ID'];

      // Faz a requisição PUT para a API
      final response = await http.put(
        Uri.parse('http://127.0.0.1:8000/api/modelos/$id'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json'
        },
        body:  jsonEncode(dadosModelo)
      );

      // Capturar a resposta da API
      final resultado = response.body.isNotEmpty ?
      jsonDecode(response.body) : null;

      // Verifica se a atualização foi realizada com sucesso
      if(response.statusCode == 200){
      // Menssagem de sucesso
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(
          resultado['message'] ?? 'Modelo atualizado!'
          ),
          backgroundColor: Colors.green,
        )
      );

      // Volta para a página de relatórios modelo
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
          'Cadastro de Modelos',
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
                      'Dados do modelo',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: nomeController,
                      maxLength: 100,
                      decoration: const InputDecoration(
                        labelText: 'Nome',
                        prefixIcon: Icon(Icons.directions_car_outlined),
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
                    DropdownButtonFormField<String>(
                      initialValue: categoria,
                      decoration: const InputDecoration(
                        labelText: 'Categoria',
                        prefixIcon: Icon(Icons.category_outlined),
                        border: OutlineInputBorder(),
                      ),
                      items: categorias.map((item) {
                        return DropdownMenuItem(
                          value: item,
                          child: Text(item),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          categoria = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Selecione a categoria';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: anoController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Ano do modelo',
                        prefixIcon: Icon(Icons.calendar_month_outlined),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Informe o ano';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Informe um ano válido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text(
                        'Modelo ativo',
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        ativo ? 'Ativo' : 'Inativo',
                      ),
                      value: ativo,
                      activeTrackColor: primaryColor,
                      onChanged: (value) {
                        setState(() {
                          ativo = value;
                        });
                      },
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 52,
                      child: FilledButton.icon(
                        onPressed: salvando ? null : editarModelo,
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