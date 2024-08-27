import 'package:flutter/material.dart';
import 'package:legallens/database/database_service.dart';
import 'package:legallens/pages/display_pdf.dart';
import 'package:page_transition/page_transition.dart';

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
        padding: const EdgeInsets.symmetric(horizontal: 25),
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.width * 0.18,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                widget.pdf['name'],
                maxLines: 1,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            CircleAvatar(
              backgroundColor: Colors.red[100],
              child: IconButton(
                onPressed: () {
                  deletePDF(widget.pdf['id']).then((_) {
                    setState(() {
                      widget.onDelete();
                    });
                  });
                },
                icon: const Icon(Icons.delete_outline),
                splashRadius: 30,
              ),
            )
          ],
        ),
      ),
      onTap: () {
        Navigator.push(
            context,
            PageTransition(
                child: DisplayPdf(path: widget.pdf['path']),
                type: PageTransitionType.fade));
      },
    );
  }
}
