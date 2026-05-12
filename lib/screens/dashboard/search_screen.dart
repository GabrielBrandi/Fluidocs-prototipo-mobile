import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> files = [
      {
        'name': 'Relatório Financeiro Q3',
        'summary':
            '...o crescimento no terceiro trimestre foi impulsionado pelas vendas B2B...',
        'type': 'PDF',
        'size': '2.4 MB',
        'date': '10/10/2024',
        'dept': 'Documentos RH',
      },
      {
        'name': 'Política de Férias 2024',
        'summary':
            'Documentação detalhando os períodos de descanso e solicitações via portal...',
        'type': 'DOCX',
        'size': '1.1 MB',
        'date': '05/09/2024',
        'dept': 'Recursos Humanos',
      },
      {
        'name': 'Planilha de Custos Operacionais',
        'summary':
            'Consolidado de gastos mensais por setor e projeção de gastos para o Q4...',
        'type': 'XLSX',
        'size': '850 KB',
        'date': '30/08/2024',
        'dept': 'Financeiro',
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0F1115),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: files.length,
        itemBuilder: (context, index) {
          final file = files[index];

          return GestureDetector(
            onTap: () => _showFileDetails(context, file),
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF16181D),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- TOPO: ÍCONE, TÍTULO E AÇÕES ---
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Ícone do arquivo (Redondo/Quadrado como na imagem)
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: file['type'] == 'PDF'
                              ? Colors.redAccent.withValues(alpha: 0.1)
                              : Colors.blueAccent.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          LucideIcons.fileText,
                          color: file['type'] == 'PDF'
                              ? Colors.redAccent
                              : Colors.blueAccent,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Título
                      Expanded(
                        child: Text(
                          file['name']!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // Ícones de Ação (Olho e Download)
                      Icon(LucideIcons.eye, color: Colors.grey[400], size: 20),
                      const SizedBox(width: 16),
                      Icon(
                        LucideIcons.download,
                        color: Colors.grey[400],
                        size: 20,
                      ),
                    ],
                  ),

                  // --- MEIO: RESUMO ---
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 60,
                      top: 8,
                      bottom: 16,
                    ),
                    child: Text(
                      file['summary']!,
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 13,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  // --- RODAPÉ: METADADOS ---
                  Padding(
                    padding: const EdgeInsets.only(left: 60),
                    child: Row(
                      children: [
                        Icon(
                          LucideIcons.database,
                          size: 14,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 6),
                        Text(
                          file['dept']!,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Icon(
                          LucideIcons.clock,
                          size: 14,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 6),
                        Text(
                          file['date']!,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showFileDetails(BuildContext context, Map<String, String> file) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 40,
          ),
          child: Container(
            clipBehavior: Clip
                .antiAlias, // Garante que as bordas arredondadas cortem o conteúdo
            decoration: BoxDecoration(
              color: const Color(0xFF16181D),
              borderRadius: BorderRadius.circular(24),
            ),
            // Definindo uma largura e altura máxima para o modal centralizado
            constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
            child: DefaultTabController(
              length: 2,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // --- Cabeçalho com o botão X ---
                  Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 24, 60, 10),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(0xFF23262E),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                LucideIcons.fileText,
                                color: Colors.redAccent,
                                size: 32,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    file['name']!,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    "${file['dept']} • ${file['date']}",
                                    style: TextStyle(
                                      color: Colors.grey[500],
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Botão de Fechar (X)
                      Positioned(
                        top: 10,
                        right: 10,
                        child: IconButton(
                          icon: const Icon(
                            LucideIcons.x,
                            color: Colors.grey,
                            size: 20,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ],
                  ),

                  // --- TabBar ---
                  const TabBar(
                    indicatorColor: Colors.deepPurpleAccent,
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.grey,
                    indicatorSize: TabBarIndicatorSize.label,
                    tabs: [
                      Tab(text: "Informações"),
                      Tab(text: "Versões"),
                    ],
                  ),

                  // --- Conteúdo Central ---
                  Expanded(
                    child: TabBarView(
                      children: [
                        // Aba Informações (Split View)
                        Row(
                          children: [
                            // Preview
                            Expanded(
                              flex: 4,
                              child: Container(
                                color: const Color(0xFF1D2026),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      LucideIcons.fileText,
                                      size: 48,
                                      color: Colors.redAccent,
                                    ),
                                    const SizedBox(height: 12),
                                    const Text(
                                      "Pré-visualização\nnão disponível",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      "Faça o download...",
                                      style: TextStyle(
                                        color: Colors.grey[500],
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // Detalhes
                            Expanded(
                              flex: 5,
                              child: SingleChildScrollView(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildDetailSection(
                                      "Resumo",
                                      "Crescimento impulsionado por vendas B2B...",
                                    ),
                                    const SizedBox(height: 16),
                                    _buildSmallInfo("Tipo", file['type']!),
                                    const SizedBox(height: 12),
                                    _buildSmallInfo("Tamanho", file['size']!),
                                    const SizedBox(height: 12),
                                    _buildSmallInfo("Criado", file['date']!),
                                    const SizedBox(height: 20),
                                    // Botão de Download no final da lista
                                    ElevatedButton.icon(
                                      onPressed: () {},
                                      icon: const Icon(
                                        LucideIcons.download,
                                        size: 16,
                                      ),
                                      label: const Text("Download"),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Colors.deepPurpleAccent,
                                        foregroundColor: Colors.white,
                                        minimumSize: const Size(
                                          double.infinity,
                                          36,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        // Aba Versões
                        const Center(
                          child: Text(
                            "Sem histórico",
                            style: TextStyle(color: Colors.grey),
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
      },
    );
  }

  Widget _buildDetailSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: Colors.grey, fontSize: 13)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF23262E),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            content,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildSmallInfo(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ],
    );
  }
}
