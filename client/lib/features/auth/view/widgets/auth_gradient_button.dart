import 'package:client/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

class AuthGradientButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const AuthGradientButton(
      {super.key, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [
          Pallete.gradient1,
          Pallete.gradient2,
        ], begin: Alignment.bottomLeft, end: Alignment.topRight),
        borderRadius: BorderRadius.circular(17),
      ),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Pallete.transparentColor,
          shadowColor: Pallete.transparentColor,
          fixedSize: const Size(395, 55),
        ),
        child: Text(
          label,
          style: const TextStyle(
              fontSize: 17,
              color: Pallete.whiteColor,
              fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
