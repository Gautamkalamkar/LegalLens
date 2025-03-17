import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import 'package:legallens/components/document_view.dart';
import 'package:legallens/services/hive_service.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class OtherPage extends StatefulWidget {
  const OtherPage({super.key});

  @override
  State<OtherPage> createState() => _OtherPageState();
}

class _OtherPageState extends State<OtherPage> {
  final box = Hive.box('documentsBox');
  final HiveService _hiveService = HiveService();
  List<Map<dynamic, dynamic>> others = [];

  @override
  void initState() {
    super.initState();
    _hiveService.loadKey('others', others, box);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Padding(
          padding: EdgeInsets.only(left: size.width * 0.02),
          child: Text('others'),
        ),
        titleTextStyle: TextStyle(
            fontFamily: 'Lexend',
            color: Theme.of(context).colorScheme.onPrimary,
            fontSize: size.height * 0.03),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView.builder(
          itemCount: others.length,
          itemBuilder: (context, index) {
            final other = others[index];
            return DocumentView(
                name: other['name'],
                path: other['path'],
                docType: 'others',
                onDelete: () {
                  _hiveService.deletekey(index, others, box, 'others');
                  setState(() {});
                });
          },
        ),
      ),
      floatingActionButton: Container(
        margin: EdgeInsets.all(size.width * 0.03),
        width: size.width * 0.16,
        child: FittedBox(
          child: FloatingActionButton(
            onPressed: () async {
              //Pick files from local storage
              final result = await FilePicker.platform
                  .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
              if (result == null) return;
              PlatformFile file = result.files.first;

              //read text from the pdf file
              PdfDocument document =
                  PdfDocument(inputBytes: File(file.path!).readAsBytesSync());
              String text = PdfTextExtractor(document).extractText();

              //Add the details of file to the hive and also the list
              if (!_hiveService.isDuplicate(file.name.trim(), others)) {
                others.add({
                  'name': file.name.trim(),
                  'path': file.path,
                  'text': text
                });
                box.put('others', others);

                //Dispose the document and update the UI
                document.dispose();
                setState(() {});
              }
            },
            elevation: 10.0,
            child: Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}
