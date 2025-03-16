import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import 'package:legallens/components/document_view.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class ContractsPage extends StatefulWidget {
  const ContractsPage({super.key});

  @override
  State<ContractsPage> createState() => _ContractsPageState();
}

class _ContractsPageState extends State<ContractsPage> {
  final box = Hive.box('documentsBox');
  final prompt =
      "Analyze the provided legal document (agreement/contract) and perform the following tasks:Document Identification: Understand the type of contract/agreement and, if possible, the industry or context it belongs to. Use this understanding to tailor the analysis, but do not explicitly generate a 'Document Type and Context' section in the response.High-Level Summary: Write the entire summary in one concise paragraph. Focus on key elements such as parties involved, main obligations, payment terms, termination clauses, and other critical provisions. Use simple, easy-to-understand language and avoid legal jargon unless briefly explained.Risk Identification: Identify and list all significant risks in the document. Prioritize risks based on their potential impact (e.g., financial, legal, operational) and likelihood. Present them in bullet points, with the highest priority risks first. Include the page number(s) where each risk statement is found in the document.Risk Mitigation Suggestions: Provide actionable suggestions to mitigate or improve the identified risks. Tailor the suggestions to the specific risks and context of the document.Tone and Format: Use clear and simple language for readability. Ensure the response is structured as follows:Summary (one paragraph) Identified Risks (with page numbers) Mitigation Suggestions.Audience: Assume the user has no legal background and tailor the response for clarity and simplicity.Additional Instructions: Do not include any headings or subheadings in the response.The response should flow naturally from the summary to the risks and then to the mitigation suggestions.Use the understanding of the document type and context to inform the analysis, but do not explicitly state it in the output.";
  List<Map<dynamic, dynamic>> contracts = [];

  bool _isDuplicate(String name) {
    return contracts.any((contract) => contract['name'] == name);
  }

  void loadContracts() {
    final data = box.get('contracts', defaultValue: <Map>[]);
    if (data is List) {
      contracts = data.cast<Map<dynamic, dynamic>>(); // Safely cast the data
    } else {
      contracts = []; // Fallback to an empty list if the data is invalid
    }
  }

  void _deleteContract(int index) {
    setState(() {
      contracts.removeAt(index); // Remove the contract from the list
      box.put('contracts', contracts); // Update the Hive box
    });
  }

  @override
  void initState() {
    super.initState();
    loadContracts();
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
              onDelete: () => _deleteContract(index),
            );
          },
        ),
      ),
      floatingActionButton: Container(
        margin: EdgeInsets.all(size.width * 0.03),
        width: size.width * 0.16,
        child: FittedBox(
          child: FloatingActionButton(
            onPressed: () async {
              final result = await FilePicker.platform
                  .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
              if (result == null) return;

              PlatformFile file = result.files.first;
              loadContracts();
              PdfDocument document =
                  PdfDocument(inputBytes: File(file.path!).readAsBytesSync());
              String text = PdfTextExtractor(document).extractText();
              if (!_isDuplicate(file.name.trim())) {
                contracts.add({
                  'name': file.name.trim(),
                  'path': file.path,
                  'text': text
                });

                box.put('contracts', contracts);
                // contracts.clear();
                // box.delete('contracts');
                // for (var contract in contracts) {
                //   print(
                //       'Name: ${contract['name']}, Path: ${contract['path']}, Text: ${contract['text']}');
                // }
                document.dispose();
                setState(() {});
              }
            },
            elevation: 10.0,
            child: Image.asset(
              'assets/icons/add_document.png',
              width: size.width * 0.1,
            ),
          ),
        ),
      ),
    );
  }
}
