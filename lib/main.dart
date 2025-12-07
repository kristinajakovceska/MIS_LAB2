import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'screens/categories_screen.dart';
import 'screens/favorites_screen.dart';
import 'screens/meal_detail_screen.dart';
import 'services/favorites_provider.dart';
import 'services/favorites_service.dart';
import 'services/api_service.dart';
import 'notifications/notification_service.dart';
import 'notifications/fcm_service.dart';

final GlobalKey<NavigatorState> _navKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Init локални нотификации со tap handler
  await NotificationService.instance.init(
    onTap: (response) async {
      if (response.payload == 'random') {
        // Отвори „рандом рецепт“
        final meal = await ApiService.fetchRandomMeal();
        final ctx = _navKey.currentContext;
        if (ctx != null) {
          Navigator.of(ctx).push(
            MaterialPageRoute(
              builder: (_) => MealDetailScreen(mealId: meal.id, preload: meal),
            ),
          );
        }
      }
    },
  );

  // Init FCM
  await FcmService.instance.init();

  // Пример: закажи дневна нотификација во 20:00 локално
  await NotificationService.instance.scheduleDailyAt(
    time: const TimeOfDay(hour: 20, minute: 0),
    title: 'Recipe of the day',
    body: 'Tap to see a random recipe',
    payload: 'random',
  );

  runApp(
    ChangeNotifierProvider(
      create: (_) => FavoritesProvider(FavoritesService())..load(),
      child: const RecipesApp(),
    ),
  );
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
      navigatorKey: _navKey,
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
          titleTextStyle: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
          iconTheme: IconThemeData(color: cs.primary),
        ),
        cardTheme: CardThemeData(
          color: cs.surfaceContainerHigh,
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          clipBehavior: Clip.antiAlias,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: cs.surfaceContainerHigh,
          isDense: true,
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          prefixIconColor: cs.onSurfaceVariant,
        ),
        chipTheme: ChipThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: cs.surfaceContainerHighest,
          labelStyle: TextStyle(
            color: cs.onSurface,
            fontWeight: FontWeight.w600,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontWeight: FontWeight.w800),
          titleMedium: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      home: const CategoriesScreen(),
      routes: {
        '/favorites': (_) => const FavoritesScreen(),
      },
    );
  }
}
