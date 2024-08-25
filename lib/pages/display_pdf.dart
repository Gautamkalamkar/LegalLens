import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class DisplayPdf extends StatelessWidget {
  const DisplayPdf({super.key, required this.path});

  final String path;

  @override
  Widget build(BuildContext context) {
    return PDFView(
      filePath: path,
    );
  }
}
