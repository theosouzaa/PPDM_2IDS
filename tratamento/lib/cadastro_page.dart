import 'package:flutter/material.dart';

class CadastroPage extends StatefulWidget {
  @override
  _CadastroPageState createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  // Criando Controllers dos campos para pegar informações
  TextEditingController nomeController = TextEditingController();

  // Criando variável do tipo lista
  List<String> nomes = [];
  
  // Função de adicionar o nome
  void adicionarNome(){
    // Verificando se o nome foi preenchido
    if(nomeController.text.isEmpty){
      // Mostrar mensagem para o usuário
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Campo nome obrigatório!')));

      return;
    }

    // Atualiza interface
    setState(() {
      // Adicionar o 
      nomes.add(nomeController.text);

      // limpa o campo após cadastrar
      nomeController.clear();
    });
  }

  // Função para remover o nome do array
  void removerNome(int index){
  // Atualiza o estado da tela
  setState((){
    // Remover nome do array no index
    nomes.removeAt(index);
  });
}

  @override
  Widget build(BuildContext context) {
    // Barra superior do App
      return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de Usuários'),
      ),
      // Corpo da página
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            // Filho do padding
            child: Row(
              children: [
                // Campo que ocupa o espaço disponível
                Expanded(
                  child: TextField(
                    controller: nomeController,
                    decoration: InputDecoration(
                      labelText: 'Digite um nome',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                // Espaçamento
                SizedBox(width: 10),
                // Botão
                ElevatedButton(
                  onPressed: adicionarNome,
                  child: Text('Adicionar'),
                ),
              ],
            ),
          ),

          // lista de nomes cadastrados
          Expanded(
            child: ListView.builder(
              // quantidade de itens da lista (Array)
              itemCount: nomes.length,
              // Montar item por item da lista
              itemBuilder: (context, index) {
                // Criar uma variável da posição atual
                final nome = nomes[index];

                // Wideget que permite arrastar para excluir
                return Dismissible(
                  key: UniqueKey(),
                  
                  // Direção do swipe (Direita para a esquerda)
                  direction: DismissDirection.endToStart,

                  // Evento disparado quando a pessoa soltar 
                  onDismissed: (direction) {
                    // Deleta item da lista
                    removerNome(index);

                    // Mostrar mensagem de sucesso na parte inferior
                    ScaffoldMessenger.of(context).
                    showSnackBar(SnackBar(content: Text("Nome Removido com sucesso!")));

                  },

                  // Fundo após o usuário arrastar
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 20),
                    child: Icon(Icons.delete, color: Colors.white,),
                  ),
                  child: ListTile(title: Text(nome),)
                );
              },
            )
          )
        ],
      ),
    );
  }
}