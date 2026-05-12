import 'package:go_router/go_router.dart';
import '../screens/auth/login_screen.dart';
import '../screens/main_layout.dart';
import '../screens/dashboard/assistant_screen.dart';
import '../screens/dashboard/search_screen.dart';
import '../screens/dashboard/repositories_screen.dart';

final router = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    ShellRoute(
      builder: (context, state, child) => MainLayout(child: child),
      routes: [
        GoRoute(
          path: '/pesquisa',
          builder: (context, state) => const SearchScreen(),
        ),
        GoRoute(
          path: '/assistente',
          builder: (context, state) => const AssistantScreen(),
        ),
        GoRoute(
          path: '/repositorios',
          builder: (context, state) => const RepositoriesScreen(),
        ),
      ],
    ),
  ],
);
