import 'package:flutter/material.dart';
import 'package:financia_mobile/extensions/theme_extensions.dart';
import 'package:financia_mobile/extensions/navigation_extensions.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final List<Map<String, dynamic>> _categories = [
    {
      'id': 1,
      'name': 'Alimentación',
      'icon': Icons.restaurant,
      'color': const Color(0xFF4CAF50),
      'type': 'expense',
    },
    {
      'id': 2,
      'name': 'Transporte',
      'icon': Icons.directions_car,
      'color': const Color(0xFF2196F3),
      'type': 'expense',
    },
    {
      'id': 3,
      'name': 'Entretenimiento',
      'icon': Icons.movie,
      'color': const Color(0xFF9C27B0),
      'type': 'expense',
    },
    {
      'id': 4,
      'name': 'Salario',
      'icon': Icons.attach_money,
      'color': const Color(0xFF4CAF50),
      'type': 'income',
    },
    {
      'id': 5,
      'name': 'Freelance',
      'icon': Icons.work,
      'color': const Color(0xFF00BCD4),
      'type': 'income',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.surface,
      appBar: AppBar(
        backgroundColor: context.colors.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: context.colors.onSurface),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Categorías',
          style: context.textStyles.titleLarge?.copyWith(fontSize: 20),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: context.colors.primary),
            onPressed: () => _showCategoryDialog(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Gastos'),
            const SizedBox(height: 12),
            _buildCategoriesList('expense'),
            const SizedBox(height: 24),
            _buildSectionHeader('Ingresos'),
            const SizedBox(height: 12),
            _buildCategoriesList('income'),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: context.textStyles.titleMedium?.copyWith(fontSize: 16),
    );
  }

  Widget _buildCategoriesList(String type) {
    final filteredCategories = _categories
        .where((cat) => cat['type'] == type)
        .toList();
    return Column(
      children: filteredCategories
          .map((category) => _buildCategoryCard(category))
          .toList(),
    );
  }

  Widget _buildCategoryCard(Map<String, dynamic> category) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colors.secondaryContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.colors.outline),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: context.colors.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              category['icon'] as IconData,
              color: category['color'] as Color,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              category['name'] as String,
              style: context.textStyles.titleSmall?.copyWith(fontSize: 14),
            ),
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: context.colors.outline),
            onSelected: (value) => _handleCategoryAction(value, category),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit, size: 20, color: context.colors.primary),
                    const SizedBox(width: 8),
                    Text(
                      'Editar',
                      style: context.textStyles.bodyMedium?.copyWith(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    const Icon(Icons.delete, size: 20, color: Colors.red),
                    const SizedBox(width: 8),
                    Text(
                      'Eliminar',
                      style: context.textStyles.bodyMedium?.copyWith(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _handleCategoryAction(String action, Map<String, dynamic> category) {
    switch (action) {
      case 'edit':
        _showCategoryDialog(category: category);
        break;
      case 'delete':
        _showDeleteDialog(category);
        break;
    }
  }

  void _showCategoryDialog({Map<String, dynamic>? category}) {
    final isEditing = category != null;
    final nameController = TextEditingController(text: category?['name'] ?? '');
    IconData selectedIcon = category?['icon'] ?? Icons.category;
    Color selectedColor = category?['color'] ?? context.colors.primary;
    String selectedType = category?['type'] ?? 'expense';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: context.colors.surface,
          title: Text(
            isEditing ? 'Editar Categoría' : 'Nueva Categoría',
            style: context.textStyles.titleMedium?.copyWith(fontSize: 18),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                style: context.textStyles.bodyMedium?.copyWith(fontSize: 14),
                decoration: InputDecoration(
                  labelText: 'Nombre de la categoría',
                  labelStyle: context.textStyles.bodyMedium?.copyWith(
                    fontSize: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text(
                    'Tipo: ',
                    style: context.textStyles.bodyMedium?.copyWith(
                      fontSize: 14,
                    ),
                  ),
                  ToggleButtons(
                    isSelected: [
                      selectedType == 'expense',
                      selectedType == 'income',
                    ],
                    onPressed: (index) {
                      setDialogState(() {
                        selectedType = index == 0 ? 'expense' : 'income';
                      });
                    },
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          'Gasto',
                          style: context.textStyles.bodyMedium?.copyWith(
                            fontSize: 14,
                          ),
                        ), 
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          'Ingreso',
                          style: context.textStyles.bodyMedium?.copyWith(
                            fontSize: 14,
                          ),
                        ), 
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => context.pop(),
              child: Text(
                'Cancelar',
                style: context.textStyles.bodyMedium?.copyWith(fontSize: 14),
              ), 
            ),
            ElevatedButton(
              onPressed: () {
                _saveCategory(
                  nameController.text,
                  selectedIcon,
                  selectedColor,
                  selectedType,
                  category,
                );
                context.pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: context.colors.primary,
                foregroundColor: Colors.white,
              ),
              child: Text(
                isEditing ? 'Actualizar' : 'Crear',
                style: context.textStyles.bodyMedium?.copyWith(fontSize: 14),
              ), 
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(Map<String, dynamic> category) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: context.colors.surface,
        title: Text(
          'Eliminar Categoría',
          style: context.textStyles.titleMedium?.copyWith(
            fontSize: 18,
          ), 
        ),
        content: Text(
          '¿Estás seguro de que deseas eliminar "${category['name']}"?',
          style: context.textStyles.bodyMedium?.copyWith(
            fontSize: 14,
          ), 
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: Text(
              'Cancelar',
              style: context.textStyles.bodyMedium?.copyWith(fontSize: 14),
            ), 
          ),
          ElevatedButton(
            onPressed: () {
              _deleteCategory(category['id']);
              context.pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text(
              'Eliminar',
              style: context.textStyles.bodyMedium?.copyWith(fontSize: 14),
            ), 
          ),
        ],
      ),
    );
  }

  void _saveCategory(
    String name,
    IconData icon,
    Color color,
    String type,
    Map<String, dynamic>? existingCategory,
  ) {
    if (name.isEmpty) return;
    setState(() {
      if (existingCategory != null) {
        final index = _categories.indexWhere(
          (cat) => cat['id'] == existingCategory['id'],
        );
        if (index != -1) {
          _categories[index] = {
            'id': existingCategory['id'],
            'name': name,
            'icon': icon,
            'color': color,
            'type': type,
          };
        }
      } else {
        _categories.add({
          'id': DateTime.now().millisecondsSinceEpoch,
          'name': name,
          'icon': icon,
          'color': color,
          'type': type,
        });
      }
    });
  }

  void _deleteCategory(int id) {
    setState(() {
      _categories.removeWhere((cat) => cat['id'] == id);
    });
  }
}
