import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/repository_item.dart';
import '../../providers/repositories_provider.dart';

class RepositoriesScreen extends StatefulWidget {
  const RepositoriesScreen({super.key});

  @override
  State<RepositoriesScreen> createState() => _RepositoriesScreenState();
}

class _RepositoriesScreenState extends State<RepositoriesScreen> {
  void _showAddRepositoryModal() {
    final nameController = TextEditingController();
    final urlController = TextEditingController();
    String selectedType = 'Google Drive';
    List<String> selectedSectors = [];
    bool isSaving = false;
    final sectors = [
      'Administradores',
      'Recursos Humanos',
      'Tecnologia da Informação',
      'Geral',
    ];

    showDialog<void>(
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
            constraints: const BoxConstraints(maxWidth: 500),
            padding: const EdgeInsets.all(24),
            child: StatefulBuilder(
              builder: (context, setModalState) {
                return SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Novo Repositório',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildLabel('Nome'),
                      _buildTextField(nameController, 'Ex: Documentos RH'),
                      const SizedBox(height: 16),
                      _buildLabel('URL / IP'),
                      _buildTextField(urlController, 'https://...'),
                      const SizedBox(height: 16),
                      _buildLabel('Tipo'),
                      _buildDropdown(
                        (value) => setModalState(() => selectedType = value!),
                        selectedType,
                      ),
                      const SizedBox(height: 16),
                      _buildLabel('Setores de Acesso'),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white10),
                        ),
                        constraints: const BoxConstraints(maxHeight: 200),
                        child: ListView(
                          shrinkWrap: true,
                          children: sectors.map((sector) {
                            return CheckboxListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              title: Text(
                                sector,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                              ),
                              value: selectedSectors.contains(sector),
                              activeColor: const Color(0xFF00A3FF),
                              dense: true,
                              controlAffinity: ListTileControlAffinity.leading,
                              onChanged: (value) {
                                setModalState(() {
                                  if (value == true) {
                                    selectedSectors.add(sector);
                                  } else {
                                    selectedSectors.remove(sector);
                                  }
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 32),
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
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF00A3FF),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                            ),
                            onPressed: isSaving
                                ? null
                                : () async {
                                    final title = nameController.text.trim();
                                    final url = urlController.text.trim();

                                    if (title.isEmpty || url.isEmpty) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Informe nome e URL/IP do repositório.',
                                          ),
                                        ),
                                      );
                                      return;
                                    }

                                    setModalState(() => isSaving = true);

                                    try {
                                      await context
                                          .read<RepositoriesProvider>()
                                          .addRepository(
                                            RepositoryItem(
                                              title: title,
                                              url: url,
                                              type: selectedType,
                                              tags: List<String>.from(
                                                selectedSectors,
                                              ),
                                            ),
                                          );

                                      if (dialogContext.mounted) {
                                        Navigator.pop(dialogContext);
                                      }
                                    } catch (_) {
                                      if (context.mounted) {
                                        setModalState(() => isSaving = false);
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Não foi possível salvar no SQLite.',
                                            ),
                                          ),
                                        );
                                      }
                                    }
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
                                : const Text(
                                    'Salvar',
                                    style: TextStyle(color: Colors.white),
                                  ),
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
    ).whenComplete(() {
      nameController.dispose();
      urlController.dispose();
    });
  }

  Future<void> _confirmDelete(RepositoryItem repository) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Remover repositório'),
          content: Text('Deseja remover "${repository.title}" do SQLite?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Remover'),
            ),
          ],
        );
      },
    );

    if (shouldDelete == true && repository.id != null && mounted) {
      await context.read<RepositoriesProvider>().deleteRepository(
        repository.id!,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFF121212);
    const primaryBlue = Color(0xFF00A3FF);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Consumer<RepositoriesProvider>(
          builder: (context, provider, _) {
            if (provider.isLoading) {
              return const Center(
                child: CircularProgressIndicator(color: primaryBlue),
              );
            }

            return RefreshIndicator(
              onRefresh: provider.loadRepositories,
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  const Text(
                    'REPOSITÓRIOS',
                    style: TextStyle(
                      color: primaryBlue,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Gerencie as fontes de dados salvas no SQLite.',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: _showAddRepositoryModal,
                      icon: const Icon(Icons.add, color: Colors.white),
                      label: const Text(
                        'Novo Repositório',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  if (provider.errorMessage != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      provider.errorMessage!,
                      style: const TextStyle(color: Colors.redAccent),
                    ),
                  ],
                  const SizedBox(height: 32),
                  if (provider.repositories.isEmpty)
                    const Padding(
                      padding: EdgeInsets.only(top: 48),
                      child: Center(
                        child: Text(
                          'Nenhum repositório cadastrado.',
                          style: TextStyle(color: Colors.white54),
                        ),
                      ),
                    )
                  else
                    ...provider.repositories.map(
                      (repository) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _buildRepositoryCard(
                          repository: repository,
                          onDelete: () => _confirmDelete(repository),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white24),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }

  Widget _buildDropdown(ValueChanged<String?> onChanged, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButton<String>(
        value: value,
        isExpanded: true,
        dropdownColor: const Color(0xFF1E1E1E),
        underline: const SizedBox(),
        items: ['Google Drive', 'Servidor Local']
            .map(
              (type) => DropdownMenuItem(
                value: type,
                child: Text(type, style: const TextStyle(color: Colors.white)),
              ),
            )
            .toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildRepositoryCard({
    required RepositoryItem repository,
    required VoidCallback onDelete,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(repository.icon, color: repository.iconColor),
              ),
              IconButton(
                tooltip: 'Remover do SQLite',
                onPressed: onDelete,
                icon: const Icon(
                  Icons.delete_outline,
                  color: Colors.white54,
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            repository.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            repository.url,
            style: const TextStyle(color: Colors.white38, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Text(
            'Tipo: ${repository.type}',
            style: const TextStyle(color: Colors.white38, fontSize: 12),
          ),
          if (repository.tags.isNotEmpty) ...[
            const Divider(color: Colors.white10, height: 32),
            const Text(
              'SETORES COM ACESSO',
              style: TextStyle(color: Colors.white38, fontSize: 11),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: repository.tags
                  .map(
                    (tag) => Chip(
                      label: Text(
                        tag,
                        style: const TextStyle(
                          color: Color(0xFF4FA8FF),
                          fontSize: 10,
                        ),
                      ),
                      backgroundColor: const Color(0xFF1A2633),
                      side: BorderSide.none,
                      visualDensity: VisualDensity.compact,
                    ),
                  )
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }
}
