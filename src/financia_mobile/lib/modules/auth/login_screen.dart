import 'package:financia_mobile/extensions/navigation_extensions.dart';
import 'package:financia_mobile/modules/auth/sign_up_screen.dart';
import 'package:financia_mobile/modules/dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.sw),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: 150, width: 150, child: Placeholder()),
              const SizedBox(height: 20),
              Text(
                "FinancIA",
                style: GoogleFonts.gabarito(
                  fontWeight: FontWeight.w700,
                  fontSize: 48,
                  color: const Color(0xFF113931),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    context.push(DashboardScreen());
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 31, 133, 119),
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
                      fontWeight: FontWeight.w600,
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    context.push(SignUpScreen());
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF113931),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.green.shade200, width: 2),
                    ),
                  ),
                  child: Text(
                    "Regístrate",
                    style: GoogleFonts.gabarito(
                      fontWeight: FontWeight.w600,
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              const SizedBox(width: 200, height: 200, child: Placeholder()),
            ],
          ),
        ),
      ),
    );
  }
}
