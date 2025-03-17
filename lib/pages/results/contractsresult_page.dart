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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: [
          Container(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(extractSummary(response))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
