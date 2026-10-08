import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Sistema visual: superficies suaves, una tarjeta oscura de contraste
/// y un único acento (verde Premier) sobre fondos oscuros.
class AppTheme {
  static const aubergine = Color(0xFF2A0A33);
  static const plum = Color(0xFF6B3FA0);
  static const magenta = Color(0xFFE90052); // acción / marcador
  static const neon = Color(0xFF00FF85); // acento sobre oscuro
  static const cream = Color(0xFFF3F0F6);
  static const card = Colors.white;
  static const border = Color(0xFFD9CCE3);

  static const background = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFECEAF0), Color(0xFFF3F0F6), Color(0xFFE2F5EA)],
    stops: [0, 0.6, 1],
  );

  static const darkGradient = LinearGradient(
    colors: [Color(0xFF3B1049), Color(0xFF16051D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const matchGradient = darkGradient;

  static List<BoxShadow> get softShadow => [
        BoxShadow(color: aubergine.withValues(alpha: 0.10), blurRadius: 18, offset: const Offset(0, 8)),
        const BoxShadow(color: Colors.white, blurRadius: 10, offset: Offset(-4, -4)),
      ];

  static ThemeData get light {
    final base = ThemeData(useMaterial3: true);
    final scheme = ColorScheme.fromSeed(seedColor: magenta)
        .copyWith(primary: magenta, onPrimary: Colors.white, surface: cream);
    return base.copyWith(
      colorScheme: scheme,
      scaffoldBackgroundColor: cream,
      textTheme: GoogleFonts.outfitTextTheme(base.textTheme)
          .apply(bodyColor: aubergine, displayColor: aubergine),
    );
  }
}
