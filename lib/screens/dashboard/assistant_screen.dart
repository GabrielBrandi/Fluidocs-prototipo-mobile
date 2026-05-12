import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:lucide_icons/lucide_icons.dart';

class AssistantScreen extends StatefulWidget {
  const AssistantScreen({super.key});

  @override
  State<AssistantScreen> createState() => _AssistantScreenState();
}

class _AssistantScreenState extends State<AssistantScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;

  // IMPORTANTE: Use sua chave de API
  static const _apiKey = 'SUA_CHAVE_GEMINI_AQUI';

  Future<void> _sendMessage() async {
    if (_controller.text.isEmpty) return;

    final userText = _controller.text;
    setState(() {
      _messages.add({'role': 'user', 'text': userText});
      _isLoading = true;
    });
    _controller.clear();

    try {
      final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: _apiKey);
      final response = await model.generateContent([Content.text(userText)]);

      setState(() {
        _messages.add({'role': 'ai', 'text': response.text ?? 'Sem resposta.'});
      });
    } catch (e) {
      setState(() {
        _messages.add({'role': 'ai', 'text': 'Erro ao conectar com a IA: $e'});
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Definindo as cores baseadas na imagem (Dark Theme)
    const backgroundColor = Color(0xFF121212);
    const cardColor = Color(0xFF1E1E1E);
    const accentColor = Color(0xFF3B82F6); // Tom de azul do botão de envio
    const textColor = Colors.white70;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: Container(
          // Simula o "card" principal da imagem
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white10),
          ),
          child: Column(
            children: [
              // Cabeçalho (ASSISTENTE DE IA)
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    const Icon(LucideIcons.menu, color: accentColor, size: 20),
                    const SizedBox(width: 12),
                    Text(
                      'ASSISTENTE DE IA',
                      style: TextStyle(
                        color: accentColor.withValues(alpha: 0.8),
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),

              // Seletor de repositórios (Dropdown estilizado)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: const Row(
                    children: [
                      Icon(LucideIcons.database, color: textColor, size: 18),
                      SizedBox(width: 10),
                      Text(
                        'Todos os repositórios',
                        style: TextStyle(color: textColor),
                      ),
                      Spacer(),
                      Icon(LucideIcons.chevronDown, color: textColor, size: 18),
                    ],
                  ),
                ),
              ),

              // Área de Chat
              Expanded(
                child: _messages.isEmpty
                    ? _buildEmptyState() // Estado inicial igual à imagem
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _messages.length,
                        itemBuilder: (context, index) {
                          final msg = _messages[index];
                          final isUser = msg['role'] == 'user';
                          return _buildChatBubble(isUser, msg['text']!);
                        },
                      ),
              ),

              if (_isLoading)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.transparent,
                    minHeight: 1,
                  ),
                ),

              // Campo de entrada estilizado
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Pergunte algo sobre seus documentos...',
                          hintStyle: const TextStyle(
                            color: Colors.white38,
                            fontSize: 14,
                          ),
                          filled: true,
                          fillColor: Colors.black26,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.white12),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.white12),
                          ),
                        ),
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: accentColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        icon: const Icon(
                          LucideIcons.send,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: _sendMessage,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget para o estado vazio (Igual à imagem enviada)
  Widget _buildEmptyState() {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(LucideIcons.bot, size: 64, color: Colors.white12),
        SizedBox(height: 24),
        Text(
          'Como posso ajudar hoje?',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Faça perguntas sobre os documentos da sua\nempresa.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white38, fontSize: 14),
        ),
      ],
    );
  }

  // Widget para as bolhas de chat estilizadas
  Widget _buildChatBubble(bool isUser, String text) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        constraints: const BoxConstraints(maxWidth: 280),
        decoration: BoxDecoration(
          color: isUser ? const Color(0xFF0D47A1) : Colors.white12,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
      ),
    );
  }
}
