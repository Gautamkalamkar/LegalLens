import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import 'package:legallens/components/document_view.dart';
import 'package:legallens/services/hive_service.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class ContractsPage extends StatefulWidget {
  const ContractsPage({super.key});

  @override
  State<ContractsPage> createState() => _ContractsPageState();
}

class _ContractsPageState extends State<ContractsPage> {
  final box = Hive.box('documentsBox');
  final HiveService _hiveService = HiveService();
  List<Map<dynamic, dynamic>> contracts = [];

  @override
  void initState() {
    super.initState();
    contracts = _hiveService.loadKey('contracts', contracts, box);
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
          child: Text('Contracts'),
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
          itemCount: contracts.length,
          itemBuilder: (context, index) {
            final contract = contracts[index];
            return DocumentView(
                name: contract['name'],
                path: contract['path'],
                docType: 'contracts',
                onDelete: () {
                  _hiveService.deletekey(index, contracts, box, 'contracts');
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
              if (!_hiveService.isDuplicate(file.name.trim(), contracts)) {
                contracts.add({
                  'name': file.name.trim(),
                  'path': file.path,
                  'text': text
                });
                box.put('contracts', contracts);

                //Dispose the document and update the UI
                document.dispose();
                contracts = _hiveService.loadKey('contracts', contracts, box);
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
