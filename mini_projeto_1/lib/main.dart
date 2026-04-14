import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Mini Peojeto'),
          backgroundColor: const Color.fromARGB(255, 3, 135, 7),
          titleTextStyle: TextStyle(color: Colors.white),
          iconTheme: IconThemeData(color: Colors.white
          ),
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              Container(
                height: 80,
                child: const DrawerHeader(
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(16, 137, 10, 0.976)
                  ),
                  child: Text('Menu Lateral', style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
              ListTile(
                title: Text('Minha Conta'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Configurações'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Minhas Compras'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
        body: Padding(padding: EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Image.asset('Bandeira.png', height: 100,),
                  Image.asset('Bandeira.png', height: 100,),
                  Image.asset('Bandeira.png', height: 100,),
                ],
              ),
              SizedBox(height: 20),
              Text('Bem-vindo ao Mini Projeto 👋', style: TextStyle(fontSize: 20)),
              const SizedBox(height: 20,),
              ExemploMensagem()
            ],
          ),
      ),
      bottomNavigationBar: BottomNavigationBar(items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home,), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.circle_notifications), label: 'Notificações'),
        // BottomNavigationBarItem(icon: Icon(Icons.account_circle_outlined), label: 'Perfil'),  //botao de perfil, mas bugou, entao tirei
        BottomNavigationBarItem(icon: Icon(Icons.exit_to_app), label: 'Sair'),
        ]
      ),
    ),
    debugShowCheckedModeBanner: false,
    );
  }
}

class ExemploMensagem extends StatelessWidget{
  const ExemploMensagem({super.key});
  
  @override
  Widget build(BuildContext context) {
    return TextButton(onPressed: () => showDialog(
      context: context, 
      builder: (BuildContext context) => AlertDialog(
        title: Text('Mensagem de alerta'),
        content: Text('Texto da mensagem'),
        ), 
        ),
        style: TextButton.styleFrom(
          backgroundColor: const Color.fromARGB(16, 4, 170, 37)),
      child: Text('Clique aqui', style: TextStyle(color: Colors.white),));
  }
}