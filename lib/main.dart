import 'package:flutter/material.dart';
import 'screens/categories_screen.dart';

void main() {
  runApp(const RecipesApp());
}

class RecipesApp extends StatelessWidget {
  const RecipesApp({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = ColorScheme.fromSeed(
      seedColor: const Color(0xFF0A7B68),
      brightness: Brightness.light,
    );

    return MaterialApp(
      title: 'Recipes App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: cs,
        useMaterial3: true,
        scaffoldBackgroundColor: cs.surface,
        appBarTheme: AppBarTheme(
          backgroundColor: cs.surfaceContainerHighest,
          foregroundColor: cs.onSurface,
          elevation: 0,
          titleTextStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
          iconTheme: IconThemeData(color: cs.primary),
        ),
        // важно. користи CardThemeData, не CardTheme
        cardTheme: CardThemeData(
          color: cs.surfaceContainerHigh,
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          clipBehavior: Clip.antiAlias,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: cs.surfaceContainerHigh,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
          prefixIconColor: cs.onSurfaceVariant,
        ),
        chipTheme: ChipThemeData(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor: cs.surfaceContainerHighest,
          labelStyle: TextStyle(color: cs.onSurface, fontWeight: FontWeight.w600),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontWeight: FontWeight.w800),
          titleMedium: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      home: const CategoriesScreen(),
    );
  }
}
