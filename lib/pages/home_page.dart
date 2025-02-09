import 'package:flutter/material.dart';
import 'package:legallens/components/document_container.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Container(
        padding: EdgeInsets.all(20),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          children: [
            DocumentContainer(
                path: 'assets/icons/contract.png', text: 'Contract'),
            DocumentContainer(path: 'assets/icons/will.png', text: 'Will'),
            DocumentContainer(
                path: 'assets/icons/confidential_document.png',
                text: 'Confidential'),
            DocumentContainer(path: 'assets/icons/will.png', text: 'Will'),
            DocumentContainer(path: 'assets/icons/will.png', text: 'Will'),
            DocumentContainer(path: 'assets/icons/will.png', text: 'Will'),
            DocumentContainer(path: 'assets/icons/will.png', text: 'Will'),
            DocumentContainer(path: 'assets/icons/will.png', text: 'Will'),
          ],
        ),
      ),
    );
  }
}
