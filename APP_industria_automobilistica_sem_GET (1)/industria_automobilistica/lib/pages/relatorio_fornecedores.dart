import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RelatorioFornecedoresPage extends StatefulWidget {
  const RelatorioFornecedoresPage({super.key});

  @override
  State<RelatorioFornecedoresPage> createState() =>
      _RelatorioFornecedoresPageState();
}

class _RelatorioFornecedoresPageState
    extends State<RelatorioFornecedoresPage> {
  final ScrollController horizontalController = ScrollController();

  // Lista que armazenará os fornecedores retornados pela API.
  List<dynamic> modelos = [];

  // Indica se os dados ainda estão sendo carregados.
  bool carregando = true;

  // Armazena uma possível mensagem de erro.
  String? erro;

  @override
  void initState() {
    super.initState();

    // Consulta a API assim que a tela é aberta.
    consultaFornecedores();
  }

  // Função responsável por consultar a API.
  Future<void> consultaFornecedores() async {
    try {
      // Faz uma requisição HTTP GET para a API.
      final response = await http.get(
        Uri.parse(
          'http://127.0.0.1:8000/api/fornecedores',
        ),
        headers: {
          'Accept': 'application/json',
        },
      );

      // Converte o JSON recebido para um objeto Dart.
      final resultado = jsonDecode(response.body);

      // Verifica se a requisição foi realizada com sucesso.
      if (response.statusCode == 200) {
        setState(() {
          // Armazena os dados retornados pela API.
          modelos = resultado['data'] ?? [];

          // Finaliza o carregamento.
          carregando = false;

          // Limpa qualquer erro anterior.
          erro = null;
        });
      } else {
        setState(() {
          erro = resultado['message'] ??
              'Erro ao consultar fornecedores.';
          carregando = false;
        });
      }
    } catch (e) {
      setState(() {
        erro = 'Erro ao conectar com a API: $e';
        carregando = false;
      });
    }
  }

  @override
  void dispose() {
    horizontalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Relatório de Fornecedores'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: _buildConteudo(),
      ),
    );
  }

  Widget _buildConteudo() {
    // Exibe carregamento enquanto a API está sendo consultada.
    if (carregando) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // Exibe mensagem caso aconteça algum erro.
    if (erro != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 50,
              color: Colors.red,
            ),
            const SizedBox(height: 12),
            Text(
              erro!,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  carregando = true;
                  erro = null;
                });

                consultaFornecedores();
              },
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      );
    }

    // Caso a API não retorne fornecedores.
    if (modelos.isEmpty) {
      return const Center(
        child: Text(
          'Nenhum fornecedor encontrado.',
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      );
    }

    // Tabela de fornecedores.
    return Scrollbar(
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
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'CNPJ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Cidade',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Estado',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
          rows: modelos.map<DataRow>((modelo) {
            return DataRow(
              cells: [
                DataCell(
                  Text(
                    modelo['NOME']?.toString() ?? '-',
                  ),
                ),
                DataCell(
                  Text(
                    modelo['CNPJ']?.toString() ?? '-',
                  ),
                ),
                DataCell(
                  Text(
                    modelo['CIDADE']?.toString() ?? '-',
                  ),
                ),
                DataCell(
                  Text(
                    modelo['ESTADO']?.toString() ?? '-',
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}