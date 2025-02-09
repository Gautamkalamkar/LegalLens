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
    var size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Padding(
          padding: EdgeInsets.only(left: size.width * 0.02),
          child: Text('LegalLens'),
        ),
        titleTextStyle: TextStyle(
            fontFamily: 'Lexend',
            color: Theme.of(context).colorScheme.onPrimary,
            fontSize: size.height * 0.03),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: size.height * 0.02),
            child: Icon(
              Icons.more_vert,
              color: Theme.of(context).colorScheme.onPrimary,
              size: size.height * 0.03,
            ),
          )
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
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
