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

  // Função que faz requisição assincrona para API mandando o Delete
  Future<void> excluirModelo(dynamic idModelo) async {
    try {
      final response = await http.delete(
        Uri.parse('http://127.0.0.1:8000/api/modelos/$idModelo'),
        headers: {
          'Accept': 'application/json',
          'content-Type': 'application/json'
        }
      );

      final resultado = response.body.isEmpty ?
      jsonDecode(response.body) : null;

      if (response.statusCode == 200) {
        // Exibe uma mensagem informando que o registro foi excluído
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Modelo excluído com sucesso'))
        );

        // Atualizar a lista de modelos apos a exclusão
        await consultaModelos();
        
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(resultado['message']))
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao acessar a API: $e'))
      );
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
                DataColumn(
                  label: Text(
                    'Ações',
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
                    // Nova célula para ações
                    DataCell(
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              // Capturar ID do registro para fazer Update no banco
                              final id = modelo['ID'];
                            },
                            icon: Icon(Icons.edit)
                          ),
                          IconButton(
                            onPressed: () async {
                              // Capturar ID do registro para fazer Delete no banco
                              final id = modelo['ID'];

                              // Exibe um diálogo de confirmação antes de excluir
                              final confirmacao = await showDialog<bool>(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text('Excluir Modelo'),
                                    content:
                                    Text('Deseja excluir o modelo ${modelo['NOME']}?'),
                                    actions: [
                                      // Botão de cancelar que fecha o diálogo e retorna false
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context, false);
                                        },
                                        child: Text('Cancelar')
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context, true);
                                        },
                                        child: Text('Excluir')
                                      ),
                                    ],
                                  );
                                }
                              );

                              if (confirmacao == true) {
                                await excluirModelo(id);
                              }
                            },
                            icon: Icon(Icons.delete, color: Colors.red,)
                          ),
                        ],
                      )
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