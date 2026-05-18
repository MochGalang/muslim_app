import 'package:flutter/material.dart';
import 'dart:async';
import 'main_screen.dart';
import '../theme/app_theme.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();

    // ⏳ delay 3 detik
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/icon.png',
              width: 150,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.mosque,
                  size: 100,
                  color: AppTheme.secondary,
                );
              },
            ),
            const SizedBox(height: 24),
            Text(
              'Muslim App',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: Colors.white,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Sanctuary in 2026',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.secondary,
                letterSpacing: 2.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
