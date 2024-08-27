import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:legallens/components/custom_app_bar.dart';
import 'package:legallens/components/my_list_tile.dart';
import 'package:legallens/database/database_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var pdfs;
  late String name, path;

  @override
  void initState() {
    super.initState();
    refreshPDFList();
  }

  void refreshPDFList() {
    setState(() {
      pdfs = retrievePDFs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'LegalLens'),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: openFile,
        child: const Icon(
          Icons.camera,
          size: 30.0,
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
          future: pdfs,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text('No PDFs Uploaded.'),
              );
            } else {
              final pdfs = snapshot.data!;
              return ListView.builder(
                itemCount: pdfs.length,
                itemBuilder: (context, index) {
                  final pdf = pdfs[index];
                  return MyListTile(
                    pdf: pdf,
                    onDelete: () {
                      refreshPDFList();
                    },
                  );
                },
              );
            }
          }),
      bottomNavigationBar: BottomAppBar(
          color: Theme.of(context).focusColor,
          shape: const CircularNotchedRectangle(),
          notchMargin: 8.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.home)),
              IconButton(onPressed: () {}, icon: const Icon(Icons.settings))
            ],
          )),
      // extendBody: true,
    );
  }

  Future<void> openFile() async {
    FilePickerResult? filePickerResult = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);

    if (filePickerResult != null && filePickerResult.files.isNotEmpty) {
      name = filePickerResult.files.first.name;
      path = filePickerResult.files.first.path!;

      await insertPDF(name, path);
    }
    refreshPDFList();
  }

  Future<void> delete(int index) async {
    final pdf = pdfs.length;
    await deletePDF(pdf['id']);
    refreshPDFList();
  }
}
