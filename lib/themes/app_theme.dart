import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData get dark {
    const Color seed = Color(0xFF8B5CF6); // Morado suave
    const Color bg = Color(0xFF111217); // Negro suave
    const Color surface = Color(0xFF171923);

    final scheme =
        ColorScheme.fromSeed(
          seedColor: seed,
          brightness: Brightness.dark,
        ).copyWith(
          background: bg,
          surface: surface,
          surfaceTint: Colors.transparent,
        );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme,
      scaffoldBackgroundColor: bg,
      drawerTheme: DrawerThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(24),
            bottomRight: Radius.circular(24),
          ),
        ),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: scheme.onSurface,
        textColor: scheme.onSurface,
        selectedColor: scheme.primary,
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),

      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: scheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        hintStyle: TextStyle(color: scheme.onSurface.withOpacity(0.6)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: scheme.primary, width: 1.2),
        ),
      ),
    );
  }
}
