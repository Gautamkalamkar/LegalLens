import 'package:flutter/material.dart';

class DocumentView extends StatelessWidget {
  const DocumentView({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);
    return Card(
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
            Text(
              'Document Name',
              style:
                  TextStyle(fontFamily: 'Lexend', fontWeight: FontWeight.w100),
            ),
            Icon(Icons.delete),
          ],
        ),
      ),
    );
  }
}
