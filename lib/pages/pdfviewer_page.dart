import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:hive_ce/hive.dart';
import 'package:legallens/pages/loading_page.dart';
import 'package:legallens/pages/results/contractsresult_page.dart';
import 'package:legallens/services/deepseek_service.dart';
import 'package:legallens/services/hive_service.dart';

class PdfviewerPage extends StatelessWidget {
  const PdfviewerPage(
      {super.key, required this.pdfPath, required this.docType});

  final String pdfPath;
  final String docType;
  final String contractPrompt =
      "Analyze the provided legal document (agreement/contract) and perform the following tasks: "
      "1. **Document Identification**: Understand the type of contract/agreement and, if possible, the industry or context it belongs to. Use this understanding to tailor the analysis, but **do not explicitly generate a 'Document Type and Context' section in the response**. "
      "2. **High-Level Summary**: Write the entire summary in one concise paragraph. Focus on key elements such as parties involved, main obligations, payment terms, termination clauses, and other critical provisions. Use simple, easy-to-understand language and avoid legal jargon unless briefly explained. "
      "3. **Risk Identification**: Identify and list all significant risks in the document. Prioritize risks based on their potential impact (e.g., financial, legal, operational) and likelihood. Present them in bullet points, with the highest priority risks first. Include the page number(s) where each risk statement is found in the document. "
      "4. **Risk Mitigation Suggestions**: Provide actionable suggestions to mitigate or improve the identified risks. Tailor the suggestions to the specific risks and context of the document. "
      "5. **Tone and Format**: Use clear and simple language for readability. Structure the response as follows: "
      "   - Start the **summary** with the marker `[SUMMARY]`. "
      "   - Start the **risk identification** section with the marker `[RISKS]`. "
      "   - Start the **mitigation suggestions** section with the marker `[MITIGATIONS]`. "
      "6. **Audience**: Assume the user has no legal background and tailor the response for clarity and simplicity. "
      "7. **Additional Instructions**: "
      "   - **Do not include any headings or subheadings in the response**. "
      "   - **Do not generate a 'Document Type and Context' section**. Use the understanding of the document type and context to inform the analysis, but do not explicitly state it in the output. "
      "   - Ensure the summary, risks, and mitigations are clearly separated by their respective markers.";

  final String courtDocsPrompt =
      "Analyze the provided legal document (plaint/petition, written statement, affidavit, memorandum of appeal, rejoinder/rebuttal, or interim application) and perform the following tasks: "
      "1. **Document Identification**: Understand the type of court document, its purpose, and the legal context (e.g., civil, criminal, commercial, family law, etc.). Use this understanding to tailor the analysis, but **do not explicitly generate a 'Document Type and Context' section in the response**. "
      "2. **High-Level Summary**: Write the entire summary in one concise paragraph. Focus on key elements such as the parties involved, the nature of the dispute or claim, the relief sought, key arguments or defenses, and any critical procedural or substantive issues. Use simple, easy-to-understand language and avoid legal jargon unless briefly explained. "
      "3. **Risk Identification**: Identify and list all significant risks or weaknesses in the document. Prioritize risks based on their potential impact (e.g., likelihood of success, procedural defects, evidentiary gaps, or adverse legal consequences) and likelihood. Present them in bullet points, with the highest priority risks first. Include the page number(s) or paragraph reference(s) where each risk is found in the document. "
      "4. **Risk Mitigation Suggestions**: Provide actionable suggestions to address or mitigate the identified risks. Tailor the suggestions to the specific risks and context of the document. For example, suggest amendments to arguments, additional evidence, procedural corrections, or strategic considerations. "
      "5. **Tone and Format**: Use clear and professional language for readability, ensuring the analysis is accessible to both legal and non-legal audiences. Structure the response as follows: "
      "   - Start the **summary** with the marker `[SUMMARY]`. "
      "   - Start the **risk identification** section with the marker `[RISKS]`. "
      "   - Start the **mitigation suggestions** section with the marker `[MITIGATIONS]`. "
      "6. **Audience**: Assume the user may have no legal background and tailor the response for clarity and simplicity. Avoid overly technical language unless necessary, and briefly explain any legal terms or concepts used. "
      "7. **Additional Instructions**: "
      "   - **Do not include any headings or subheadings in the response**. "
      "   - **Do not generate a 'Document Type and Context' section**. Use the understanding of the document type and context to inform the analysis, but do not explicitly state it in the output. "
      "   - Ensure the summary, risks, and mitigations are clearly separated by their respective markers.";

  @override
  Widget build(BuildContext context) {
    final box = Hive.box('documentsBox');
    final HiveService hiveService = HiveService();
    final String text = hiveService.retrieveTextFromHive(box, pdfPath);
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
