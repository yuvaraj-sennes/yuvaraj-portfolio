import 'package:flutter/material.dart';
import 'screens/portfolio_screen.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const PortfolioApp());
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yuvaraj S — Flutter Developer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppTheme.background,
        colorScheme: const ColorScheme.dark(
          primary: AppTheme.primary,
          secondary: AppTheme.secondary,
          surface: AppTheme.surface,
        ),
        useMaterial3: true,
      ),
      home: const PortfolioScreen(),
    );
  }
}
