import 'package:flutter/material.dart';
import 'package:industria_automobilistica/home.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool hidePassword = true;

  bool entrando = false;

  Future<void> login() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      entrando = true;
    });

    final dadosLogin = {
      'email': emailController.text.trim(),
      'senha': passwordController.text
    };

    try {
      // Fazer a requisoção http
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/api/login'),
        headers: {
          // Cabeçalhos de requisição
          'Accept': 'application/json',
          'Content-Type': 'application/json'
        },
        body: jsonEncode(dadosLogin)
      );

      final resultado = response.body.isEmpty ?
      jsonDecode(response.body) : <String, dynamic>{};

      if (response.statusCode == 200 &&
        resultado['sucesso'] == true) {
          Navigator.pushReplacement(context,
            MaterialPageRoute(
              builder: (_) => const HomePage()
            )
          );
      }else{
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content:
          Text('E-mail ou senha inválidos'),
          backgroundColor: Colors.red)
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao acessar api: $e')
        )
      );
    }finally {
      setState(() {
        entrando = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x22000000),
                    blurRadius: 25,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Form(
              key: formKey,
              child: 
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(
                    Icons.car_repair,
                    size: 60,
                    color: Color(0xFF1F4E5F),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'AUTOMOTIVE',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF263238),
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Sistema de gestão industrial automobilística',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFF78909C)),
                  ),
                  const SizedBox(height: 32),
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: 'E-mail',
                      prefixIcon: Icon(Icons.person_outline),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Informe o e-mail';
                      }

                      if (!value.contains('@')) {
                        return 'Informe um e-mail válido';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: passwordController,
                    obscureText: hidePassword,
                    onFieldSubmitted: (_) {
                      if (!entrando) {
                        login();
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Infome a sua senha';
                      }
                    },
                    decoration: InputDecoration(
                      labelText: 'Senha',
                      prefixIcon: const Icon(Icons.lock_outline),
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            hidePassword = !hidePassword;
                          });
                        },
                        icon: Icon(
                          hidePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: const Text('Esqueci minha senha'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 52,
                    child: FilledButton(
                      onPressed: login,
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF1F4E5F),
                      ),
                      child: const Text(
                        'ENTRAR',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}