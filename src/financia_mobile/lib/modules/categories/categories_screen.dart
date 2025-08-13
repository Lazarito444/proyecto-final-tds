// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:financia_mobile/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:financia_mobile/extensions/theme_extensions.dart';
import 'package:financia_mobile/extensions/navigation_extensions.dart';
import 'package:financia_mobile/models/category_model.dart';
import 'package:financia_mobile/services/category_service.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final CategoryService _categoryService = CategoryService();
  List<Category> _categories = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final categories = await _categoryService.getAllCategories();
      setState(() {
        _categories = categories;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

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
          S.of(context).categories,
          style: context.textStyles.titleLarge?.copyWith(fontSize: 20),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: context.colors.primary),
            onPressed: () => _showCategoryDialog(),
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: context.colors.error),
            const SizedBox(height: 16),
            Text(
              S.of(context).error_loading_categories,
              style: context.textStyles.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage!,
              style: context.textStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadCategories,
              child: Text(S.of(context).retry),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadCategories,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(S.of(context).expenses_2),
            const SizedBox(height: 12),
            _buildCategoriesList(false), // false = expense categories
            const SizedBox(height: 24),
            _buildSectionHeader(S.of(context).income),
            const SizedBox(height: 12),
            _buildCategoriesList(true), // true = income categories
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

  Widget _buildCategoriesList(bool isEarningCategory) {
    final filteredCategories = _categories
        .where((cat) => cat.isEarningCategory == isEarningCategory)
        .toList();

    if (filteredCategories.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.colors.secondaryContainer,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: context.colors.outline),
        ),
        child: Text(
          '${S.of(context).theres_no_categories_of} ${isEarningCategory ? S.of(context).income : S.of(context).expenses_2}',
          style: context.textStyles.bodyMedium?.copyWith(
            color: context.colors.onSurfaceVariant,
          ),
        ),
      );
    }

    return Column(
      children: filteredCategories
          .map((category) => _buildCategoryCard(category))
          .toList(),
    );
  }

  Widget _buildCategoryCard(Category category) {
    final uiCategory = category.toUIFormat();

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
              uiCategory['icon'] as IconData,
              color: uiCategory['color'] as Color,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              category.name,
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
                      S.of(context).savings_edit,
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
                      S.of(context).delete,
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

  void _handleCategoryAction(String action, Category category) {
    switch (action) {
      case 'edit':
        _showCategoryDialog(category: category);
        break;
      case 'delete':
        _showDeleteDialog(category);
        break;
    }
  }

  void _showCategoryDialog({Category? category}) {
    final isEditing = category != null;
    final nameController = TextEditingController(text: category?.name ?? '');

    IconData selectedIcon = category != null
        ? Category.getIconFromName(category.iconName)
        : Icons.category;
    Color selectedColor = category != null
        ? Category.getColorFromHex(category.colorHex)
        : context.colors.primary;
    bool selectedIsEarning = category?.isEarningCategory ?? false;

    // Available icons for selection
    final List<IconData> availableIcons = [
      Icons.restaurant,
      Icons.directions_car,
      Icons.movie,
      Icons.attach_money,
      Icons.work,
      Icons.home,
      Icons.shopping_cart,
      Icons.local_gas_station,
      Icons.school,
      Icons.medical_services,
      Icons.category,
    ];

    // Available colors for selection
    final List<Color> availableColors = [
      const Color(0xFF4CAF50),
      const Color(0xFF2196F3),
      const Color(0xFF9C27B0),
      const Color(0xFFFF9800),
      const Color(0xFFF44336),
      const Color(0xFF00BCD4),
      const Color(0xFF795548),
      const Color(0xFF607D8B),
    ];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: context.colors.surface,
          title: Text(
            isEditing
                ? S.of(context).edit_category
                : S.of(context).new_category,
            style: context.textStyles.titleMedium?.copyWith(fontSize: 18),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  style: context.textStyles.bodyMedium?.copyWith(fontSize: 14),
                  decoration: InputDecoration(
                    labelText: S.of(context).name_category,
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
                      S.of(context).type,
                      style: context.textStyles.bodyMedium?.copyWith(
                        fontSize: 14,
                      ),
                    ),
                    ToggleButtons(
                      isSelected: [
                        !selectedIsEarning, // expense
                        selectedIsEarning, // income
                      ],
                      onPressed: (index) {
                        setDialogState(() {
                          selectedIsEarning = index == 1;
                        });
                      },
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            S.of(context).expenses_2,
                            style: context.textStyles.bodyMedium?.copyWith(
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            S.of(context).income,
                            style: context.textStyles.bodyMedium?.copyWith(
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Icon selection
                Text(
                  S.of(context).icon,
                  style: context.textStyles.bodyMedium?.copyWith(fontSize: 14),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: availableIcons.map((icon) {
                    final isSelected = icon == selectedIcon;
                    return GestureDetector(
                      onTap: () {
                        setDialogState(() {
                          selectedIcon = icon;
                        });
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? context.colors.primary.withOpacity(0.2)
                              : context.colors.surfaceVariant,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected
                                ? context.colors.primary
                                : context.colors.outline,
                          ),
                        ),
                        child: Icon(icon, size: 20),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                // Color selection
                Text(
                  S.of(context).color,
                  style: context.textStyles.bodyMedium?.copyWith(fontSize: 14),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: availableColors.map((color) {
                    final isSelected = color == selectedColor;
                    return GestureDetector(
                      onTap: () {
                        setDialogState(() {
                          selectedColor = color;
                        });
                      },
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? context.colors.onSurface
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: isSelected
                            ? const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 16,
                              )
                            : null,
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => context.pop(),
              child: Text(
                S.of(context).cancel,
                style: context.textStyles.bodyMedium?.copyWith(fontSize: 14),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                await _saveCategory(
                  nameController.text,
                  selectedIcon,
                  selectedColor,
                  selectedIsEarning,
                  category,
                );
                if (mounted) context.pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: context.colors.primary,
                foregroundColor: Colors.white,
              ),
              child: Text(
                isEditing ? S.of(context).modify : S.of(context).create,
                style: context.textStyles.bodyMedium?.copyWith(fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(Category category) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: context.colors.surface,
        title: Text(
          S.of(context).delete_category,
          style: context.textStyles.titleMedium?.copyWith(fontSize: 18),
        ),
        content: Text(
          '${S.of(context).ask_delete_category} "${category.name}"?',
          style: context.textStyles.bodyMedium?.copyWith(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: Text(
              S.of(context).cancel,
              style: context.textStyles.bodyMedium?.copyWith(fontSize: 14),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              await _deleteCategory(category.id);
              if (mounted) context.pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text(
              S.of(context).delete,
              style: context.textStyles.bodyMedium?.copyWith(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _saveCategory(
    String name,
    IconData icon,
    Color color,
    bool isEarningCategory,
    Category? existingCategory,
  ) async {
    if (name.isEmpty) return;

    try {
      final categoryDto = CreateCategoryDto(
        name: name,
        isEarningCategory: isEarningCategory,
        colorHex: CategoryService.getHexFromColor(color),
        iconName: CategoryService.getIconNameFromIconData(icon),
      );

      if (existingCategory != null) {
        // Update existing category
        await _categoryService.updateCategory(existingCategory.id, categoryDto);
      } else {
        // Create new category
        await _categoryService.createCategory(categoryDto);
      }

      // Reload categories to reflect changes
      await _loadCategories();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              existingCategory != null
                  ? S.of(context).category_successfully_modified
                  : S.of(context).category_successfully_created,
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${S.of(context).error} ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _deleteCategory(String id) async {
    try {
      await _categoryService.deleteCategory(id);

      // Reload categories to reflect changes
      await _loadCategories();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(S.of(context).category_successfully_deleted),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${S.of(context).error_to_delete} ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
