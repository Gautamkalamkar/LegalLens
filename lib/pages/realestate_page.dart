import 'package:flutter/material.dart';

class RealestatePage extends StatefulWidget {
  const RealestatePage({super.key});

  @override
  State<RealestatePage> createState() => _RealestatePageState();
}

class _RealestatePageState extends State<RealestatePage> {
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
          child: Text('Real Estate'),
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
            onPressed: () {},
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
