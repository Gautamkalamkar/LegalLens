import 'package:flutter/material.dart';

class ContractsresultPage extends StatelessWidget {
  const ContractsresultPage({super.key, required this.response});

  final String response;

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
                Container(child: Text(response)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
