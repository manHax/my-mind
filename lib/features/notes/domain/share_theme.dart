import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum ShareTheme {
  light(
    id: 'light',
    label: 'Warm Paper',
    icon: Icons.wb_sunny_outlined,
    brightness: Brightness.light,
    background: Color(0xFFF5EFE3),
    surface: Color(0xFFFFFDF8),
    surfaceVariant: Color(0xFFEDE4D3),
    primary: Color(0xFFD8683F),
    onSurface: Color(0xFF18242D),
    onSurfaceVariant: Color(0xFF56646D),
    outline: Color(0x2210212B),
  ),
  dark(
    id: 'dark',
    label: 'Midnight',
    icon: Icons.dark_mode_outlined,
    brightness: Brightness.dark,
    background: Color(0xFF0E171E),
    surface: Color(0xFF142029),
    surfaceVariant: Color(0xFF1C2C38),
    primary: Color(0xFFF08B63),
    onSurface: Color(0xFFE6EDF3),
    onSurfaceVariant: Color(0xFF9AA8B4),
    outline: Color(0x28E6EDF3),
  ),
  sepia(
    id: 'sepia',
    label: 'Sepia',
    icon: Icons.menu_book_outlined,
    brightness: Brightness.light,
    background: Color(0xFFF1E7D0),
    surface: Color(0xFFFAF3E3),
    surfaceVariant: Color(0xFFE6D8B8),
    primary: Color(0xFF9A4E1C),
    onSurface: Color(0xFF3B2E1E),
    onSurfaceVariant: Color(0xFF6E5B43),
    outline: Color(0x243B2E1E),
  ),
  matcha(
    id: 'matcha',
    label: 'Matcha',
    icon: Icons.eco_outlined,
    brightness: Brightness.light,
    background: Color(0xFFEAF1EB),
    surface: Color(0xFFF7FBF7),
    surfaceVariant: Color(0xFFDCE7DD),
    primary: Color(0xFF2D6A4F),
    onSurface: Color(0xFF1B2E22),
    onSurfaceVariant: Color(0xFF4E6656),
    outline: Color(0x221B2E22),
  ),
  ocean(
    id: 'ocean',
    label: 'Deep Ocean',
    icon: Icons.water_outlined,
    brightness: Brightness.dark,
    background: Color(0xFF091526),
    surface: Color(0xFF0F213B),
    surfaceVariant: Color(0xFF173054),
    primary: Color(0xFF5BC0BE),
    onSurface: Color(0xFFE2ECF5),
    onSurfaceVariant: Color(0xFF91A8C2),
    outline: Color(0x285BC0BE),
  );

  final String id;
  final String label;
  final IconData icon;
  final Brightness brightness;
  final Color background;
  final Color surface;
  final Color surfaceVariant;
  final Color primary;
  final Color onSurface;
  final Color onSurfaceVariant;
  final Color outline;

  const ShareTheme({
    required this.id,
    required this.label,
    required this.icon,
    required this.brightness,
    required this.background,
    required this.surface,
    required this.surfaceVariant,
    required this.primary,
    required this.onSurface,
    required this.onSurfaceVariant,
    required this.outline,
  });

  static ShareTheme? fromId(String? id) {
    if (id == null || id.trim().isEmpty) return null;
    final normalized = id.trim().toLowerCase();
    for (final theme in ShareTheme.values) {
      if (theme.id == normalized) return theme;
    }
    return null;
  }

  ThemeData toThemeData() {
    final baseTheme = brightness == Brightness.dark
        ? ThemeData.dark(useMaterial3: true)
        : ThemeData.light(useMaterial3: true);

    final bodyTheme = GoogleFonts.plusJakartaSansTextTheme(baseTheme.textTheme);
    final displayTheme = GoogleFonts.spaceGroteskTextTheme(baseTheme.textTheme);

    final mergedTextTheme = bodyTheme
        .copyWith(
          displayLarge: displayTheme.displayLarge,
          displayMedium: displayTheme.displayMedium,
          displaySmall: displayTheme.displaySmall,
          headlineLarge: displayTheme.headlineLarge,
          headlineMedium: displayTheme.headlineMedium,
          headlineSmall: displayTheme.headlineSmall,
          titleLarge: displayTheme.titleLarge,
          titleMedium: displayTheme.titleMedium,
          titleSmall: displayTheme.titleSmall,
        )
        .apply(
          bodyColor: onSurface,
          displayColor: onSurface,
        );

    final colorScheme = brightness == Brightness.dark
        ? ColorScheme.dark(
            primary: primary,
            onPrimary: background,
            surface: surface,
            surfaceContainerLow: surface,
            surfaceContainer: surfaceVariant,
            surfaceContainerHighest: surfaceVariant,
            onSurface: onSurface,
            onSurfaceVariant: onSurfaceVariant,
            outline: outline,
          )
        : ColorScheme.light(
            primary: primary,
            onPrimary: surface,
            surface: surface,
            surfaceContainerLow: surface,
            surfaceContainer: surfaceVariant,
            surfaceContainerHighest: surfaceVariant,
            onSurface: onSurface,
            onSurfaceVariant: onSurfaceVariant,
            outline: outline,
          );

    return baseTheme.copyWith(
      colorScheme: colorScheme,
      scaffoldBackgroundColor: background,
      textTheme: mergedTextTheme,
      dividerColor: outline,
    );
  }
}
