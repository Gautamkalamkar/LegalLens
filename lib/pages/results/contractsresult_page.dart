import 'package:flutter/material.dart';

class ContractsresultPage extends StatelessWidget {
  const ContractsresultPage({super.key, required this.response});

  final String response;

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

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    List<String> formattedRisks = extractAndFormatRiskStatements(response);
    return Scaffold(
      body: PageView(
        children: [
          Container(
            padding: EdgeInsets.all(20.0),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Summary',
                    style: TextStyle(
                      fontSize: size.width * 0.09,
                      fontFamily: 'Lexend',
                    ),
                  ),
                  SizedBox(
                    height: size.width * 0.15,
                  ),
                  Container(
                      child: Text(
                    extractSummary(response),
                    textAlign: TextAlign.justify,
                  )),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(20.0),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Risk Statements in the document',
                    style: TextStyle(
                      fontSize: size.width * 0.09,
                      fontFamily: 'Lexend',
                    ),
                  ),
                  SizedBox(
                    height: size.width * 0.05,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: formattedRisks.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                            formattedRisks[index],
                            textAlign: TextAlign.justify,
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
