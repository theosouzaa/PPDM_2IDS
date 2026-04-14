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
          title: Text('Primeiro App'),
          backgroundColor: const Color.fromARGB(255, 10, 153, 2),
          titleTextStyle: TextStyle(color: Colors.white),
          centerTitle: true,
        ),
        body: Center(
          //heightFactor: 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset('img.jpg', width: 200),
              Image.asset('img.jpg', width: 200),
              Image.asset('img.jpg', width: 200),
            ],
          ),
        ),
      ),
    );
  }
}