import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme.dart';

/// Setup / onboarding screen that guides users to enable CodeKeys.
class SetupScreen extends StatefulWidget {
  final VoidCallback onNavigateToSettings;

  const SetupScreen({super.key, required this.onNavigateToSettings});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  static const _imeSettingsChannel = MethodChannel('com.codekeys/app');

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _openInputMethodSettings() {
    try {
      _imeSettingsChannel.invokeMethod('openInputMethodSettings');
    } catch (_) {
      // Fallback: show instructions
    }
  }

  void _openInputMethodPicker() {
    try {
      _imeSettingsChannel.invokeMethod('openInputMethodPicker');
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = KeyboardTheme(isDark: isDark);

    return Scaffold(
      body: FadeTransition(
        opacity: _fadeAnim,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                // Logo / Header
                Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [theme.accent, theme.snippetText],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: theme.accent.withValues(alpha: 0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.keyboard_rounded,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    'CodeKeys',
                    style: TextStyle(
                      color: theme.text,
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Center(
                  child: Text(
                    'Programmer Keyboard',
                    style: TextStyle(
                      color: theme.subtext,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: theme.snippetBg,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: theme.snippetBorder),
                    ),
                    child: Text(
                      'C++ · Python · JS · Java · Dart',
                      style: TextStyle(
                        color: theme.snippetText,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 36),

                // Step 1
                _SetupStep(
                  step: 1,
                  title: 'Enable CodeKeys',
                  description:
                      'Open your device\'s keyboard settings and enable CodeKeys as an input method.',
                  buttonLabel: 'Open Keyboard Settings',
                  buttonIcon: Icons.settings_rounded,
                  onPressed: _openInputMethodSettings,
                  theme: theme,
                ),

                const SizedBox(height: 16),

                // Step 2
                _SetupStep(
                  step: 2,
                  title: 'Switch to CodeKeys',
                  description:
                      'When typing in any app, switch your active keyboard to CodeKeys.',
                  buttonLabel: 'Switch Keyboard',
                  buttonIcon: Icons.swap_horiz_rounded,
                  onPressed: _openInputMethodPicker,
                  theme: theme,
                ),

                const SizedBox(height: 16),

                // Step 3
                _SetupStep(
                  step: 3,
                  title: 'Configure & Code',
                  description:
                      'Set your default language, theme, and start coding anywhere!',
                  buttonLabel: 'Open Settings',
                  buttonIcon: Icons.tune_rounded,
                  onPressed: widget.onNavigateToSettings,
                  theme: theme,
                ),

                const SizedBox(height: 32),

                // Preview section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: theme.border.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.lightbulb_outline_rounded,
                            color: theme.accent,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Features',
                            style: TextStyle(
                              color: theme.text,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _FeatureRow(
                        icon: '⚡',
                        text: 'One-tap code snippets',
                        theme: theme,
                      ),
                      _FeatureRow(
                        icon: '🔄',
                        text: 'Quick language switching',
                        theme: theme,
                      ),
                      _FeatureRow(
                        icon: '🎨',
                        text: 'Dark & light code editor themes',
                        theme: theme,
                      ),
                      _FeatureRow(
                        icon: '📝',
                        text: 'Full QWERTY with programmer symbols',
                        theme: theme,
                      ),
                      _FeatureRow(
                        icon: '🌐',
                        text: 'Works in any app — WhatsApp, Chrome, etc.',
                        theme: theme,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Test area
                Text(
                  'Try it out:',
                  style: TextStyle(
                    color: theme.subtext,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  maxLines: 3,
                  style: TextStyle(
                    color: theme.text,
                    fontFamily: 'monospace',
                    fontSize: 14,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Tap here and start typing with CodeKeys...',
                    hintStyle: TextStyle(
                      color: theme.subtext.withValues(alpha: 0.5),
                    ),
                    filled: true,
                    fillColor: theme.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: theme.border.withValues(alpha: 0.3),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: theme.border.withValues(alpha: 0.3),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: theme.accent, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SetupStep extends StatelessWidget {
  final int step;
  final String title;
  final String description;
  final String buttonLabel;
  final IconData buttonIcon;
  final VoidCallback onPressed;
  final KeyboardTheme theme;

  const _SetupStep({
    required this.step,
    required this.title,
    required this.description,
    required this.buttonLabel,
    required this.buttonIcon,
    required this.onPressed,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.border.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step number badge
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [theme.accent, theme.accent.withValues(alpha: 0.7)],
              ),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              '$step',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: theme.text,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: theme.subtext,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 36,
                  child: ElevatedButton.icon(
                    onPressed: onPressed,
                    icon: Icon(buttonIcon, size: 16),
                    label: Text(
                      buttonLabel,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.accent.withValues(alpha: 0.15),
                      foregroundColor: theme.accent,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                          color: theme.accent.withValues(alpha: 0.3),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final String icon;
  final String text;
  final KeyboardTheme theme;

  const _FeatureRow({
    required this.icon,
    required this.text,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: theme.text,
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
