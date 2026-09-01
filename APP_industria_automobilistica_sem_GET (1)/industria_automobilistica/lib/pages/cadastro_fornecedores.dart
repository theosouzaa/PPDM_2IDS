import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CadastroFornecedoresPage extends StatefulWidget {
  const CadastroFornecedoresPage({super.key});

  @override
  State<CadastroFornecedoresPage> createState() => _CadastroFornecedoresPageState();
}

class _CadastroFornecedoresPageState extends State<CadastroFornecedoresPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _cnpjController = TextEditingController();
  final _cidadeController = TextEditingController();
  String? _estado;
  bool _salvando = false;

  static const _estados = [
    'AC', 'AL', 'AP', 'AM', 'BA', 'CE', 'DF', 'ES', 'GO', 'MA', 'MT', 'MS',
    'MG', 'PA', 'PB', 'PR', 'PE', 'PI', 'RJ', 'RN', 'RS', 'RO', 'RR', 'SC',
    'SP', 'SE', 'TO',
  ];

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _salvando = true);

    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/api/fornecedores'),
        headers: const {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'NOME': _nomeController.text.trim(),
          'CNPJ': _cnpjController.text.trim(),
          'CIDADE': _cidadeController.text.trim(),
          'ESTADO': _estado,
        }),
      );

      if (!mounted) return;
      if (response.statusCode == 201) {
        _formKey.currentState!.reset();
        _nomeController.clear();
        _cnpjController.clear();
        _cidadeController.clear();
        setState(() => _estado = null);
        _mensagem('Fornecedor cadastrado com sucesso!', Colors.green);
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
    _nomeController.dispose();
    _cnpjController.dispose();
    _cidadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F5),
      appBar: AppBar(
        title: const Text('Cadastro de Fornecedores'),
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
                  const Text('Dados do fornecedor', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 24),
                  _campo(_nomeController, 'Nome', Icons.business_outlined),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _cnpjController,
                    keyboardType: TextInputType.number,
                    maxLength: 14,
                    decoration: const InputDecoration(labelText: 'CNPJ', prefixIcon: Icon(Icons.badge_outlined), border: OutlineInputBorder()),
                    validator: (valor) => (valor?.replaceAll(RegExp(r'\D'), '').length ?? 0) == 14 ? null : 'Informe um CNPJ com 14 dígitos',
                  ),
                  const SizedBox(height: 16),
                  _campo(_cidadeController, 'Cidade', Icons.location_city_outlined),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _estado,
                    decoration: const InputDecoration(labelText: 'Estado', prefixIcon: Icon(Icons.map_outlined), border: OutlineInputBorder()),
                    items: _estados.map((uf) => DropdownMenuItem(value: uf, child: Text(uf))).toList(),
                    onChanged: (valor) => setState(() => _estado = valor),
                    validator: (valor) => valor == null ? 'Selecione o estado' : null,
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

  Widget _campo(TextEditingController controller, String label, IconData icon) {
    return TextFormField(
      controller: controller,
      maxLength: 100,
      decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon), border: const OutlineInputBorder()),
      validator: (valor) => valor == null || valor.trim().isEmpty ? 'Informe este campo' : null,
    );
  }
}
