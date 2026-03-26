import 'package:flutter/material.dart';

/// Sistema de design do GuinchoApp.
/// Paleta: azul-marinho profundo + âmbar quente.
class AppTheme {
  AppTheme._();

  // ─── Paleta ───────────────────────────────────────────
  static const _primary = Color(0xFF1A2B4A);
  static const _primaryContainer = Color(0xFF2E4A7A);
  static const _secondary = Color(0xFFF4A727);
  static const _onSecondary = Color(0xFF1A1A1A);
  static const _secondaryContainer = Color(0xFFFFF3D6);
  static const _surface = Color(0xFFF8F9FC);
  static const _onSurface = Color(0xFF1C1C1E);
  static const _error = Color(0xFFD32F2F);
  static const _outline = Color(0xFFC4C8D0);
  static const _fillColor = Color(0xFFF0F2F8);
  static const _dividerColor = Color(0xFFE8EAED);

  // ─── Tipografia ───────────────────────────────────────
  static const _textTheme = TextTheme(
    displayLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.5,
    ),
    headlineMedium: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w700,
    ),
    headlineSmall: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
    titleLarge: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.5,
    ),
  );

  // ─── Tema Light ───────────────────────────────────────
  static ThemeData light() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _primary,
      primary: _primary,
      onPrimary: Colors.white,
      primaryContainer: _primaryContainer,
      secondary: _secondary,
      onSecondary: _onSecondary,
      secondaryContainer: _secondaryContainer,
      surface: _surface,
      onSurface: _onSurface,
      error: _error,
      outline: _outline,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: _surface,
      textTheme: _textTheme,

      // AppBar
      appBarTheme: const AppBarTheme(
        backgroundColor: _primary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),

      // Card
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: Colors.white,
        surfaceTintColor: Colors.transparent,
        margin: EdgeInsets.zero,
      ),

      // ElevatedButton
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: _textTheme.labelLarge,
        ),
      ),

      // OutlinedButton
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _primary,
          side: const BorderSide(color: _primary, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        ),
      ),

      // InputDecoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _fillColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _error, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _error, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),

      // SnackBar
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),

      // FAB
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: _secondary,
        foregroundColor: _onSecondary,
      ),

      // Divider
      dividerTheme: const DividerThemeData(
        color: _dividerColor,
        thickness: 1,
        space: 0,
      ),
    );
  }

  // ─── Cores de Status (reutilizáveis) ──────────────────
  static const statusColors = {
    'rascunho': (Color(0xFFE3F2FD), Color(0xFF0D47A1)),
    'emDeslocamento': (Color(0xFFFFF8E1), Color(0xFFF57F17)),
    'emColeta': (Color(0xFFE8F5E9), Color(0xFF2E7D32)),
    'emEntrega': (Color(0xFFF3E5F5), Color(0xFF6A1B9A)),
    'retornando': (Color(0xFFFFF3E0), Color(0xFFE65100)),
    'concluido': (Color(0xFFE8F5E9), Color(0xFF1B5E20)),
    'cancelado': (Color(0xFFFFEBEE), Color(0xFFB71C1C)),
  };
}
