import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'features/workspace/infrastructure/workspace_repository.dart';
import 'core/router/app_router.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    final TextTheme textTheme = GoogleFonts.plusJakartaSansTextTheme();
    final TextTheme displayTheme = GoogleFonts.spaceGroteskTextTheme();

    // Merge Space Grotesk into headers, leave Plus Jakarta Sans for body
    final mergedTextTheme = textTheme.copyWith(
      displayLarge: displayTheme.displayLarge,
      displayMedium: displayTheme.displayMedium,
      displaySmall: displayTheme.displaySmall,
      headlineLarge: displayTheme.headlineLarge,
      headlineMedium: displayTheme.headlineMedium,
      headlineSmall: displayTheme.headlineSmall,
      titleLarge: displayTheme.titleLarge,
      titleMedium: displayTheme.titleMedium,
      titleSmall: displayTheme.titleSmall,
    );

    return MaterialApp.router(
      title: 'My Mind',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: const ColorScheme.light(
          primary: Color(0xFFD8683F),
          onPrimary: Color(0xFFFFF7ED),
          secondary: Color(0xFFB24E2B),
          background: Color(0xFFF5EFE3),
          surface: Color(0xFFFFFDF8),
          surfaceContainerLow: Color(0xFFFFFDF8),
          surfaceContainer: Color(0xFFFFFDF8),
          onSurface: Color(0xFF18242D),
          onSurfaceVariant: Color(0xFF56646D),
          outline: Color(0x1F10212B), // rgba(16, 33, 43, 0.12)
        ),
        scaffoldBackgroundColor: const Color(0xFFF5EFE3),
        textTheme: mergedTextTheme,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF5EFE3),
          foregroundColor: Color(0xFF18242D),
          elevation: 0,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFF08B63),
          onPrimary: Color(0xFF10181F),
          secondary: Color(0xFFF3C78B),
          background: Color(0xFF0E171E),
          surface: Color(0xFF142029),
          surfaceContainerLow: Color(0xFF14222C),
          surfaceContainer: Color(0xFF142029),
          onSurface: Color(0xFFEEF3F6),
          onSurfaceVariant: Color(0xFFA9B5BC),
          outline: Color(0x1FE8EFF4), // rgba(232, 239, 244, 0.12)
        ),
        scaffoldBackgroundColor: const Color(0xFF0E171E),
        textTheme: mergedTextTheme.apply(
          bodyColor: const Color(0xFFEEF3F6),
          displayColor: const Color(0xFFEEF3F6),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0E171E),
          foregroundColor: Color(0xFFEEF3F6),
          elevation: 0,
        ),
      ),
      routerConfig: router,
    );
  }
}
