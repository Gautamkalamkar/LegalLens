import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:hive_ce/hive.dart';
import 'package:legallens/pages/loading_page.dart';
import 'package:legallens/pages/results/contractsresult_page.dart';
import 'package:legallens/services/deepseek_service.dart';

class PdfviewerPage extends StatelessWidget {
  const PdfviewerPage({super.key, required this.pdfPath});

  final String pdfPath;
  final String contractPrompt =
      "Analyze the provided legal document (agreement/contract) and perform the following tasks:Document Identification: Identify the type of contract/agreement and, if possible, the industry or context it belongs to. State this at the beginning of the analysis.High-Level Summary: Write the entire summary in one concise paragraph. Focus on key elements such as parties involved, main obligations, payment terms, termination clauses, and other critical provisions. Use simple, easy-to-understand language and avoid legal jargon unless briefly explained.Risk Identification: Identify and list all significant risks in the document. Prioritize risks based on their potential impact (e.g., financial, legal, operational) and likelihood. Present them in bullet points, with the highest priority risks first. Include the page number(s) where each risk statement is found in the document.Risk Mitigation Suggestions: Provide actionable suggestions to mitigate or improve the identified risks. Tailor the suggestions to the specific risks and context of the document.Tone and Format: Use clear headings, bullet points, and simple language for readability. Ensure the response is structured as follows: Document Type and Context Summary(one paragraph) Identified Risks(with page numbers) Mitigation Suggestions. Audience: Assume the user has no legal background and tailor the response for clarity and simplicity.";

  @override
  Widget build(BuildContext context) {
    final box = Hive.box('documentsBox');
    List<dynamic> contracts = box.get('contracts');

    // Find the contract with the matching pdfPath
    final contract = contracts.firstWhere(
      (contract) => contract['path'] == pdfPath,
      orElse: () => {},
    );

    // Retrieve the text from the contract
    final String text = contract['text'] ?? 'No text found';
    return Scaffold(
        body: PDFView(
          filePath: pdfPath,
          fitEachPage: true,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoadingPage()),
              );

              // Call the API in the background
              final response =
                  await DeepseekService().accessDeepseek(text, contractPrompt);

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ContractsresultPage(response: response),
                ),
              );
            },
            label: Text('Process PDF')));
  }
}
