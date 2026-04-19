import 'package:transactions/ui/core/themes/material_theme.dart';
import 'package:flutter/material.dart';

// Used https://material-foundation.github.io/material-theme-builder/
// to generate color scheme

abstract final class AppTheme {
  static ThemeData lightTheme = ThemeData(
    colorScheme: MaterialTheme.lightScheme(),
    inputDecorationTheme: InputDecorationTheme(),
  );
  static ThemeData darkTheme = ThemeData(
    colorScheme: MaterialTheme.darkScheme(),
    inputDecorationTheme: InputDecorationTheme(border: OutlineInputBorder()),
  );
}
