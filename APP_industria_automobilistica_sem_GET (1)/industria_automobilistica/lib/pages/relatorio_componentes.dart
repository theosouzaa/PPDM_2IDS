import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RelatorioComponentesPage extends StatefulWidget {
  const RelatorioComponentesPage({super.key});

  @override
  State<RelatorioComponentesPage> createState() => _RelatorioComponentesPageState();
}

class _RelatorioComponentesPageState extends State<RelatorioComponentesPage> {
  final ScrollController horizontalController = ScrollController();

  // Criar uma lista que armazenará os componentes pela API.
  List<dynamic> componentes = [];

  // Indica se os dados ainda estão sendo carregados
  // Começa como true porque a consulta será feita ao abrir a página
  bool carregando = true;

  // Armazena um possível erro
  String? erro;

  @override
  // Função que vai executar ao abrir a tela
  void initState(){
    // configuração para iniciar a tela
    super.initState();

    // chama a função que faz a consulta na API
    consultaComponentes();
  }

  // Criar a função que faz a busca na API
  Future<void> consultaComponentes() async {
    try{
      // faz uma requisição HTTP do tipo GET para a API.
      final response = await http.get(
        // Converte o endereço da API para um objeto URI.
      Uri.parse('http://127.0.0.1:8000/api/componentes'),

      // Informa à API que o aplicativo espera receber a resposta em JSON
        headers: {
          'Accept': 'application/json',
        }
      );

      // Converte o texto em JSON para um objeto Dart.
      final resultado = jsonDecode(response.body);

      // Verifica se a requisição foi concluída com sucesso.
      if(response.statusCode == 200){
        // Atualiza o estado da tela com as infirmações
        setState(() {
          // Armazenar os dados retornados pela API
          // Caso seja nulo, deixa a lista vazia.
          componentes = resultado['data'] ?? [];

          // Parar o loader
          carregando = false;
        });
      } else {
        // Se a API retornar erro, exibe este erro na tela
        // Atualiza o estado da página
        setState(() {
          erro = resultado['message'] ?? [];

          carregando = false;
        });
      }
    }catch(e){
      setState(() {
        erro =  'Erro: $e';
        carregando = false;
      });
    }
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Relatório de Componentes'),
        // Adicionar um botão lateral de atualização
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                carregando = true;
                erro = null;
              });

              consultaComponentes();
            },
            icon: Icon(Icons.refresh_rounded)
          )
        ],
      ),
      body:
      // Verifica se os dados ainda estão sendo carregados
      // Se sim, exibe o loader
      carregando
      ? const Center(child: CircularProgressIndicator())
      : erro != null ?
      Center(
        child: Text(erro!, style: TextStyle(color: Colors.red),),
        ) :
      Padding(
        padding: const EdgeInsets.all(24),
        child: Scrollbar(
          controller: horizontalController,
          thumbVisibility: true,
          trackVisibility: true,
          scrollbarOrientation: ScrollbarOrientation.bottom,
          child: SingleChildScrollView(
            controller: horizontalController,
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(
                const Color(0xFFE7F0F2),
              ),
              border: TableBorder.all(
                color: const Color(0xFFE0E5E7),
                borderRadius: BorderRadius.circular(8),
              ),
              columns: const [
                DataColumn(
                  label: Text(
                    'Código',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Nome',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Estoque',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
              rows: componentes.map<DataRow>((componente){
                return DataRow(
                  cells: [
                    DataCell(
                     Text(componente['CODIGO'].toString()),
                    ),

                    DataCell(
                     Text(componente['NOME'].toString()),
                    ),

                    DataCell(
                     Text(componente['ESTOQUE'].toString()),
                    ),
                  ]
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}