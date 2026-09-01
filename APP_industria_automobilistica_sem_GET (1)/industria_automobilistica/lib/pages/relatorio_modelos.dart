import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RelatorioModelosPage extends StatefulWidget {
  const RelatorioModelosPage({super.key});

  @override
  State<RelatorioModelosPage> createState() => _RelatorioModelosPageState();
}

class _RelatorioModelosPageState extends State<RelatorioModelosPage> {
  final ScrollController horizontalController = ScrollController();

  // Cria uma lista que armanezará os modelos pela API
  List<dynamic> modelos = []; 

  // indica se os dados ainda estão sendo carregados.
  // Começa com true porque a consulta será feita ao abrir a pág
  bool carregando = true;

  // Armazena um possível erro
  String? erro;

  @override
  // Função que vai executar ao abrir a tela
  void initState() {
    // Configuração para iniciar a tela
    super.initState();

    // Chama a função que chgama na API
    consultaModelos();
  }

  // Cria a função que faz a busca na API
  Future<void> consultaModelos() async {
    try {
      // Faz uma requisição HTTP do tipo GET para API.
      final response = await http.get(
        // Converte o endereço da API para um objeto URI;
        Uri.parse('http://127.0.0.1:8000/api/modelos'),

        // Informa à API que o aplicativo espera receber a resposta em JSON
        headers: {
          'Accept': 'application/json',
        }
      );

      // converte o texto JSON para um objeto Dart.
      final resultado = jsonDecode(response.body);

      // Verifica se a requisição foi concluída com sucesso.
      if (response.statusCode == 200) {
        // Atualiza o estado da tela.
        setState(() {
          // Armazenar os dados retornados pela API
          // Caso seja nulo, deixo a lista vazia
          modelos = resultado['data'] ?? [];

          // Parar o loader
          carregando = false;
        });
      } else {
        // Se API retornar erro, exibir erro na tela
        setState(() {
          erro = resultado['message'] ?? [];

          carregando = false;
        });
      }
    } catch (e) {
      setState(() {
        erro = 'Erro: $e';
        carregando = false;
      });
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Relatório de Modelos'),
        // Adicionar um botão lateral de atualizção
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                carregando = true;
                erro = null;
              });

              consultaModelos();
            }, 
            icon: Icon(Icons.refresh)
          )
        ],
      ),
      body: 
      // Verifica se os dados ainda estão senco carregados. Se sim exibe o loader
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
                    'Nome',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Categoria',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Ano do modelo',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Ativo',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
              rows: modelos.map<DataRow>((modelo){
                final ativo = modelo['ATIVO'].toString();

                return DataRow(
                  cells: [
                    DataCell(
                      Text(modelo['NOME'].toString()),
                    ),
                    DataCell(
                      Text(modelo['CATEGORIA'].toString()),
                    ),
                    DataCell(
                      Text(modelo['ANO_MODELO'].toString()),
                    ),
                    DataCell(
                      Text(ativo == '1' ? 'Sim' : 'Não'),
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