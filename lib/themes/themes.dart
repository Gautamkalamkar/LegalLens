import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xff007BFF),
    ),
    scaffoldBackgroundColor: const Color(0xFF435E91),
    textTheme: GoogleFonts.outfitTextTheme()
        .apply(bodyColor: Colors.white, displayColor: Colors.white),
    inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(color: Colors.white), // Labels for TextField
        hintStyle: TextStyle(color: Colors.white), // Hint text
        border: OutlineInputBorder(
            borderSide: BorderSide(style: BorderStyle.none))),
    iconTheme: IconThemeData(
      color: Colors.white,
    ));

ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey));
