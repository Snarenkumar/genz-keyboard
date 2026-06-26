import 'cpp.dart';
import 'python.dart';
import 'javascript.dart';
import 'java.dart';
import 'dart_lang.dart';

/// Represents a single code snippet that can be inserted with one tap.
class Snippet {
  final String label; // Shown on the button
  final String code; // Full text inserted
  final int cursorOffset; // Offset from end to place cursor (0 = end)

  const Snippet({
    required this.label,
    required this.code,
    this.cursorOffset = 0,
  });
}

/// Represents a programming language with its snippets and symbols.
class ProgrammingLanguage {
  final String name;
  final String shortName;
  final String icon; // Emoji icon
  final List<Snippet> snippets;
  final List<String> symbols;

  const ProgrammingLanguage({
    required this.name,
    required this.shortName,
    required this.icon,
    required this.snippets,
    this.symbols = const [],
  });
}

/// Static registry of all supported programming languages.
class LanguageRegistry {
  static final List<ProgrammingLanguage> languages = [
    cppLanguage,
    pythonLanguage,
    javascriptLanguage,
    javaLanguage,
    dartLanguage,
  ];

  static ProgrammingLanguage getByName(String name) {
    return languages.firstWhere(
      (lang) => lang.name == name,
      orElse: () => languages.first,
    );
  }

  static ProgrammingLanguage getByIndex(int index) {
    if (index < 0 || index >= languages.length) return languages.first;
    return languages[index];
  }
}
