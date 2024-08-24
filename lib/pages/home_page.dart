import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Uint8List? _pdfBytes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        onPressed: openFile,
        child: Icon(
          Icons.camera,
          size: 30.0,
        ),
      ),
      body: Container(
        child: _pdfBytes != null
            ? PDFView(
                pdfData: _pdfBytes,
              )
            : const Center(
                child: Text('Choose a PDF file to open'),
              ),
      ),
      bottomNavigationBar: BottomAppBar(
          color: Theme.of(context).focusColor,
          shape: CircularNotchedRectangle(),
          notchMargin: 8.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(onPressed: () {}, icon: Icon(Icons.home)),
              IconButton(onPressed: () {}, icon: Icon(Icons.settings))
            ],
          )),
      extendBody: true,
    );
  }

  Future<void> openFile() async {
    FilePickerResult? filePickerResult = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);

    if (filePickerResult != null) {
      if (kIsWeb) {
        _pdfBytes = filePickerResult.files.single.bytes;
      } else {
        String? filePath = filePickerResult.files.single.path;
        if (filePath != null) {
          _pdfBytes = await File(filePath).readAsBytes();
        }
      }
    }
    setState(() {});
  }
}
