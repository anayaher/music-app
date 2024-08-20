import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

String rbgToHex(Color color) {
  return '${color.red.toRadixString(16).padLeft(2, '0')}${color.green.toRadixString(16).padLeft(2, '0')}${color.blue.toRadixString(16).padLeft(2, '0')}';
}

Color hexToColor(String hex) {
  return Color(int.parse(hex, radix: 16)  + 0XFF000000);
}

void showSnackBar(BuildContext context, String content) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
    ),
  );
}

Future<File?> pickAudio() async {
  try {
    final fpr = await FilePicker.platform.pickFiles(
      type: FileType.audio,
    );
    if (fpr != null) {
      return File(fpr.files.first.xFile.path);
    }
    return null;
  } catch (e) {
    return null;
  }
}

Future<File?> pickImage() async {
  try {
    final fpr = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (fpr != null) {
      return File(fpr.files.first.xFile.path);
    }
    return null;
  } catch (e) {
    return null;
  }
}
