import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'keyboard_view.dart';
import 'setup_screen.dart';
import 'settings_screen.dart';
import 'theme.dart';

/// Entry point. Detects if running as IME or as main app.
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const CodeKeysApp());
}

class CodeKeysApp extends StatefulWidget {
  const CodeKeysApp({super.key});

  @override
  State<CodeKeysApp> createState() => _CodeKeysAppState();
}

class _CodeKeysAppState extends State<CodeKeysApp> {
  bool _isDark = true;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isDark = prefs.getBool('is_dark_theme') ?? true;
      if (mounted) setState(() => _isDark = isDark);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    // Check if we're being rendered as an IME keyboard view
    // The IME entrypoint uses a different route
    return MaterialApp(
      title: 'CodeKeys',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(isDark: _isDark),
      initialRoute: '/',
      routes: {
        '/': (context) => SetupScreen(
              onNavigateToSettings: () {
                Navigator.pushNamed(context, '/settings');
              },
            ),
        '/settings': (context) => const SettingsScreen(),
        '/keyboard': (context) => const KeyboardView(),
      },
    );
  }
}

/// Separate entry point for the IME keyboard service.
/// This is called from the native InputMethodService.
@pragma('vm:entry-point')
void keyboardMain() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const KeyboardApp());
}

class KeyboardApp extends StatefulWidget {
  const KeyboardApp({super.key});

  @override
  State<KeyboardApp> createState() => _KeyboardAppState();
}

class _KeyboardAppState extends State<KeyboardApp> {
  bool _isDark = true;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isDark = prefs.getBool('is_dark_theme') ?? true;
      if (mounted) setState(() => _isDark = isDark);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(isDark: _isDark),
      home: const KeyboardView(),
    );
  }
}
