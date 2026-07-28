import 'package:flutter/material.dart';
import 'package:industria_alimenticia/pages/cadastro_page.dart';
import 'package:industria_alimenticia/pages/home_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // Armazena o índice da página atualmente selecionada
  int indiceAtual = 0;

  // Lista das páginas que podem ser exibidas na aplicação 
  final paginas = [
    HomePage(),
    CadastroPage()
  ];

  // Lista de títulos exibidos na AppBar de acordo com a página.
  final titulos =[
    'Início',
    'Cadastro'
  ];

  void selecionarPagina(int indice){
    setState(() {
      indiceAtual = indice;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Barra superior que exibe o título da página atual
      appBar: AppBar(
        title: Text(titulos[indiceAtual]),
        backgroundColor: Colors.green,
      ),
    );
  }
}