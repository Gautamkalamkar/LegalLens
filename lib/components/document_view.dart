import 'package:flutter/material.dart';
import 'package:legallens/pages/pdfviewer_page.dart';

class DocumentView extends StatelessWidget {
  const DocumentView(
      {super.key,
      required this.name,
      required this.path,
      required this.onDelete,
      required this.docType});

  final String name;
  final String path;
  final String docType;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PdfviewerPage(
                pdfPath: path,
                docType: docType,
              ),
            ));
      },
      child: Card(
        elevation: 20.0,
        margin: EdgeInsets.only(bottom: 20),
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: Theme.of(context).colorScheme.primaryContainer,
          ),
          width: size.width,
          height: size.height * 0.1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  name,
                  style: TextStyle(
                      fontFamily: 'Lexend',
                      fontWeight: FontWeight.w100,
                      color: Colors.black),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              IconButton(
                  onPressed: onDelete,
                  icon: Icon(
                    Icons.delete,
                    color: Colors.black,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
