import 'package:flutter/material.dart';
import 'languages/language_model.dart';
import 'theme.dart';

/// Horizontal scrollable language switcher bar.
class LanguageSwitcher extends StatelessWidget {
  final ProgrammingLanguage selectedLanguage;
  final ValueChanged<ProgrammingLanguage> onLanguageChanged;
  final KeyboardTheme theme;

  const LanguageSwitcher({
    super.key,
    required this.selectedLanguage,
    required this.onLanguageChanged,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: theme.base,
        border: Border(
          bottom: BorderSide(color: theme.border.withValues(alpha: 0.3), width: 0.5),
        ),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        itemCount: LanguageRegistry.languages.length,
        itemBuilder: (context, index) {
          final lang = LanguageRegistry.languages[index];
          final isSelected = lang.name == selectedLanguage.name;
          return Padding(
            padding: const EdgeInsets.only(right: 6),
            child: GestureDetector(
              onTap: () => onLanguageChanged(lang),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: isSelected
                      ? theme.accent.withValues(alpha: 0.2)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isSelected
                        ? theme.accent
                        : theme.border.withValues(alpha: 0.3),
                    width: isSelected ? 1.5 : 0.5,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      lang.icon,
                      style: const TextStyle(fontSize: 12),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      lang.shortName,
                      style: TextStyle(
                        color: isSelected ? theme.accent : theme.subtext,
                        fontSize: 11,
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.w500,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
