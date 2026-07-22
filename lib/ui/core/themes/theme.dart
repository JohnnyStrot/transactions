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

  static final List<Color> pieChartColors = [
    for (var i = 0.0; i <= 1.0; i += 0.1)
      HSVColor.lerp(
        HSVColor.fromColor(MaterialTheme.darkScheme().primaryContainer),
        HSVColor.fromColor(MaterialTheme.darkScheme().secondary),
        i,
      )!.toColor(),
  ];
}
