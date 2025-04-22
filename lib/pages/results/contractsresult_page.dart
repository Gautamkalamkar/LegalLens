import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class ContractsresultPage extends StatelessWidget {
  ContractsresultPage({super.key, required this.response});

  final String response;
  final PageController _pageController = PageController();

  String extractSummary(String response) {
    if (response.contains("[SUMMARY]")) {
      // Split the response at [SUMMARY] and take the part after it
      String summarySection = response.split("[SUMMARY]")[1].trim();

      // Split again at [RISKS] to isolate the summary
      if (summarySection.contains("[RISKS]")) {
        return summarySection.split("[RISKS]")[0].trim();
      }

      // If [RISKS] is not found, return the entire summary section
      return summarySection;
    }

    return "No summary found."; // Fallback if [SUMMARY] marker is missing
  }

  List<String> extractAndFormatRiskStatements(String response) {
    if (response.contains("[RISKS]")) {
      // Split the response at [RISKS] and take the part after it
      String risksSection = response.split("[RISKS]")[1].trim();

      // Split again at [MITIGATIONS] to isolate the risks
      if (risksSection.contains("[MITIGATIONS]")) {
        risksSection = risksSection.split("[MITIGATIONS]")[0].trim();
      }

      // Split the risks section into individual lines
      List<String> riskLines = risksSection.split("\n");

      // Clean and format each risk statement
      List<String> formattedRisks = [];
      for (String line in riskLines) {
        if (line.trim().isNotEmpty) {
          // Remove double asterisks (**) and trim whitespace
          String cleanedLine = line.replaceAll("**", "").trim();
          formattedRisks.add(cleanedLine);
        }
      }

      return formattedRisks;
    }

    return ["No risks found."]; // Fallback if [RISKS] marker is missing
  }

  Future<void> _createAndSavePdf(BuildContext context) async {
    try {
      // Request storage permission
      if (!await _requestStoragePermission()) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Storage permission is required to save the PDF.')),
        );
        return;
      }

      // Create PDF
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfTextElement summaryElement = PdfTextElement(
        text: extractSummary(response),
        font: PdfStandardFont(PdfFontFamily.helvetica, 12),
      );

      summaryElement.draw(
        page: page,
        bounds: Rect.fromLTWH(0, 0, page.getClientSize().width, 50),
      );

      // Add risk statements
      final List<String> formattedRisks =
          extractAndFormatRiskStatements(response);
      double yOffset = 50;
      for (String risk in formattedRisks) {
        final PdfTextElement riskElement = PdfTextElement(
          text: risk,
          font: PdfStandardFont(PdfFontFamily.helvetica, 12),
        );
        riskElement.draw(
          page: page,
          bounds: Rect.fromLTWH(0, yOffset, page.getClientSize().width, 20),
        );
        yOffset += 20;
      }

      final List<int> bytes = await document.save();
      document.dispose();

      // Let user pick a directory
      String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

      // Save PDF
      final String path = '$selectedDirectory/contract_summary.pdf';
      final File file = File(path);
      await file.writeAsBytes(bytes, flush: true);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('PDF saved to $path')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save PDF: $e')),
      );
    }
  }

  // Function to request storage permissions
  Future<bool> _requestStoragePermission() async {
    if (Platform.isAndroid) {
      final status = await Permission.storage.request();

      if (status.isGranted) {
        return true;
      } else if (status.isPermanentlyDenied) {
        openAppSettings();
      }

      return false;
    }
    return true; // No permission needed for iOS
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    List<String> formattedRisks = extractAndFormatRiskStatements(response);
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView(
        controller: _pageController,
        children: [
          Container(
            padding: EdgeInsets.only(top: 50, bottom: 30, left: 30, right: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Summary',
                  style: TextStyle(
                      fontSize: size.width * 0.09,
                      fontFamily: 'Lexend',
                      color: Colors.black),
                ),
                SizedBox(
                  height: size.width * 0.15,
                ),
                Text(
                  extractSummary(response),
                  textAlign: TextAlign.justify,
                  style: TextStyle(color: Colors.black),
                ),
                Spacer(),
                SizedBox(
                    width: double.infinity,
                    height: size.height * 0.06,
                    child: TextButton(
                      onPressed: () {
                        _pageController.nextPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut);
                      },
                      style: TextButton.styleFrom(
                          padding: EdgeInsets.all(15.0),
                          backgroundColor:
                              Theme.of(context).colorScheme.primaryContainer,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0))),
                      child: Text(
                        'Next',
                        style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer),
                      ),
                    )),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 50, bottom: 30, left: 30, right: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Risk Statements',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: size.width * 0.09,
                    fontFamily: 'Lexend',
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  height: size.width * 0.03,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: formattedRisks.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          style: TextStyle(color: Colors.black),
                          formattedRisks[index],
                          textAlign: TextAlign.justify,
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: size.width * 0.1,
                ),
                SizedBox(
                    width: double.infinity,
                    height: size.height * 0.06,
                    child: TextButton(
                      onPressed: () async {
                        await _createAndSavePdf(
                            context); // Await the PDF creation
                      },
                      style: TextButton.styleFrom(
                          padding: EdgeInsets.all(15.0),
                          backgroundColor:
                              Theme.of(context).colorScheme.primaryContainer,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0))),
                      child: Text(
                        'Download PDF',
                        style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer),
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
