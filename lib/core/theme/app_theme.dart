import 'package:flutter/material.dart';

class AppTheme {
  static const purple = Color(0xFF38003C);
  static const violet = Color(0xFF7B2FF7);
  static const lilac = Color(0xFFEFE6FA);

  static const ink = Color(0xFF1A0020);

  /// Fondo del topbar: gris muy claro que se funde con el blanco.
  static const topBarGradient = LinearGradient(
    colors: [Color(0xFFEFEDF2), Colors.white],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  /// Fondo de la barra inferior flotante.
  static const navGradient = LinearGradient(
    colors: [Colors.white, Color(0xFFEDE7F6)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

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
