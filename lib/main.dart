import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:legallens/pages/home_page.dart';
import 'package:legallens/theme/light_theme.dart';
import 'package:page_transition/page_transition.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: lightTheme,
        debugShowCheckedModeBanner: false,
        title: 'LegalLens',
        home: AnimatedSplashScreen(
          splash: Image.asset('assets/images/logo.png'),
          nextScreen: HomePage(),
          duration: 2000,
          splashTransition: SplashTransition.scaleTransition,
          centered: true,
          splashIconSize: 150.0,
          curve: Curves.fastEaseInToSlowEaseOut,
          pageTransitionType: PageTransitionType.topToBottom,
          backgroundColor:
              (const Color.fromRGBO(240, 244, 195, 1)), //Hex value: #f0f4c3
        ));
  }
}
