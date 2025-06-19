import 'package:financia_mobile/extensions/navigation_extensions.dart';
import 'package:financia_mobile/extensions/theme_extensions.dart';
import 'package:financia_mobile/modules/dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white),
      body: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 5.sw),
        child: Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.onUnfocus,
          child: Column(
            mainAxisSize: MainAxisSize.min, 
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Bienvenido", style: context.textStyles.titleLarge),
              const SizedBox(height: 35),
              Text("Correo electrónico", style: context.textStyles.labelMedium),
              const SizedBox(height: 2),
              TextFormField(
                validator: _validateEmail,
                controller: _emailController,
                style: context.textStyles.labelSmall,
              ),
              const SizedBox(height: 25),
              Text("Contraseña", style: context.textStyles.labelMedium),
              const SizedBox(height: 2),
              TextFormField(
                controller: _passwordController,
                style: context.textStyles.labelSmall,
                obscureText: true,
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    context.push(DashboardScreen());
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 31, 133, 119),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "Iniciar sesión",
                    style: GoogleFonts.gabarito(
                      fontWeight: FontWeight.w500,
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
          ],
        ),
        ),
      ),
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ingrese su correo electrónico';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!emailRegex.hasMatch(value)) {
      return 'Por favor ingrese un correo electrónico válido';
    }

    return null;
  }
}
