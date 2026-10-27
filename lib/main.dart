import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'SignupScreen.dart';
import 'WelcomeScreen.dart';
import 'DestinationsScreen.dart';

void main() {
  runApp(const WanderlyApp());
}

class WanderlyApp extends StatefulWidget {
  const WanderlyApp({super.key});

  @override
  State<WanderlyApp> createState() => WanderlyAppState();
}

class WanderlyAppState extends State<WanderlyApp> {
  ThemeMode themeMode = ThemeMode.light;

  void toggleTheme() {
    setState(() {
      themeMode = themeMode == ThemeMode.light
          ? ThemeMode.dark
          : ThemeMode.light;
    });
  }

  late final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => MainStartScreen(onToggleTheme: toggleTheme),
        routes: [
          GoRoute(
            path: 'signup',
            builder: (context, state) => SignupScreen(onToggleTheme: toggleTheme),
          ),
          GoRoute(
            path: 'welcome',
            builder: (context, state) {
              final name = state.extra as String? ?? 'Explorer';
              return WelcomeScreen(name: name);
            },
          ),
          GoRoute(
            path: 'destinations',
            builder: (context, state) => const DestinationsScreen(),
          ),
        ],
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    const seedColor = Color(0xFF0F5A50);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Wanderly',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: seedColor,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: seedColor,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}

class MainStartScreen extends StatelessWidget {
  final VoidCallback onToggleTheme;

  const MainStartScreen({
    super.key,
    required this.onToggleTheme,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: theme.colorScheme.primary,
                  child: Icon(
                    Icons.explore,
                    size: 50,
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Wanderly',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Discover your next great adventure',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 48),

                ElevatedButton(
                  onPressed: () {
                    context.go('/signup');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Start Exploring',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                TextButton.icon(
                  onPressed: onToggleTheme,
                  icon: Icon(
                    isDark ? Icons.light_mode : Icons.dark_mode,
                    color: theme.colorScheme.primary,
                  ),
                  label: Text(
                    isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}