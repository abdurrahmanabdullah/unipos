import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';
import 'app_sizes.dart';

class AppTheme {
  // Make [AppTheme] to be singleton
  static final AppTheme _instance = AppTheme._();

  factory AppTheme() => _instance;

  AppTheme._();

  Color _primaryColor = AppColors.orange;
  Color? _secondaryColor = AppColors.charcoal;
  Color? _tertiaryColor = AppColors.plum;
  Brightness _brightness = Brightness.light;
  TextTheme _primaryTextTheme = GoogleFonts.latoTextTheme();
  TextTheme _secondaryTextTheme = GoogleFonts.poppinsTextTheme();

  ThemeData init({
    Color? primaryColor,
    Color? secondaryColor,
    Color? tertiaryColor,
    Color? neutralColor,
    Brightness? brightness,
    TextTheme? primaryTextTheme,
    TextTheme? secondaryTextTheme,
  }) {
    _primaryColor = primaryColor ?? _primaryColor;
    _secondaryColor = secondaryColor ?? _secondaryColor;
    _tertiaryColor = tertiaryColor ?? _tertiaryColor;
    _brightness = brightness ?? _brightness;
    _primaryTextTheme = primaryTextTheme ?? _primaryTextTheme;
    _secondaryTextTheme = secondaryTextTheme ?? _secondaryTextTheme;

    return _base(
      colorScheme: ColorScheme.fromSeed(
        seedColor: _primaryColor,
        brightness: _brightness,
        primary: _primaryColor,
        secondary: _secondaryColor,
        tertiary: _tertiaryColor,
      ),
      brightness: _brightness,
      primaryTextTheme: _primaryTextTheme,
      secondaryTextTheme: _secondaryTextTheme,
    );
  }

  ThemeData _base({
    required ColorScheme colorScheme,
    required Brightness brightness,
    required TextTheme primaryTextTheme,
    required TextTheme secondaryTextTheme,
  }) {
    final textTheme = primaryTextTheme.copyWith(
      displaySmall: secondaryTextTheme.displaySmall,
      displayMedium: secondaryTextTheme.displayMedium,
      displayLarge: secondaryTextTheme.displayLarge,
      headlineSmall: secondaryTextTheme.headlineSmall,
      headlineMedium: secondaryTextTheme.headlineMedium,
      headlineLarge: secondaryTextTheme.headlineLarge,
    );

    final updatedColorScheme = colorScheme.copyWith(
      surfaceContainerLowest: brightness == Brightness.dark ? const Color(0xFF1F1D2B) : colorScheme.surfaceContainerLowest,
      surface: brightness == Brightness.dark ? const Color(0xFF252836) : colorScheme.surface,
      surfaceContainer: brightness == Brightness.dark ? const Color(0xFF2D303E) : colorScheme.surfaceContainer,
      primary: const Color(0xFFFF9F43), // The orange from the screenshot
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: updatedColorScheme,
      brightness: brightness,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      scaffoldBackgroundColor: updatedColorScheme.surfaceContainerLowest,
      textTheme: textTheme.apply(
        bodyColor: updatedColorScheme.onSurface,
        displayColor: updatedColorScheme.onSurface,
        decorationColor: updatedColorScheme.onSurface,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: updatedColorScheme.surfaceContainerLowest,
        shadowColor: updatedColorScheme.surfaceContainerHighest,
        elevation: 0.5,
        scrolledUnderElevation: 0.5,
        titleSpacing: AppSizes.padding,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: updatedColorScheme.onSurface,
        ),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: updatedColorScheme.onSurface,
        unselectedLabelColor: updatedColorScheme.onSurface,
        indicator: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: updatedColorScheme.primary, width: 2),
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: updatedColorScheme.secondaryContainer,
        foregroundColor: updatedColorScheme.onSecondaryContainer,
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: updatedColorScheme.surface,
        selectedIconTheme: IconThemeData(color: updatedColorScheme.onSecondaryContainer),
        indicatorColor: updatedColorScheme.secondaryContainer,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: updatedColorScheme.surface,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: updatedColorScheme.surfaceContainerLowest,
        selectedItemColor: updatedColorScheme.primary,
        unselectedItemColor: updatedColorScheme.outline,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold, fontSize: 10),
        unselectedLabelStyle: textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold, fontSize: 10),
      ),
      dividerTheme: DividerThemeData(
        color: updatedColorScheme.surfaceDim,
        thickness: 0.5,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: updatedColorScheme.primary,
        contentTextStyle: textTheme.labelSmall?.copyWith(
          color: updatedColorScheme.surface,
          fontWeight: FontWeight.w600,
        ),
        showCloseIcon: true,
        elevation: 1,
      ),
      dialogTheme: DialogThemeData(backgroundColor: updatedColorScheme.surfaceContainerLowest),
    );
  }
}
