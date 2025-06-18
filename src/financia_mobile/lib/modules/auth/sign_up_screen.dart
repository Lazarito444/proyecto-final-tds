import 'package:financia_mobile/extensions/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmationController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.sw),
        child: Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.onUnfocus,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Registro", style: context.textStyles.titleLarge),
              const SizedBox(height: 35),
              Text("Nombre completo", style: context.textStyles.labelMedium),
              const SizedBox(height: 2),
              TextFormField(
                validator: _validateName,
                controller: _fullNameController,
              ),
              SizedBox(height: 25),
              Text("Correo electrónico", style: context.textStyles.labelMedium),
              const SizedBox(height: 2),
              TextFormField(
                validator: _validateEmail,
                controller: _emailController,
              ),
              SizedBox(height: 25),
              Text("Contraseña", style: context.textStyles.labelMedium),
              const SizedBox(height: 2),
              TextFormField(
                validator: _validatePassword,
                controller: _passwordController,
                obscureText: true,
              ),
              SizedBox(height: 25),
              Text(
                "Confirmar contraseña",
                style: context.textStyles.labelMedium,
              ),
              const SizedBox(height: 2),
              TextFormField(
                validator: _validatePasswordConfirmation,
                controller: _passwordConfirmationController,
                obscureText: true,
              ),
              SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {},
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
                    "Crear cuenta",
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

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return "El nombre completo es obligatorio";
    }

    if (value.length < 3) {
      return "El nombre completo debe tener 3\ncaracteres como mínimo";
    }

    return null;
  }

  String? _validateEmail(String? value) {
    final RegExp emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegExp.hasMatch(value ?? "")) {
      return "Correo electrónico inválido";
    }

    return null;
  }

  String? _validatePassword(String? value) {
    final RegExp passwordRegExp = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{6,}$',
    );

    if (value == null || value.isEmpty) {
      return "La contraseña es obligatoria";
    }

    if (!passwordRegExp.hasMatch(value)) {
      return "La contraseña debe tener al menos 6\ncaracteres, una mayúscula, una minúscula y un número";
    }

    return null;
  }

  String? _validatePasswordConfirmation(String? value) {
    if (_passwordController.text != _passwordConfirmationController.text) {
      return "Las contraseñas no coinciden";
    }

    return null;
  }
}
