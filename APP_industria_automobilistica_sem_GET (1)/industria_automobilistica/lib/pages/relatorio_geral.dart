import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RelatorioGeralPage extends StatefulWidget {
  const RelatorioGeralPage({super.key});

  @override
  State<RelatorioGeralPage> createState() => _RelatorioGeralPageState();
}

class _RelatorioGeralPageState extends State<RelatorioGeralPage> {
  // URL base da API.
  static const String baseUrl = 'http://127.0.0.1:8000/api';

  // Indica se os dados estão sendo carregados.
  bool carregando = true;

  // Armazena uma possível mensagem de erro.
  String? erro;

  // Quantidade de registros encontrados.
  int totalModelos = 0;
  int totalComponentes = 0;
  int totalFornecedores = 0;
  int estoqueBaixo = 0;

  @override
  void initState() {
    super.initState();

    // Consulta os dados assim que a página é aberta.
    consultarDados();
  }

  // Faz uma requisição para um endpoint da API.
  Future<List<dynamic>> consultar(String endpoint) async {
    final response = await http.get(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {
        'Accept': 'application/json',
      },
    );

    final resultado = jsonDecode(response.body);

    // Verifica se a API retornou sucesso.
    if (response.statusCode != 200) {
      throw Exception(
        resultado['message'] ?? 'Erro ao consultar API',
      );
    }

    // Retorna os dados recebidos.
    return resultado['data'] ?? [];
  }

  // Consulta todos os dados necessários para o relatório.
  Future<void> consultarDados() async {
    setState(() {
      carregando = true;
      erro = null;
    });

    try {
      // Faz as três consultas simultaneamente.
      final resultados = await Future.wait([
        consultar('modelos'),
        consultar('componentes'),
        consultar('fornecedores'),
      ]);

      if (!mounted) return;

      setState(() {
        // Atualiza as quantidades.
        totalModelos = resultados[0].length;
        totalComponentes = resultados[1].length;
        totalFornecedores = resultados[2].length;

        carregando = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        erro = e.toString();
        carregando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Lista de indicadores exibidos nos cards.
    final List<Map<String, dynamic>> indicadores = [
      {
        'titulo': 'Modelos',
        'valor': totalModelos.toString(),
        'icone': Icons.directions_car,
      },
      {
        'titulo': 'Componentes',
        'valor': totalComponentes.toString(),
        'icone': Icons.settings,
      },
      {
        'titulo': 'Fornecedores',
        'valor': totalFornecedores.toString(),
        'icone': Icons.local_shipping,
      },
      {
        'titulo': 'Estoque baixo',
        'valor': estoqueBaixo.toString(),
        'icone': Icons.warning_amber_rounded,
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        title: const Text('Relatório Geral'),
        backgroundColor: const Color(0xFF164E63),
        foregroundColor: Colors.white,
      ),
      body: _buildBody(indicadores),
    );
  }

  Widget _buildBody(List<Map<String, dynamic>> indicadores) {
    // Enquanto os dados estão sendo carregados.
    if (carregando) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // Caso aconteça algum erro.
    if (erro != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 60,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              const Text(
                'Não foi possível carregar o relatório.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                erro!,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: consultarDados,
                icon: const Icon(Icons.refresh),
                label: const Text('Tentar novamente'),
              ),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Visão geral',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: indicadores.length,
            gridDelegate:
                const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 300,
              mainAxisExtent: 160,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemBuilder: (context, index) {
              final item = indicadores[index];

              return Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        item['icone'] as IconData,
                        size: 32,
                        color: const Color(0xFF0E7490),
                      ),

                      const Spacer(),

                      Text(
                        item['valor'].toString(),
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Text(
                        item['titulo'].toString(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}