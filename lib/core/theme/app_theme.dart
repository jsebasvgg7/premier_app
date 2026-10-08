import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const aubergine = Color(0xFF2A0A33);
  static const cream = Color(0xFFF5F0E8);
  static const card = Colors.white;
  static const border = Color(0xFFD9CCE3);
  static const magenta = Color(0xFFE90052);
  static const plum = Color(0xFF6B3FA0);

  static const matchGradient = LinearGradient(
    colors: [Color(0xFF3B1049), Color(0xFF14041A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static ThemeData get light {
    final base = ThemeData(useMaterial3: true);
    final scheme = ColorScheme.fromSeed(seedColor: magenta).copyWith(
      primary: magenta,
      onPrimary: Colors.white,
      surface: cream,
    );
    return base.copyWith(
      colorScheme: scheme,
      scaffoldBackgroundColor: cream,
      textTheme: _textTheme(base.textTheme),
    );
  }

  static TextTheme _textTheme(TextTheme base) {
    final t = GoogleFonts.quicksandTextTheme(base)
        .apply(bodyColor: aubergine, displayColor: aubergine);
    TextStyle? medium(TextStyle? s) => s?.copyWith(fontWeight: FontWeight.w500);
    return t.copyWith(
      bodyLarge: medium(t.bodyLarge),
      bodyMedium: medium(t.bodyMedium),
      bodySmall: medium(t.bodySmall),
      titleMedium: medium(t.titleMedium),
      titleSmall: medium(t.titleSmall),
      labelLarge: medium(t.labelLarge),
    );
  }
}
