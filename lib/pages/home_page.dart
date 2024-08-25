import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:legallens/database/database_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Uint8List? _pdfBytes;
  var pdfs;

  @override
  void initState() {
    super.initState();
    _refreshPDFList();
  }

  void _refreshPDFList() {
    setState(() {
      pdfs = retrievePDFs();
    });
  }

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
      body: FutureBuilder<List<Map<String, dynamic>>>(
          future: pdfs,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text('No PDFs Uploaded.'),
              );
            } else {
              final pdfs = snapshot.data!;
              return ListView.builder(
                itemCount: pdfs.length,
                itemBuilder: (context, index) {
                  final pdf = pdfs[index];
                  return ListTile(
                    minTileHeight: 70,
                    title: Text(
                      pdf['name'],
                      maxLines: 1,
                    ),
                    trailing: IconButton(
                        onPressed: () {
                          deletePDF(pdf['id']).then((_) {
                            setState(() {
                              _refreshPDFList();
                            });
                          });
                        },
                        icon: Icon(Icons.delete)),
                  );
                },
              );
            }
          }),
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

      if (filePickerResult.files.isNotEmpty) {
        String name = filePickerResult.files.first.name;
        String path = filePickerResult.files.first.path!;

        await insertPDF(name, path);
      }
    }
    _refreshPDFList();
  }

  Future<void> delete(int index) async {
    final pdf = pdfs.length;
    await deletePDF(pdf['id']);
    _refreshPDFList();
  }
}
