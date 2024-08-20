import 'package:flutter/material.dart';

class CustomField extends StatelessWidget {
  final String hintText;
  final bool readOnly;
  final VoidCallback? onTap;
  final TextEditingController? controller;
  final bool isPassword;
  const CustomField(
      {super.key,
      required this.hintText,
      required this.controller,
      this.readOnly = false,
      this.onTap,
      this.isPassword = false});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: onTap,
      readOnly: readOnly,
      obscureText: isPassword,
      validator: (value) {
        if (value!.trim().isEmpty) {
          return "$hintText is Empty";
        }
        return null;
      },
      controller: controller,
      decoration: InputDecoration(hintText: hintText),
    );
  }
}
