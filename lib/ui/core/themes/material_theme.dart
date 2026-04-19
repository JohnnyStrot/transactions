import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff8d4a5a),
      surfaceTint: Color(0xff8d4a5a),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffffd9df),
      onPrimaryContainer: Color(0xff713343),
      secondary: Color(0xff75565c),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffffd9df),
      onSecondaryContainer: Color(0xff5b3f45),
      tertiary: Color(0xff7a5733),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffffdcbd),
      onTertiaryContainer: Color(0xff60401d),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff93000a),
      surface: Color(0xfffff8f7),
      onSurface: Color(0xff22191b),
      onSurfaceVariant: Color(0xff524346),
      outline: Color(0xff847375),
      outlineVariant: Color(0xffd6c2c4),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff382e30),
      inversePrimary: Color(0xffffb1c2),
      primaryFixed: Color(0xffffd9df),
      onPrimaryFixed: Color(0xff3a0718),
      primaryFixedDim: Color(0xffffb1c2),
      onPrimaryFixedVariant: Color(0xff713343),
      secondaryFixed: Color(0xffffd9df),
      onSecondaryFixed: Color(0xff2b151a),
      secondaryFixedDim: Color(0xffe4bdc3),
      onSecondaryFixedVariant: Color(0xff5b3f45),
      tertiaryFixed: Color(0xffffdcbd),
      onTertiaryFixed: Color(0xff2c1600),
      tertiaryFixedDim: Color(0xffecbe91),
      onTertiaryFixedVariant: Color(0xff60401d),
      surfaceDim: Color(0xffe7d6d8),
      surfaceBright: Color(0xfffff8f7),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfffff0f1),
      surfaceContainer: Color(0xfffbeaec),
      surfaceContainerHigh: Color(0xfff5e4e6),
      surfaceContainerHighest: Color(0xffefdee0),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff5c2233),
      surfaceTint: Color(0xff8d4a5a),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff9e5869),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff492f34),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff85656b),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff4d300e),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff8b6640),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff740006),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffcf2c27),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffff8f7),
      onSurface: Color(0xff170f11),
      onSurfaceVariant: Color(0xff403335),
      outline: Color(0xff5e4f51),
      outlineVariant: Color(0xff79696c),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff382e30),
      inversePrimary: Color(0xffffb1c2),
      primaryFixed: Color(0xff9e5869),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff824051),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff85656b),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff6b4d53),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff8b6640),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff704e2a),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffd3c3c4),
      surfaceBright: Color(0xfffff8f7),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfffff0f1),
      surfaceContainer: Color(0xfff5e4e6),
      surfaceContainerHigh: Color(0xffead9db),
      surfaceContainerHighest: Color(0xffdeced0),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff501829),
      surfaceTint: Color(0xff8d4a5a),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff743545),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff3e252b),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff5e4147),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff412605),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff634220),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff600004),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff98000a),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffff8f7),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff000000),
      outline: Color(0xff36292b),
      outlineVariant: Color(0xff544548),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff382e30),
      inversePrimary: Color(0xffffb1c2),
      primaryFixed: Color(0xff743545),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff581f2f),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff5e4147),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff452b31),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff634220),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff492c0b),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffc4b5b7),
      surfaceBright: Color(0xfffff8f7),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfffeedee),
      surfaceContainer: Color(0xffefdee0),
      surfaceContainerHigh: Color(0xffe1d0d2),
      surfaceContainerHighest: Color(0xffd3c3c4),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffffb1c2),
      surfaceTint: Color(0xffffb1c2),
      onPrimary: Color(0xff551d2d),
      primaryContainer: Color(0xff713343),
      onPrimaryContainer: Color(0xffffd9df),
      secondary: Color(0xffe4bdc3),
      onSecondary: Color(0xff43292f),
      secondaryContainer: Color(0xff5b3f45),
      onSecondaryContainer: Color(0xffffd9df),
      tertiary: Color(0xffecbe91),
      onTertiary: Color(0xff462a09),
      tertiaryContainer: Color(0xff60401d),
      onTertiaryContainer: Color(0xffffdcbd),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff303030),
      onSurface: Color(0xffefdee0),
      onSurfaceVariant: Color(0xffd6c2c4),
      outline: Color(0xff9e8c8f),
      outlineVariant: Color(0xff524346),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffefdee0),
      inversePrimary: Color(0xff8d4a5a),
      primaryFixed: Color(0xffffd9df),
      onPrimaryFixed: Color(0xff3a0718),
      primaryFixedDim: Color(0xffffb1c2),
      onPrimaryFixedVariant: Color(0xff713343),
      secondaryFixed: Color(0xffffd9df),
      onSecondaryFixed: Color(0xff2b151a),
      secondaryFixedDim: Color(0xffe4bdc3),
      onSecondaryFixedVariant: Color(0xff5b3f45),
      tertiaryFixed: Color(0xffffdcbd),
      onTertiaryFixed: Color(0xff2c1600),
      tertiaryFixedDim: Color(0xffecbe91),
      onTertiaryFixedVariant: Color(0xff60401d),
      surfaceDim: Color(0xff202020),
      surfaceBright: Color(0xff414141),
      surfaceContainerLowest: Color(0xff282828),
      surfaceContainerLow: Color(0xff2c2c2c),
      surfaceContainer: Color(0xff303030),
      surfaceContainerHigh: Color(0xff333333),
      surfaceContainerHighest: Color(0xff373737),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffffd1d9),
      surfaceTint: Color(0xffffb1c2),
      onPrimary: Color(0xff481222),
      primaryContainer: Color(0xffc87a8c),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xfffbd2d9),
      onSecondary: Color(0xff371f24),
      secondaryContainer: Color(0xffab888e),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xffffd5ad),
      onTertiary: Color(0xff3a2002),
      tertiaryContainer: Color(0xffb28960),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffd2cc),
      onError: Color(0xff540003),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff191113),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffedd7da),
      outline: Color(0xffc1adb0),
      outlineVariant: Color(0xff9e8c8e),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffefdee0),
      inversePrimary: Color(0xff723444),
      primaryFixed: Color(0xffffd9df),
      onPrimaryFixed: Color(0xff2c000e),
      primaryFixedDim: Color(0xffffb1c2),
      onPrimaryFixedVariant: Color(0xff5c2233),
      secondaryFixed: Color(0xffffd9df),
      onSecondaryFixed: Color(0xff1f0b10),
      secondaryFixedDim: Color(0xffe4bdc3),
      onSecondaryFixedVariant: Color(0xff492f34),
      tertiaryFixed: Color(0xffffdcbd),
      onTertiaryFixed: Color(0xff1e0d00),
      tertiaryFixedDim: Color(0xffecbe91),
      onTertiaryFixedVariant: Color(0xff4d300e),
      surfaceDim: Color(0xff191113),
      surfaceBright: Color(0xff4d4243),
      surfaceContainerLowest: Color(0xff0c0607),
      surfaceContainerLow: Color(0xff241b1d),
      surfaceContainer: Color(0xff2f2527),
      surfaceContainerHigh: Color(0xff3a3032),
      surfaceContainerHighest: Color(0xff463b3d),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffffebee),
      surfaceTint: Color(0xffffb1c2),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xffffabbd),
      onPrimaryContainer: Color(0xff210009),
      secondary: Color(0xffffebee),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffe0b9c0),
      onSecondaryContainer: Color(0xff18060a),
      tertiary: Color(0xffffedde),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xffe8ba8d),
      onTertiaryContainer: Color(0xff150800),
      error: Color(0xffffece9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffaea4),
      onErrorContainer: Color(0xff220001),
      surface: Color(0xff191113),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffffffff),
      outline: Color(0xffffebee),
      outlineVariant: Color(0xffd2bec0),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffefdee0),
      inversePrimary: Color(0xff723444),
      primaryFixed: Color(0xffffd9df),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xffffb1c2),
      onPrimaryFixedVariant: Color(0xff2c000e),
      secondaryFixed: Color(0xffffd9df),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffe4bdc3),
      onSecondaryFixedVariant: Color(0xff1f0b10),
      tertiaryFixed: Color(0xffffdcbd),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffecbe91),
      onTertiaryFixedVariant: Color(0xff1e0d00),
      surfaceDim: Color(0xff191113),
      surfaceBright: Color(0xff594d4f),
      surfaceContainerLowest: Color(0xff000000),
      surfaceContainerLow: Color(0xff261d1f),
      surfaceContainer: Color(0xff382e30),
      surfaceContainerHigh: Color(0xff43393a),
      surfaceContainerHighest: Color(0xff4f4446),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
    useMaterial3: true,
    brightness: colorScheme.brightness,
    colorScheme: colorScheme,
    textTheme: textTheme.apply(
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
    ),
    scaffoldBackgroundColor: colorScheme.background,
    canvasColor: colorScheme.surface,
  );

  List<ExtendedColor> get extendedColors => [];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
