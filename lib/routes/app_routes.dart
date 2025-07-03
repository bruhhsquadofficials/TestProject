import 'package:flutter/material.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/settings_screen/settings_screen.dart';
import '../presentation/calculation_history_screen/calculation_history_screen.dart';
import '../presentation/calculator_main_screen/calculator_main_screen.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String splashScreen = '/splash-screen';
  static const String settingsScreen = '/settings-screen';
  static const String calculationHistoryScreen = '/calculation-history-screen';
  static const String calculatorMainScreen = '/calculator-main-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    splashScreen: (context) => const SplashScreen(),
    settingsScreen: (context) => const SettingsScreen(),
    calculationHistoryScreen: (context) => const CalculationHistoryScreen(),
    calculatorMainScreen: (context) => const CalculatorMainScreen(),
    // TODO: Add your other routes here
  };
}
