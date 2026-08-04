import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Resumo da produção',
            style: TextStyle(
              fontSize: 25,
              // Deixa a fonte em negrito
              fontWeight: FontWeight.bold
            ),
          ),
          // Colocando espaço entre o texto e o card
          SizedBox(height: 20),
          // Criar uma linha
          Row(
            children: [
              Expanded(
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        // Icone do card
                        Icon(
                          Icons.inventory,
                          size: 40,
                          color: Colors.green,
                        ),
                        SizedBox(height: 8),
                        Text('Produtos'),
                        Text(
                          '50',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              // Espaço
              SizedBox(width: 12),
              Expanded(
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        // Icone do card
                        Icon(
                          Icons.factory_outlined,
                          size: 40,
                          color: Colors.green,
                        ),
                        SizedBox(height: 8),
                        Text('Lotes'),
                        Text(
                          '8',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}