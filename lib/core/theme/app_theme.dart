import 'package:flutter/material.dart';

class AppTheme {
  static const purple = Color(0xFF38003C);
  static const violet = Color(0xFF7B2FF7);
  static const lilac = Color(0xFFEFE6FA);

  static const headerGradient = LinearGradient(
    colors: [Color(0xFF2A0030), Color(0xFF7B2FF7)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: violet),
        scaffoldBackgroundColor: Colors.white,
        textTheme: ThemeData.light().textTheme.apply(bodyColor: purple, displayColor: purple),
      );
}
