import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CadastroComponentesPage extends StatefulWidget {
  const CadastroComponentesPage({super.key});

  @override
  State<CadastroComponentesPage> createState() => _CadastroComponentesPageState();
}

class _CadastroComponentesPageState extends State<CadastroComponentesPage> {
  final _formKey = GlobalKey<FormState>();
  final _codigoController = TextEditingController();
  final _nomeController = TextEditingController();
  final _estoqueController = TextEditingController();
  bool _salvando = false;

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _salvando = true);

    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1/industria_automotiva_api/public/api/componentes'),
        headers: const {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'CODIGO': _codigoController.text.trim(),
          'NOME': _nomeController.text.trim(),
          'ESTOQUE': int.parse(_estoqueController.text.trim()),
        }),
      );

      if (!mounted) return;
      if (response.statusCode == 201) {
        _formKey.currentState!.reset();
        _codigoController.clear();
        _nomeController.clear();
        _estoqueController.clear();
        _mensagem('Componente cadastrado com sucesso!', Colors.green);
      } else {
        _mensagem('Erro ${response.statusCode}: ${_erroDaApi(response)}', Colors.red);
      }
    } catch (_) {
      if (mounted) _mensagem('Erro ao enviar para a API.', Colors.red);
    } finally {
      if (mounted) setState(() => _salvando = false);
    }
  }

  String _erroDaApi(http.Response response) {
    try {
      final json = jsonDecode(response.body);
      return json is Map && json['message'] != null ? json['message'].toString() : response.body;
    } catch (_) {
      return response.body;
    }
  }

  void _mensagem(String texto, Color cor) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(texto), backgroundColor: cor),
      );

  @override
  void dispose() {
    _codigoController.dispose();
    _nomeController.dispose();
    _estoqueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F5),
      appBar: AppBar(
        title: const Text('Cadastro de Componentes'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('Dados do componente', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _codigoController,
                    decoration: const InputDecoration(labelText: 'Código', prefixIcon: Icon(Icons.qr_code_outlined), border: OutlineInputBorder()),
                    validator: _textoObrigatorio,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _nomeController,
                    maxLength: 100,
                    decoration: const InputDecoration(labelText: 'Nome', prefixIcon: Icon(Icons.settings_outlined), border: OutlineInputBorder()),
                    validator: _textoObrigatorio,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _estoqueController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Estoque', prefixIcon: Icon(Icons.inventory_2_outlined), border: OutlineInputBorder()),
                    validator: (valor) => int.tryParse(valor?.trim() ?? '') == null ? 'Informe uma quantidade válida' : null,
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: _salvando ? null : _salvar,
                    icon: _salvando
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Icon(Icons.save_outlined),
                    label: Text(_salvando ? 'SALVANDO...' : 'SALVAR'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String? _textoObrigatorio(String? valor) =>
      valor == null || valor.trim().isEmpty ? 'Informe este campo' : null;
}
