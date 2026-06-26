import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'languages/language_model.dart';
import 'theme.dart';

/// Settings screen for configuring the keyboard.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _selectedLanguage = 'C++';
  bool _isDark = true;
  bool _hapticEnabled = true;
  bool _soundEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedLanguage = prefs.getString('selected_language') ?? 'C++';
      _isDark = prefs.getBool('is_dark_theme') ?? true;
      _hapticEnabled = prefs.getBool('haptic_enabled') ?? true;
      _soundEnabled = prefs.getBool('sound_enabled') ?? false;
    });
  }

  Future<void> _savePref(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is String) {
      await prefs.setString(key, value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = KeyboardTheme(isDark: _isDark);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [theme.accent, theme.snippetText],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.settings_rounded, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 10),
            const Text(
              'Settings',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Default Language
          _SectionHeader(title: 'KEYBOARD', theme: theme),
          const SizedBox(height: 8),
          _SettingsCard(
            theme: theme,
            children: [
              _DropdownTile(
                icon: Icons.code_rounded,
                title: 'Default Language',
                subtitle: 'Language shown when keyboard opens',
                value: _selectedLanguage,
                items: LanguageRegistry.languages
                    .map((l) => DropdownMenuItem(
                          value: l.name,
                          child: Text(
                            '${l.icon} ${l.name}',
                            style: TextStyle(color: colorScheme.onSurface),
                          ),
                        ))
                    .toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _selectedLanguage = val);
                    _savePref('selected_language', val);
                  }
                },
                theme: theme,
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Appearance
          _SectionHeader(title: 'APPEARANCE', theme: theme),
          const SizedBox(height: 8),
          _SettingsCard(
            theme: theme,
            children: [
              _SwitchTile(
                icon: Icons.dark_mode_rounded,
                title: 'Dark Theme',
                subtitle: 'Code editor dark mode',
                value: _isDark,
                onChanged: (val) {
                  setState(() => _isDark = val);
                  _savePref('is_dark_theme', val);
                },
                theme: theme,
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Feedback
          _SectionHeader(title: 'FEEDBACK', theme: theme),
          const SizedBox(height: 8),
          _SettingsCard(
            theme: theme,
            children: [
              _SwitchTile(
                icon: Icons.vibration_rounded,
                title: 'Haptic Feedback',
                subtitle: 'Vibrate on key press',
                value: _hapticEnabled,
                onChanged: (val) {
                  setState(() => _hapticEnabled = val);
                  _savePref('haptic_enabled', val);
                  if (val) HapticFeedback.lightImpact();
                },
                theme: theme,
              ),
              Divider(height: 1, color: theme.border.withValues(alpha: 0.2)),
              _SwitchTile(
                icon: Icons.volume_up_rounded,
                title: 'Sound Feedback',
                subtitle: 'Click sound on key press',
                value: _soundEnabled,
                onChanged: (val) {
                  setState(() => _soundEnabled = val);
                  _savePref('sound_enabled', val);
                },
                theme: theme,
              ),
            ],
          ),

          const SizedBox(height: 20),

          // About
          _SectionHeader(title: 'ABOUT', theme: theme),
          const SizedBox(height: 8),
          _SettingsCard(
            theme: theme,
            children: [
              _InfoTile(
                icon: Icons.info_outline_rounded,
                title: 'Version',
                trailing: '1.0.0',
                theme: theme,
              ),
              Divider(height: 1, color: theme.border.withValues(alpha: 0.2)),
              _InfoTile(
                icon: Icons.keyboard_rounded,
                title: 'CodeKeys',
                trailing: 'Programmer Keyboard',
                theme: theme,
              ),
            ],
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

// ─── Helper Widgets ───────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  final KeyboardTheme theme;
  const _SectionHeader({required this.title, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: TextStyle(
          color: theme.accent,
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final KeyboardTheme theme;
  final List<Widget> children;
  const _SettingsCard({required this.theme, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.border.withValues(alpha: 0.2)),
      ),
      child: Column(children: children),
    );
  }
}

class _SwitchTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final KeyboardTheme theme;

  const _SwitchTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: theme.accent, size: 22),
      title: Text(
        title,
        style: TextStyle(
          color: theme.text,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: theme.subtext, fontSize: 12),
      ),
      trailing: Switch(value: value, onChanged: onChanged),
    );
  }
}

class _DropdownTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String value;
  final List<DropdownMenuItem<String>> items;
  final ValueChanged<String?> onChanged;
  final KeyboardTheme theme;

  const _DropdownTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: theme.accent, size: 22),
      title: Text(
        title,
        style: TextStyle(
          color: theme.text,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: theme.subtext, fontSize: 12),
      ),
      trailing: DropdownButton<String>(
        value: value,
        items: items,
        onChanged: onChanged,
        underline: const SizedBox(),
        dropdownColor: theme.surface,
        style: TextStyle(color: theme.text, fontSize: 14),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String trailing;
  final KeyboardTheme theme;

  const _InfoTile({
    required this.icon,
    required this.title,
    required this.trailing,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: theme.accent, size: 22),
      title: Text(
        title,
        style: TextStyle(
          color: theme.text,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Text(
        trailing,
        style: TextStyle(color: theme.subtext, fontSize: 13),
      ),
    );
  }
}
