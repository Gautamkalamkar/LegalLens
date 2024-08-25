import 'package:flutter/material.dart';
import 'package:legallens/database/database_service.dart';
import 'package:legallens/pages/display_pdf.dart';

class MyListTile extends StatefulWidget {
  const MyListTile({super.key, required this.pdf, required this.onDelete});

  final Map<String, dynamic> pdf;
  final Function() onDelete;

  @override
  State<MyListTile> createState() => _MyListTileState();
}

class _MyListTileState extends State<MyListTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: const EdgeInsets.all(20.0),
        alignment: Alignment.center,
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.pdf['name'],
              maxLines: 1,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            IconButton(
              onPressed: () {
                deletePDF(widget.pdf['id']).then((_) {
                  setState(() {
                    widget.onDelete();
                  });
                });
              },
              icon: const Icon(Icons.delete_outline),
              splashRadius: 30,
            )
          ],
        ),
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DisplayPdf(path: widget.pdf['path']),
            ));
      },
    );
  }
}
