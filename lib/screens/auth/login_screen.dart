import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  static const Color backgroundColor = Color(0xFF121212);
  static const Color inputFillColor = Color(0xFF1E1E1E);
  static const Color accentBlue = Color(0xFF0081D6);
  static const Color textColor = Colors.white;

  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showSnackBar('Informe email e senha.', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    final authenticated = await context.read<AuthProvider>().login(
      email,
      password,
    );

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (authenticated) {
      context.go('/pesquisa');
    } else {
      _showSnackBar('Usuário ou senha incorretos.', isError: true);
    }
  }

  Future<void> _showRegisterModal() async {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    bool isSaving = false;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: const Color(0xFF161616),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 24,
          ),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 480),
            padding: const EdgeInsets.all(24),
            child: StatefulBuilder(
              builder: (context, setModalState) {
                return SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Criar conta',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildLabel('Nome'),
                      _buildTextField(
                        controller: nameController,
                        hint: 'Seu nome',
                        icon: Icons.person_outline,
                      ),
                      const SizedBox(height: 16),
                      _buildLabel('Email'),
                      _buildTextField(
                        controller: emailController,
                        hint: 'voce@empresa.com',
                        icon: Icons.email_outlined,
                      ),
                      const SizedBox(height: 16),
                      _buildLabel('Senha'),
                      _buildTextField(
                        controller: passwordController,
                        hint: '********',
                        icon: Icons.lock_outline,
                        obscureText: true,
                      ),
                      const SizedBox(height: 16),
                      _buildLabel('Confirmar senha'),
                      _buildTextField(
                        controller: confirmPasswordController,
                        hint: '********',
                        icon: Icons.lock_outline,
                        obscureText: true,
                      ),
                      const SizedBox(height: 28),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: isSaving
                                ? null
                                : () => Navigator.pop(dialogContext),
                            child: const Text(
                              'Cancelar',
                              style: TextStyle(color: Colors.white54),
                            ),
                          ),
                          const SizedBox(width: 12),
                          FilledButton(
                            onPressed: isSaving
                                ? null
                                : () async {
                                    final name = nameController.text.trim();
                                    final email = emailController.text.trim();
                                    final password = passwordController.text;
                                    final confirmPassword =
                                        confirmPasswordController.text;

                                    if (name.isEmpty ||
                                        email.isEmpty ||
                                        password.isEmpty) {
                                      _showSnackBar(
                                        'Preencha nome, email e senha.',
                                        isError: true,
                                      );
                                      return;
                                    }

                                    if (password.length < 6) {
                                      _showSnackBar(
                                        'A senha deve ter pelo menos 6 caracteres.',
                                        isError: true,
                                      );
                                      return;
                                    }

                                    if (password != confirmPassword) {
                                      _showSnackBar(
                                        'As senhas não conferem.',
                                        isError: true,
                                      );
                                      return;
                                    }

                                    setModalState(() => isSaving = true);

                                    final error = await context
                                        .read<AuthProvider>()
                                        .register(
                                          name: name,
                                          email: email,
                                          password: password,
                                        );

                                    if (!context.mounted) return;

                                    if (error != null) {
                                      setModalState(() => isSaving = false);
                                      _showSnackBar(error, isError: true);
                                      return;
                                    }

                                    _emailController.text = email;
                                    _passwordController.text = password;

                                    if (dialogContext.mounted) {
                                      Navigator.pop(dialogContext);
                                    }

                                    _showSnackBar(
                                      'Usuário cadastrado com sucesso.',
                                    );
                                  },
                            child: isSaving
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text('Cadastrar'),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );

    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.redAccent : Colors.green,
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 35,
                backgroundColor: Color(0xFF1A2A3A),
                child: Icon(Icons.psychology, size: 45, color: accentBlue),
              ),
              const SizedBox(height: 24),
              const Text(
                'Bem-vindo de volta',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Acesse seu repositório inteligente',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
              const SizedBox(height: 40),
              _buildLabel('Email corporativo'),
              _buildTextField(
                controller: _emailController,
                hint: 'voce@empresa.com',
                icon: Icons.email_outlined,
              ),
              const SizedBox(height: 20),
              _buildLabel('Senha'),
              _buildTextField(
                controller: _passwordController,
                hint: '********',
                icon: Icons.lock_outline,
                obscureText: true,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: FilledButton(
                  onPressed: _isLoading ? null : _handleLogin,
                  style: FilledButton.styleFrom(
                    backgroundColor: accentBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Entrar',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Não tem uma conta? ',
                    style: TextStyle(color: Colors.grey),
                  ),
                  GestureDetector(
                    onTap: _showRegisterModal,
                    child: const Text(
                      'Crie sua conta empresarial',
                      style: TextStyle(
                        color: accentBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(color: textColor, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildTextField({
    required String hint,
    required IconData icon,
    bool obscureText = false,
    required TextEditingController controller,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(color: textColor),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.grey),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: inputFillColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[800]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[800]!),
        ),
      ),
    );
  }
}
