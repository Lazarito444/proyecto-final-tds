import 'package:financia_mobile/extensions/theme_extensions.dart';
import 'package:flutter/material.dart';

class FullWidthButton extends StatelessWidget {

  final void Function() onPressed;
  final String text;

  const FullWidthButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: onPressed,
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
          text,
          style: context.textStyles.titleSmall!.copyWith(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}