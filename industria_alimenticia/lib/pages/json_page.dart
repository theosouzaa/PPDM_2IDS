import 'dart:convert';

import 'package:flutter/material.dart';

class JsonPage extends StatelessWidget {
  const JsonPage({super.key, required this.dadosProduto});

  final Map<String, dynamic> dadosProduto;

  @override
  Widget build(BuildContext context) {
    // Transformar o JSON em array
    final jsonProduto = JsonEncoder.withIndent(
      ''
    ).convert(dadosProduto);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Resultado em JSON'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: SelectableText(
              jsonProduto,
              style: TextStyle(fontFamily: 'monospace', fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}