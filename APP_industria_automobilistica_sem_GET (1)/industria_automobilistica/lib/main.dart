import 'package:flutter/material.dart';
import 'login.dart';

void main() {
  runApp(const AutoIndustryApp());
}

class AutoIndustryApp extends StatelessWidget {
  const AutoIndustryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1F4E5F),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF2F4F5),
      ),
      home: const LoginPage(),
    );
  }
}