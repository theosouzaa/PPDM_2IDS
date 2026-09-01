import 'package:flutter/material.dart';
import 'login.dart';
import 'pages/cadastro_componentes.dart';
import 'pages/cadastro_fornecedores.dart';
import 'pages/cadastro_modelos.dart';
import 'pages/relatorio_componentes.dart';
import 'pages/relatorio_fornecedores.dart';
import 'pages/relatorio_modelos.dart';
import 'pages/relatorio_geral.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const primaryColor = Color(0xFF1F4E5F);
  static const backgroundColor = Color(0xFFF2F4F5);
  static const textColor = Color(0xFF263238);
  static const secondaryTextColor = Color(0xFF78909C);

  @override
  Widget build(BuildContext context) {
    final cadastros = [
      HomeOption(
        title: 'Modelos',
        icon: Icons.directions_car_outlined,
        page: (_) => const CadastroModelosPage(),
      ),
      HomeOption(
        title: 'Componentes',
        icon: Icons.settings_outlined,
        page: (_) => const CadastroComponentesPage(),
      ),
      HomeOption(
        title: 'Fornecedores',
        icon: Icons.local_shipping_outlined,
        page: (_) => const CadastroFornecedoresPage(),
      ),
    ];

    final relatorios = [
      HomeOption(
        title: 'Modelos',
        icon: Icons.directions_car_outlined,
        page: (_) => const RelatorioModelosPage(),
      ),
      HomeOption(
        title: 'Componentes',
        icon: Icons.settings_outlined,
        page: (_) => const RelatorioComponentesPage(),
      ),
      HomeOption(
        title: 'Fornecedores',
        icon: Icons.local_shipping_outlined,
        page: (_) => const RelatorioFornecedoresPage(),
      ),
      HomeOption(
        title: 'Relatório geral',
        icon: Icons.bar_chart_outlined,
        page: (_) => const RelatorioGeralPage(),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: const Text(
          'Sistema Industrial',
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const LoginPage(),
                ),
              );
            },
            icon: const Icon(
              Icons.logout,
              color: primaryColor,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Bem-vindo',
              style: TextStyle(
                color: textColor,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Selecione uma opção para continuar',
              style: TextStyle(
                color: secondaryTextColor,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 32),
            const SectionTitle(
              title: 'Relatórios',
              icon: Icons.analytics_outlined,
            ),
            const SizedBox(height: 16),
            OptionsGrid(options: relatorios),
            const SizedBox(height: 32),
            const SectionTitle(
              title: 'Cadastros',
              icon: Icons.edit_document,
            ),
            const SizedBox(height: 16),
            OptionsGrid(options: cadastros),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class HomeOption {
  final String title;
  final IconData icon;
  final WidgetBuilder page;

  const HomeOption({
    required this.title,
    required this.icon,
    required this.page,
  });
}

class SectionTitle extends StatelessWidget {
  final String title;
  final IconData icon;

  const SectionTitle({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: HomePage.primaryColor,
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            color: HomePage.textColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class OptionsGrid extends StatelessWidget {
  final List<HomeOption> options;

  const OptionsGrid({
    super.key,
    required this.options,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth > 900
            ? 4
            : constraints.maxWidth > 600
                ? 2
                : 1;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: options.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: columns == 1 ? 3 : 1.8,
          ),
          itemBuilder: (context, index) {
            return OptionCard(option: options[index]);
          },
        );
      },
    );
  }
}

class OptionCard extends StatelessWidget {
  final HomeOption option;

  const OptionCard({
    super.key,
    required this.option,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: option.page,
          ),
        );
      },
      child: Ink(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: const Color(0xFFE0E5E7),
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x12000000),
              blurRadius: 14,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: const Color(0xFFE7F0F2),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                option.icon,
                color: HomePage.primaryColor,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                option.title,
                style: const TextStyle(
                  color: HomePage.textColor,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: HomePage.secondaryTextColor,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}