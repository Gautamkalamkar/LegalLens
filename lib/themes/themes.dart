import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xff007BFF),
    ),
    scaffoldBackgroundColor: const Color(0xFF435E91),
    textTheme: GoogleFonts.outfitTextTheme()
        .apply(bodyColor: Colors.black, displayColor: Colors.black),
    iconTheme: IconThemeData(
      color: Colors.white,
    ));

ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey));
