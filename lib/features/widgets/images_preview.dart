import 'package:flutter/material.dart';
import 'dart:convert'; // Untuk base64Decode

class ImagePreviewFullScreen extends StatelessWidget {
  final String imageBase64;

  const ImagePreviewFullScreen({super.key, required this.imageBase64});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: InteractiveViewer(
        boundaryMargin: const EdgeInsets.all(20),
        panEnabled: true,
        minScale: 0.5,
        maxScale: 2.5,
        child: Image.memory(
          base64Decode(imageBase64),
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}