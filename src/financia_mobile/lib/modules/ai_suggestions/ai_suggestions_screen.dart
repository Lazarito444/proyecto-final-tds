import 'package:flutter/material.dart';
import 'package:financia_mobile/extensions/theme_extensions.dart';
import 'package:financia_mobile/extensions/navigation_extensions.dart';

class AISuggestionsScreen extends StatelessWidget {
  const AISuggestionsScreen({super.key});

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
        //title: Text('Sugerencias', style: context.textStyles.titleMedium),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sugerencia principal de IA
            _buildAISuggestionCard(context),

            const SizedBox(height: 24),

            // Recomendaciones rápidas
            Text(
              'Recomendaciones Personalizadas',
              style: context.textStyles.titleMedium,
            ),
            const SizedBox(height: 16),

            _buildQuickSuggestions(context),

            const SizedBox(height: 24),

            // Tips financieros
            Text('Tips Financieros', style: context.textStyles.titleMedium),
            const SizedBox(height: 16),

            _buildFinancialTips(context),
          ],
        ),
      ),
    );
  }

  Widget _buildAISuggestionCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            context.colors.primary,
            context.colors.surfaceContainerLowest,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome, color: Colors.white, size: 24),
              const SizedBox(width: 8),
              Text(
                'Sugerencia de IA',
                style: context.textStyles.labelMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Podrías ahorrar \$350 este mes reduciendo tus gastos en restaurantes en un 25%',
            style: context.textStyles.labelMedium?.copyWith(
              color: Colors.white,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // context.push(DetailScreen()); (Futuro)
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: context.colors.surface,
              foregroundColor: context.colors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(
              'Ver detalles',
              style: context.textStyles.labelSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickSuggestions(BuildContext context) {
    final suggestions = [
      {
        'icon': Icons.savings,
        'title': 'Optimiza tus Ahorros',
        'description':
            'Basado en tus ingresos, podrías ahorrar 15% más cada mes.',
        'color': context.colors.primary,
      },
      {
        'icon': Icons.trending_down,
        'title': 'Reduce Gastos Innecesarios',
        'description': 'Has gastado 40% más en entretenimiento este mes.',
        'color': context.colors.error,
      },
      {
        'icon': Icons.account_balance_wallet,
        'title': 'Presupuesto Inteligente',
        'description':
            'Te sugerimos un presupuesto de \$800 para gastos variables.',
        'color': context.colors.primary,
      },
    ];

    return Column(
      children: suggestions
          .map(
            (suggestion) => _buildSimpleSuggestionCard(
              context,
              suggestion['icon'] as IconData,
              suggestion['title'] as String,
              suggestion['description'] as String,
              suggestion['color'] as Color,
            ),
          )
          .toList(),
    );
  }

  Widget _buildSimpleSuggestionCard(
    BuildContext context,
    IconData icon,
    String title,
    String description,
    Color color,
  ) {
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
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: context.colors.primaryContainer,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: context.textStyles.titleSmall),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: context.textStyles.labelSmall?.copyWith(
                    color: context.colors.outline,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: context.colors.outline,
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialTips(BuildContext context) {
    final tips = [
      {
        'icon': Icons.pie_chart,
        'title': 'Regla 50/30/20',
        'description':
            'Destina 50% a necesidades, 30% a deseos y 20% a ahorros.',        
      },
      {
        'icon': Icons.security,
        'title': 'Fondo de Emergencia',
        'description':
            'Mantén entre 3-6 meses de gastos en un fondo de emergencia.',
      },
      {
        'icon': Icons.trending_up,
        'title': 'Inversión Temprana',
        'description':
            'Comenzar a invertir temprano aprovecha el interés compuesto.',
      },
    ];

    return Column(
      children: tips
          .map(
            (tip) => _buildSimpleTipCard(
              context,
              tip['icon'] as IconData,
              tip['title'] as String,
              tip['description'] as String,
            ),
          )
          .toList(),
    );
  }

  Widget _buildSimpleTipCard(
    BuildContext context,
    IconData icon,
    String title,
    String description,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.colors.primary),
      ),
      child: Row(
        children: [
          Icon(icon, color: context.colors.onSurface, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: context.textStyles.titleSmall),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: context.textStyles.labelSmall?.copyWith(
                    color: context.colors.outline,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
