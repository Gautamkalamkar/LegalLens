import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class ContractsPage extends StatefulWidget {
  const ContractsPage({super.key});

  @override
  State<ContractsPage> createState() => _ContractsPageState();
}

class _ContractsPageState extends State<ContractsPage> {
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
      floatingActionButton: Container(
        margin: EdgeInsets.all(size.width * 0.03),
        width: size.width * 0.16,
        child: FittedBox(
          child: FloatingActionButton(
            onPressed: () async {
              final result = await FilePicker.platform
                  .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
              if (result == null) return;
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
