import 'package:financia_mobile/extensions/navigation_extensions.dart';
import 'package:financia_mobile/extensions/theme_extensions.dart';
import 'package:financia_mobile/modules/auth/auth_screen.dart';
import 'package:financia_mobile/modules/welcome/onboarding_screen.dart';
import 'package:financia_mobile/widgets/full_width_button.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Widget> _pages = [
    OnboardingPage(
      title: 'Bienvenido',
      description:
          'FinancIA es la app que te ayuda a gestionar tus finanzas personales.',
      icon: Icons.monetization_on_outlined,
    ),
    OnboardingPage(
      title: 'Controla tus gastos',
      description: 'Agrega y clasifica tus gastos fácilmente.',
      icon: Icons.bar_chart,
    ),
    OnboardingPage(
      title: 'Predicciones y sugerencias inteligentes',
      description:
          'Nuestra IA te ayuda a predecir tus financias futuras y a recibir recomendaciones para mejorar tus financias.',
      icon: Icons.auto_graph,
    ),
  ];

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _finishOnboarding();
    }
  }

  Future<void> _finishOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_first_launch', false);
    context.pushReplacement(AuthScreen());
  }

  void _onPageChanged(int index) {
    setState(() => _currentPage = index);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLastPage = _currentPage == _pages.length - 1;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                children: _pages,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                (index) => AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  margin: EdgeInsets.symmetric(horizontal: 4, vertical: 10),
                  width: _currentPage == index ? 12 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? context.colors.primary
                        : Colors.grey,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: FullWidthButton(
                onPressed: _nextPage,
                text: isLastPage ? 'Comenzar' : 'Siguiente',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
