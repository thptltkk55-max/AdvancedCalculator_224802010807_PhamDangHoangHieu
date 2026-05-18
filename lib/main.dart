import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/calculator_provider.dart';
import 'providers/history_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/calculator_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AdvancedCalculatorApp());
}

class AdvancedCalculatorApp extends StatelessWidget {
  const AdvancedCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeProvider()..loadThemeMode(),
        ),
        ChangeNotifierProvider(
          create: (_) => CalculatorProvider()..loadSettings(),
        ),
        ChangeNotifierProvider(
          create: (_) => HistoryProvider()..loadHistory(),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Advanced Calculator',
            theme: themeProvider.lightTheme,
            darkTheme: themeProvider.darkTheme,
            themeMode: themeProvider.themeMode,
            home: const CalculatorScreen(),
          );
        },
      ),
    );
  }
}
