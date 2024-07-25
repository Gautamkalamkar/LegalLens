import 'package:flutter/material.dart';

// ThemeData lightTheme = ThemeData(
//     // useMaterial3: true,
//     colorScheme: const ColorScheme(
//         brightness: Brightness.light,
//         primary: Colors.lime[50],
//         onPrimary: Colors.black,
//         secondary: Colors.orangeAccent,
//         onSecondary: Colors.black,
//         error: Colors.red,
//         onError: Colors.white,
//         surface: Colors.grey,
//         onSurface: Colors.black));

ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.light(
        brightness: Brightness.light,
        primary: Colors.lime[100]!,
        onPrimary: Colors.black,
        secondary: Colors.orangeAccent[100]!,
        onSecondary: Colors.black,
        error: Colors.red,
        onError: Colors.white,
        surface: Colors.grey[200]!,
        onSurface: Colors.black));
