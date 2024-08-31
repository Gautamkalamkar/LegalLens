import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class DisplayPdf extends StatefulWidget {
  const DisplayPdf({super.key, required this.path});

  final String path;

  @override
  State<DisplayPdf> createState() => _DisplayPdfState();
}

class _DisplayPdfState extends State<DisplayPdf> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PDFView(
        filePath: widget.path,
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {}, label: const Text('Process this PDF!')),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
