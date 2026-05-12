import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class MainLayout extends StatelessWidget {
  final Widget child;
  const MainLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final Color sidebarColor = const Color(0xFF0B0E14);
    final Color backgroundColor = const Color(0xFF13161B);

    return Scaffold(
      // AppBar fixa no topo com o botão hambúrguer
      appBar: AppBar(
        backgroundColor: sidebarColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'FLUIDOCS',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ),

      // Menu lateral (Drawer) que aparece ao clicar no hambúrguer
      drawer: SizedBox(
        width: MediaQuery.of(context).size.width * 0.7, // Ocupa 70% da largura
        child: Drawer(
          backgroundColor: sidebarColor,
          child: Column(
            children: [
              const SizedBox(height: 40),
              // Logo ou Título dentro do Drawer
              const Icon(
                LucideIcons.brainCircuit,
                color: Color(0xFF4285F4),
                size: 40,
              ),
              const SizedBox(height: 40),

              _SidebarItem(
                icon: LucideIcons.search,
                label: 'Pesquisa Avançada',
                isActive:
                    GoRouterState.of(context).uri.toString() == '/pesquisa',
                onTap: () {
                  Navigator.pop(context); // Fecha o menu
                  context.go('/pesquisa');
                },
              ),
              _SidebarItem(
                icon: LucideIcons.messageSquare,
                label: 'Assistente IA',
                isActive:
                    GoRouterState.of(context).uri.toString() == '/assistente',
                onTap: () {
                  Navigator.pop(context); // Fecha o menu
                  context.go('/assistente');
                },
              ),
              _SidebarItem(
                icon: LucideIcons.database,
                label: 'Repositórios',
                isActive:
                    GoRouterState.of(context).uri.toString() == '/repositorios',
                onTap: () {
                  Navigator.pop(context); // Fecha o menu
                  context.go('/repositorios');
                },
              ),
              const Spacer(), // Empurra o Sair para o rodapé

              _SidebarItem(
                icon: LucideIcons.logOut,
                label: 'Sair da Conta',
                isActive: false,
                onTap: () {
                  context.read<AuthProvider>().logout();
                  context.go('/login');
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),

      // Área de conteúdo principal
      body: Container(color: backgroundColor, child: child),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _SidebarItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: ListTile(
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        tileColor: isActive
            ? Colors.blue.withValues(alpha: 0.1)
            : Colors.transparent,
        leading: Icon(
          icon,
          color: isActive ? const Color(0xFF4285F4) : Colors.white54,
        ),
        title: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.white70,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
