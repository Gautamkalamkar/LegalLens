import 'package:flutter/material.dart';

class DocumentContainer extends StatelessWidget {
  const DocumentContainer(
      {super.key, required this.path, required this.text, required this.page});

  final String path, text;
  final Widget page;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => page,
            ));
      },
      child: Material(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).colorScheme.primaryContainer,
        elevation: 20,
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                path,
                width: size.width * 0.2,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                text,
                style: TextStyle(
                  fontFamily: 'Lexend',
                  fontSize: size.width * 0.045,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
