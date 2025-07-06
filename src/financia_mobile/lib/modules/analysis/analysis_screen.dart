import 'package:flutter/material.dart';
import 'package:financia_mobile/extensions/theme_extensions.dart';
import 'package:financia_mobile/extensions/navigation_extensions.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:financia_mobile/generated/l10n.dart';

class AnalysisScreen extends StatelessWidget {
  const AnalysisScreen({super.key});

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
          S.of(context).analysis,
          style: GoogleFonts.gabarito(
            textStyle: context.textStyles.headlineSmall?.copyWith(
              color: context.colors.onSurface,
              fontSize: 27,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Resumen mensual
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4A9B8E), Color(0xFF5CB7A6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    S.of(context).june_summary,
                    style: context.textStyles.bodyLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            S.of(context).income,
                            style: context.textStyles.bodySmall?.copyWith(
                              color: Colors.white70,
                            ),
                          ),
                          Text(
                            '\$12,500.00',
                            style: context.textStyles.bodyLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Gastos',
                            style: context.textStyles.bodySmall?.copyWith(
                              color: Colors.white70,
                            ),
                          ),
                          Text(
                            '\$3,750.00',
                            style: context.textStyles.bodyLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Gastos por categoría
            Text(
              S.of(context).expenses_by_category,
              style: context.textStyles.titleMedium,
            ),
            const SizedBox(height: 16),

            CategoryExpenseItem(
              icon: Icons.shopping_cart,
              category: S.of(context).supermarket,
              amount: '\$1,250.00',
              percentage: 33,
              color: Color(0xFF4A9B8E),
            ),
            CategoryExpenseItem(
              icon: Icons.directions_car,
              category: S.of(context).transport,
              amount: '\$850.00',
              percentage: 23,
              color: Color(0xFF7BC4B8),
            ),
            CategoryExpenseItem(
              icon: Icons.restaurant,
              category: S.of(context).restaurants,
              amount: '\$650.00',
              percentage: 17,
              color: Color(0xFFB8E6C1),
            ),
            CategoryExpenseItem(
              icon: Icons.movie,
              category: S.of(context).entertainment,
              amount: '\$450.00',
              percentage: 12,
              color: Color(0xFFD4F1E8),
            ),
            CategoryExpenseItem(
              icon: Icons.more_horiz,
              category: S.of(context).other,
              amount: '\$550.00',
              percentage: 15,
              color: Color(0xFFE8F5F3),
            ),

            const SizedBox(height: 24),

            // Tendencia mensual
            Text(
              S.of(context).monthly_trend,
              style: context.textStyles.titleMedium,
            ),
            const SizedBox(height: 16),

            Container(
              height: 200,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FFFE),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:
                        [
                              S.of(context).month_jan,
                              S.of(context).month_feb,
                              S.of(context).month_mar,
                              S.of(context).month_apr,
                              S.of(context).month_may,
                              S.of(context).month_jun,
                            ]
                            .map(
                              (m) => Text(
                                m,
                                style: context.textStyles.bodySmall?.copyWith(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            )
                            .toList(),
                  ),
                  const SizedBox(height: 16),
                  const Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        ChartBar(height: 60, color: Color(0xFFB8E6C1)),
                        ChartBar(height: 80, color: Color(0xFF7BC4B8)),
                        ChartBar(height: 100, color: Color(0xFF4A9B8E)),
                        ChartBar(height: 120, color: Color(0xFF4A9B8E)),
                        ChartBar(height: 40, color: Color(0xFFD4F1E8)),
                        ChartBar(height: 20, color: Color(0xFFE8F5F3)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Objetivos de Ahorro
            Text(
              S.of(context).savings_goals,
              style: context.textStyles.titleMedium,
            ),
            const SizedBox(height: 16),

            SavingsGoalCard(
              title: S.of(context).vacation,
              current: 2500,
              target: 5000,
              color: Color(0xFF4A9B8E),
            ),
            const SizedBox(height: 12),
            SavingsGoalCard(
              title: S.of(context).emergency_fund,
              current: 8750,
              target: 15000,
              color: Color(0xFF7BC4B8),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryExpenseItem extends StatelessWidget {
  final IconData icon;
  final String category;
  final String amount;
  final int percentage;
  final Color color;

  const CategoryExpenseItem({
    super.key,
    required this.icon,
    required this.category,
    required this.amount,
    required this.percentage,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withAlpha(51),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category,
                  style: context.textStyles.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: context.colors.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: percentage / 100,
                    child: Container(
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: context.textStyles.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: context.colors.onSurface,
                ),
              ),
              Text(
                '$percentage%',
                style: context.textStyles.bodySmall?.copyWith(
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ChartBar extends StatelessWidget {
  final double height;
  final Color color;

  const ChartBar({super.key, required this.height, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class SavingsGoalCard extends StatelessWidget {
  final String title;
  final double current;
  final double target;
  final Color color;

  const SavingsGoalCard({
    super.key,
    required this.title,
    required this.current,
    required this.target,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final progress = current / target;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withAlpha(76)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: context.textStyles.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: context.colors.onSurface,
                ),
              ),
              Text(
                '${(progress * 100).toInt()}%',
                style: context.textStyles.bodySmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '\$${current.toInt()} de \$${target.toInt()}',
            style: context.textStyles.bodySmall?.copyWith(
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation(color),
          ),
        ],
      ),
    );
  }
}
