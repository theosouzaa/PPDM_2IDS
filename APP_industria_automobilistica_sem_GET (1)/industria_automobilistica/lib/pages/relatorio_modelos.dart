import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:industria_automobilistica/pages/editar_modelos.dart';

class RelatorioModelosPage extends StatefulWidget {
  const RelatorioModelosPage({super.key});

  @override
  State<RelatorioModelosPage> createState() => _RelatorioModelosPageState();
}

class _RelatorioModelosPageState extends State<RelatorioModelosPage> {
  final ScrollController horizontalController = ScrollController();

  // Criar uma lista que armazenará os modelos pela API.
  List<dynamic> modelos = [];

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
    consultaModelos();
  }

  // Criar a função que faz a busca na API
  Future<void> consultaModelos() async {
    // Reinicia o estado antes de cada consulta (usado também pelo botão de refresh)
    setState(() {
      carregando = true;
      erro = null;
    });

    try{
      // faz uma requisição HTTP do tipo GET para a API.
      final response = await http.get(
        // Converte o endereço da API para um objeto URI.
      Uri.parse('http://127.0.0.1:8000/api/modelos'),

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
          // Caso seja nulo, deixo a lista vazia.
          modelos = resultado['data'] ?? [];

          // Parar o loader
          carregando = false;
        });
      } else {
        // Se a API retornar erro, exibe este erro na tela
        // Atualiza o estado da página
        setState(() {
          erro = resultado['message']?.toString() ?? 'Erro ao carregar os modelos';

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

  // Função que faz requisição assíncrona para a API mandando o DELETE
  Future<void> excluirModelo(dynamic idModelo) async {
    try{
      final response = await http.delete(
        Uri.parse('http://127.0.0.1:8000/api/modelos/$idModelo'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json'
        }
      );

      final resultado = response.body.isNotEmpty ?
      jsonDecode(response.body) : null;

      if (!mounted) return;

      if(response.statusCode == 200){
        // Exibe uma mensagem mostrando que o registro foi excluido
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Modelo excluído com sucesso!'))
      );

      //Atualizar a listade modelos após a exclusão
      await consultaModelos();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(resultado['message']))
      );
      }
    }catch(e){
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao acessar API: $e'))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Relatório de Modelos'),
        // Adicionar um botão lateral de atualização
        actions: [
          IconButton(
            tooltip: 'Atualizar',
            // Desabilita o botão enquanto uma consulta já está em andamento
            onPressed: carregando ? null : consultaModelos,
            icon: const Icon(Icons.refresh),
          ),
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
                     Text(ativo == '1' ? 'Sim': 'Não'),
                    ),

                    // Nova célula para ações
                    DataCell(
                     Row(
                      children: [
                        IconButton(
                        onPressed: () async {
                          final atualizado = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) =>
                              EditarModeloPage(modelo: 
                              Map<String, dynamic>.from(modelo))
                            )
                          );

                          if(atualizado == true){
                            await consultaModelos();
                          }
                        },
                        icon: Icon(Icons.edit,
                        color: Colors.lightBlue.shade900,
                        )
                        ),
                        IconButton(
                        onPressed: () async {
                          // Capturar id do registro para fazer DELETE no banco
                          final id = modelo['ID'];

                          // Exibe um diálogo de confirmação antes de excluir 
                          final confirmacao = await showDialog<bool>(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Excluir modelo'),
                                content: Text('Deseja excluir o ${modelo['NOME']}?'),
                                actions: [
                                  // Botão de cancelamento que fecha o diálogo e retorna false
                                 TextButton(
                                  onPressed: () {
                                    Navigator.pop(context, false);
                                  }, 
                                  child: Text('Cancelar')
                                  ),
                                  // Botão de excluir que fecha o diálogo e retorna true
                                  TextButton(
                                  onPressed: () {
                                    Navigator.pop(context, true);
                                  },
                                  child: Text('Excluir', style: TextStyle(color: Colors.red))
                                  ),
                                ],
                              );
                            }
                          );

                          if(confirmacao == true){
                            await excluirModelo(id);
                          }
                        },
                        icon: Icon(Icons.delete,
                        color: Colors.red,
                        )
                        )
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