import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/app_theme.dart';
import 'screens/home_screen.dart';
import 'screens/explore_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/main_navigation.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const AppNavigator(),
    );
  }
}

class AppNavigator extends ConsumerWidget {
  const AppNavigator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTab = ref.watch(selectedTabProvider);

    final screens = [
      const HomeScreen(),
      const ExploreScreen(),
      const ProfileScreen(),
    ];

    return MainNavigation(child: screens[selectedTab]);
  }
}
