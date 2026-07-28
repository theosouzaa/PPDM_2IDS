import 'package:flutter/material.dart';
import 'package:industria_alimenticia/pages/main_page.dart';

class IndustriaAlimenticiaApp extends StatelessWidget {
  const IndustriaAlimenticiaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Indústria Alimentícia',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green
        )
      ),
      home: const MainPage(),
    );
  }
}