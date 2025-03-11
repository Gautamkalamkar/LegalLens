import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:legallens/firebase_options.dart';
import 'package:legallens/pages/home_page.dart';
import 'package:legallens/pages/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xff007BFF),
          )),
      title: 'Flutter Demo',
      // home: HomePage(),
      home: LoginPage(),
    );
  }
}
