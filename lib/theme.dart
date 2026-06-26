import 'package:flutter/material.dart';

/// CodeKeys color palette — inspired by Catppuccin Mocha (dark) and Latte (light).
class CodeKeysColors {
  // Dark theme colors
  static const darkBase = Color(0xFF1E1E2E);
  static const darkSurface = Color(0xFF2D2D3F);
  static const darkOverlay = Color(0xFF363647);
  static const darkKeyBg = Color(0xFF3A3A4E);
  static const darkKeyPressed = Color(0xFF585B70);
  static const darkSpecialKey = Color(0xFF45475A);
  static const darkText = Color(0xFFCDD6F4);
  static const darkSubtext = Color(0xFFA6ADC8);
  static const darkAccent = Color(0xFF89B4FA);
  static const darkSnippetBg = Color(0xFF1A3A2A);
  static const darkSnippetText = Color(0xFFA6E3A1);
  static const darkSnippetBorder = Color(0xFF2D5A3D);
  static const darkBorder = Color(0xFF45475A);
  static const darkEnterKey = Color(0xFF89B4FA);
  static const darkRed = Color(0xFFF38BA8);

  // Light theme colors
  static const lightBase = Color(0xFFE6E9EF);
  static const lightSurface = Color(0xFFEFF1F5);
  static const lightOverlay = Color(0xFFDCE0E8);
  static const lightKeyBg = Color(0xFFFFFFFF);
  static const lightKeyPressed = Color(0xFFBCC0CC);
  static const lightSpecialKey = Color(0xFFCCD0DA);
  static const lightText = Color(0xFF4C4F69);
  static const lightSubtext = Color(0xFF6C6F85);
  static const lightAccent = Color(0xFF1E66F5);
  static const lightSnippetBg = Color(0xFFD4F0D4);
  static const lightSnippetText = Color(0xFF1A6B1A);
  static const lightSnippetBorder = Color(0xFF40A02B);
  static const lightBorder = Color(0xFFCCD0DA);
  static const lightEnterKey = Color(0xFF1E66F5);
  static const lightRed = Color(0xFFD20F39);
}

/// Provides theme-aware colors for the keyboard.
class KeyboardTheme {
  final bool isDark;

  const KeyboardTheme({this.isDark = true});

  Color get base => isDark ? CodeKeysColors.darkBase : CodeKeysColors.lightBase;
  Color get surface =>
      isDark ? CodeKeysColors.darkSurface : CodeKeysColors.lightSurface;
  Color get overlay =>
      isDark ? CodeKeysColors.darkOverlay : CodeKeysColors.lightOverlay;
  Color get keyBg =>
      isDark ? CodeKeysColors.darkKeyBg : CodeKeysColors.lightKeyBg;
  Color get keyPressed =>
      isDark ? CodeKeysColors.darkKeyPressed : CodeKeysColors.lightKeyPressed;
  Color get specialKey =>
      isDark ? CodeKeysColors.darkSpecialKey : CodeKeysColors.lightSpecialKey;
  Color get text => isDark ? CodeKeysColors.darkText : CodeKeysColors.lightText;
  Color get subtext =>
      isDark ? CodeKeysColors.darkSubtext : CodeKeysColors.lightSubtext;
  Color get accent =>
      isDark ? CodeKeysColors.darkAccent : CodeKeysColors.lightAccent;
  Color get snippetBg =>
      isDark ? CodeKeysColors.darkSnippetBg : CodeKeysColors.lightSnippetBg;
  Color get snippetText =>
      isDark ? CodeKeysColors.darkSnippetText : CodeKeysColors.lightSnippetText;
  Color get snippetBorder =>
      isDark
          ? CodeKeysColors.darkSnippetBorder
          : CodeKeysColors.lightSnippetBorder;
  Color get border =>
      isDark ? CodeKeysColors.darkBorder : CodeKeysColors.lightBorder;
  Color get enterKey =>
      isDark ? CodeKeysColors.darkEnterKey : CodeKeysColors.lightEnterKey;
  Color get red => isDark ? CodeKeysColors.darkRed : CodeKeysColors.lightRed;

  /// Shadow for keys.
  List<BoxShadow> get keyShadow => [
    BoxShadow(
      color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.1),
      offset: const Offset(0, 1),
      blurRadius: 1,
    ),
  ];
}

/// App-level MaterialApp themes.
ThemeData buildAppTheme({required bool isDark}) {
  final colors = KeyboardTheme(isDark: isDark);
  return ThemeData(
    brightness: isDark ? Brightness.dark : Brightness.light,
    scaffoldBackgroundColor: colors.base,
    primaryColor: colors.accent,
    colorScheme: ColorScheme(
      brightness: isDark ? Brightness.dark : Brightness.light,
      primary: colors.accent,
      onPrimary: isDark ? Colors.black : Colors.white,
      secondary: colors.snippetText,
      onSecondary: isDark ? Colors.black : Colors.white,
      error: colors.red,
      onError: Colors.white,
      surface: colors.surface,
      onSurface: colors.text,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: colors.surface,
      foregroundColor: colors.text,
      elevation: 0,
    ),
    cardTheme: CardThemeData(
      color: colors.surface,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return colors.accent;
        return colors.subtext;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return colors.accent.withValues(alpha: 0.4);
        }
        return colors.overlay;
      }),
    ),
    fontFamily: 'Roboto',
  );
}
