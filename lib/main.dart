import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'views/splash_view.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Muslim App',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system, // Support dark mode
      debugShowCheckedModeBanner: false,
      home: const SplashView(),
    );
  }
}
