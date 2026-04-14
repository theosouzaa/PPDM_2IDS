import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final _formKey = GlobalKey<FormState>();

  // controllers
  final nome = TextEditingController();
  final codigo = TextEditingController();
  final preco = TextEditingController();
  final quantidade = TextEditingController();
  final barras = TextEditingController();

  final cep = TextEditingController();
  final logradouro = TextEditingController();
  final numero = TextEditingController();
  final bairro = TextEditingController();
  final cidade = TextEditingController();
  final estado = TextEditingController();
  final regiao = TextEditingController();
  final ddd = TextEditingController();

  // máscaras
  final cepMask = MaskTextInputFormatter(mask: "#####-###");
  final codigoMask = MaskTextInputFormatter(mask: "AAA-####");

  // função simples de região
  String getRegiao(String uf) {
    if (["SP", "RJ", "MG", "ES"].contains(uf)) return "Sudeste";
    if (["PR", "SC", "RS"].contains(uf)) return "Sul";
    if (["BA", "PE", "CE"].contains(uf)) return "Nordeste";
    return "Outros";
  }

  // buscar CEP
  Future<void> buscarCep() async {
    try {
      Dio dio = Dio();
      final response =
          await dio.get("https://viacep.com.br/ws/${cep.text}/json/");

      if (response.statusCode == 200 && response.data['erro'] != true) {
        setState(() {
          logradouro.text = response.data['logradouro'] ?? "";
          bairro.text = response.data['bairro'] ?? "";
          cidade.text = response.data['localidade'] ?? "";
          estado.text = response.data['uf'] ?? "";
          ddd.text = response.data['ddd'] ?? "";
          regiao.text = getRegiao(response.data['uf'] ?? "");
        });
      } else {
        throw Exception("CEP não encontrado");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erro ao buscar CEP")),
      );
    }
  }

  Widget campo({
    required String label,
    required TextEditingController controller,
    String? Function(String?)? validator,
    List<TextInputFormatter>? mask,
    bool readOnly = false,
    TextInputType? tipo,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: controller,
        validator: validator,
        readOnly: readOnly,
        inputFormatters: mask,
        keyboardType: tipo,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          filled: readOnly,
          fillColor: readOnly ? Colors.grey[200] : null,
        ),
      ),
    );
  }

  void salvar() {
    if (!_formKey.currentState!.validate()) return;

    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Cadastro realizado com sucesso!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erro ao salvar")),
      );
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Página de Cadastro'),
        centerTitle: true,
        backgroundColor: Colors.cyan[800],
        titleTextStyle: TextStyle(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              campo(
                label: "Nome",
                controller: nome,
                validator: (v) =>
                    v!.length < 3 ? "Mínimo 3 caracteres" : null,
              ),
              campo(
                label: "Código (AAA-9999)",
                controller: codigo,
                mask: [codigoMask],
                validator: (v) =>
                    v!.length != 8 ? "Código inválido" : null,
              ),
              campo(
                label: "Preço",
                controller: preco,
                tipo: TextInputType.number,
                validator: (v) =>
                    double.tryParse(v!) == null || double.parse(v) <= 0
                        ? "Preço inválido"
                        : null,
              ),
              campo(
                label: "Quantidade",
                controller: quantidade,
                tipo: TextInputType.number,
                validator: (v) =>
                    int.tryParse(v!) == null || int.parse(v) < 0
                        ? "Inválido"
                        : null,
              ),
              campo(
                label: "Código de Barras (13 dígitos)",
                controller: barras,
                tipo: TextInputType.number,
                validator: (v) =>
                    v!.length != 13 ? "Inválido" : null,
              ),

              Row(
                children: [
                  Expanded(
                    child: campo(
                      label: "CEP",
                      controller: cep,
                      mask: [cepMask],
                      validator: (v) =>
                          v!.length != 9 ? "CEP inválido" : null,
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: buscarCep,
                    child: const Text("Buscar"),
                  ),
                ],
              ),

              campo(
                  label: "Logradouro do fornecedor",
                  controller: logradouro,
                  readOnly: true),

              campo(
                label: "Número",
                controller: numero,
                tipo: TextInputType.number,
                validator: (v) =>
                    v!.isEmpty ? "Informe o número" : null,
              ),

              campo(
                  label: "Bairro do fornecedor",
                  controller: bairro,
                  readOnly: true),

              campo(
                  label: "Cidade do fornecedor",
                  controller: cidade,
                  readOnly: true),

              campo(
                  label: "Estado (UF)",
                  controller: estado,
                  readOnly: true),

              campo(
                  label: "Região",
                  controller: regiao,
                  readOnly: true),

              campo(
                  label: "DDD",
                  controller: ddd,
                  readOnly: true),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: salvar,
                child: const Text("Cadastrar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}