import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CadastroPage extends StatefulWidget {
  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {

  // Controllers
  final nomeController = TextEditingController();
  final telefoneController = TextEditingController();

  // Máscara telefone
  final telefoneMask = MaskTextInputFormatter(
    mask: '(##) #####-####',
  );

  // Lista de usuários
  List<Map<String, String>> usuarios = [];

  // Adicionar usuário
  void adicionarUsuario() {

    if (nomeController.text.isEmpty ||
        telefoneController.text.isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Preencha todos os campos'),
        ),
      );

      return;
    }

    setState(() {

      usuarios.add({
        'nome': nomeController.text,
        'telefone': telefoneController.text,
      });

      // Limpar campos
      nomeController.clear();
      telefoneController.clear();
    });
  }

  // Remover usuário
  void removerUsuario(int index) {

    setState(() {
      usuarios.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: Text('Cadastro de Usuários'),
      ),

      body: Padding(
        padding: EdgeInsets.all(10),

        child: Column(
          children: [

            // Campo nome
            TextField(
              controller: nomeController,

              decoration: InputDecoration(
                labelText: 'Nome',
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 10),

            // Campo telefone
            TextField(
              controller: telefoneController,

              keyboardType: TextInputType.phone,

              inputFormatters: [
                telefoneMask,
              ],

              decoration: InputDecoration(
                labelText: 'Telefone',
                hintText: '(19) 99999-9999',
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 10),

            // Botão adicionar
            SizedBox(
              width: double.infinity,

              child: ElevatedButton(
                onPressed: adicionarUsuario,
                child: Text('Adicionar'),
              ),
            ),

            SizedBox(height: 20),

            // Lista
            Expanded(
              child: ListView.builder(

                itemCount: usuarios.length,

                itemBuilder: (context, index) {

                  return Dismissible(

                    key: UniqueKey(),

                    // Arrastar da direita para esquerda
                    direction: DismissDirection.endToStart,

                    // Fundo vermelho
                    background: Container(
                      color: Colors.red,
                      padding: EdgeInsets.only(right: 20),
                      alignment: Alignment.centerRight,

                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),

                    // Quando excluir
                    onDismissed: (direction) {

                      removerUsuario(index);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Usuário removido!',
                          ),
                        ),
                      );
                    },

                    // Item da lista
                    child: Card(
                      child: ListTile(

                        leading: CircleAvatar(
                          child: Icon(Icons.person),
                        ),

                        title: Text(
                          usuarios[index]['nome']!,
                        ),

                        subtitle: Text(
                          usuarios[index]['telefone']!,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}