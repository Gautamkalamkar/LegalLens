import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PdfviewerPage extends StatelessWidget {
  const PdfviewerPage({super.key, required this.pdfPath});

  final String pdfPath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PDFView(
          filePath: pdfPath,
          fitEachPage: true,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () {}, label: Text('Process PDF')));
  }
}
