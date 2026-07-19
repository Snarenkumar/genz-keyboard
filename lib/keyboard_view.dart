import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'languages/language_model.dart';
import 'language_switcher.dart';
import 'snippet_row.dart';
import 'theme.dart';

/// The main keyboard widget rendered inside the IME.
class KeyboardView extends StatefulWidget {
  final ValueChanged<String>? onTextInserted;
  final VoidCallback? onBackspace;
  final ValueChanged<int>? onMoveCursor;

  const KeyboardView({
    super.key,
    this.onTextInserted,
    this.onBackspace,
    this.onMoveCursor,
  });

  @override
  State<KeyboardView> createState() => _KeyboardViewState();
}

class _KeyboardViewState extends State<KeyboardView> {
  static const _channel = MethodChannel('com.codekeys/ime');

  late ProgrammingLanguage _currentLanguage;
  bool _isShift = false;
  bool _isCapsLock = false;
  bool _showSymbols = false;
  bool _showSymbolsPage2 = false;
  bool _isDark = true;
  bool _hapticEnabled = true;

  Timer? _backspaceTimer;

  // QWERTY layout rows
  static const _row1 = ['q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p'];
  static const _row2 = ['a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l'];
  static const _row3 = ['z', 'x', 'c', 'v', 'b', 'n', 'm'];

  // Symbol rows
  static const _symRow1 = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0'];
  static const _symRow2 = ['@', '#', '\$', '_', '&', '-', '+', '(', ')', '/'];
  static const _symRow3 = ['*', '"', '\'', ':', ';', '!', '?'];

  static const _sym2Row1 = ['~', '`', '|', '·', '√', 'π', '÷', '×', '¶', '∆'];
  static const _sym2Row2 = ['£', '€', '¥', '^', '°', '=', '{', '}', '\\', '%'];
  static const _sym2Row3 = ['©', '®', '™', '<', '>', '[', ']'];

  @override
  void initState() {
    super.initState();
    _currentLanguage = LanguageRegistry.languages.first;
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final langName = prefs.getString('selected_language') ?? 'C++';
      final isDark = prefs.getBool('is_dark_theme') ?? true;
      final haptic = prefs.getBool('haptic_enabled') ?? true;
      if (mounted) {
        setState(() {
          _currentLanguage = LanguageRegistry.getByName(langName);
          _isDark = isDark;
          _hapticEnabled = haptic;
        });
      }
    } catch (_) {
      // SharedPreferences may not be available in IME context; use defaults.
    }
  }

  Future<void> _saveLanguage(String name) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('selected_language', name);
    } catch (_) {}
  }

  KeyboardTheme get _theme => KeyboardTheme(isDark: _isDark);

  // --- Input methods ---

  void _insertText(String text) {
    if (_hapticEnabled) HapticFeedback.lightImpact();
    if (widget.onTextInserted != null) {
      widget.onTextInserted!(text);
    } else {
      _channel.invokeMethod('insertText', {'text': text});
    }
  }

  void _deleteBackward() {
    if (_hapticEnabled) HapticFeedback.lightImpact();
    if (widget.onBackspace != null) {
      widget.onBackspace!();
    } else {
      _channel.invokeMethod('deleteBackward', {'count': 1});
    }
  }

  void _sendEnter() {
    if (_hapticEnabled) HapticFeedback.mediumImpact();
    if (widget.onTextInserted != null) {
      widget.onTextInserted!('\n');
    } else {
      _channel.invokeMethod('sendKeyEvent', {'keyCode': 66}); // KEYCODE_ENTER
    }
  }

  void _onKeyTap(String key) {
    String text = key;
    if (_isShift || _isCapsLock) {
      text = key.toUpperCase();
    }
    _insertText(text);
    if (_isShift && !_isCapsLock) {
      setState(() => _isShift = false);
    }
  }

  void _onSnippetTap(Snippet snippet) {
    if (_hapticEnabled) HapticFeedback.mediumImpact();
    if (widget.onTextInserted != null) {
      widget.onTextInserted!(snippet.code);
      if (snippet.cursorOffset > 0 && widget.onMoveCursor != null) {
        widget.onMoveCursor!(-snippet.cursorOffset);
      }
    } else {
      _channel.invokeMethod('insertText', {'text': snippet.code});
      if (snippet.cursorOffset > 0) {
        _channel.invokeMethod('moveCursor', {'offset': -snippet.cursorOffset});
      }
    }
  }

  void _onShiftTap() {
    if (_hapticEnabled) HapticFeedback.lightImpact();
    setState(() {
      if (_isCapsLock) {
        _isCapsLock = false;
        _isShift = false;
      } else if (_isShift) {
        _isCapsLock = true;
      } else {
        _isShift = true;
      }
    });
  }

  void _startBackspaceRepeat() {
    _deleteBackward();
    _backspaceTimer = Timer.periodic(
      const Duration(milliseconds: 80),
      (_) => _deleteBackward(),
    );
  }

  void _stopBackspaceRepeat() {
    _backspaceTimer?.cancel();
    _backspaceTimer = null;
  }

  @override
  void dispose() {
    _backspaceTimer?.cancel();
    super.dispose();
  }

  // --- Build ---

  @override
  Widget build(BuildContext context) {
    final theme = _theme;
    return Material(
      color: theme.base,
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SnippetRow(
              language: _currentLanguage,
              onSnippetTap: _onSnippetTap,
              theme: theme,
            ),
            const SizedBox(height: 3),
            _showSymbols ? _buildSymbolRows(theme) : _buildQwertyRows(theme),
            _buildBottomRow(theme),
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }

  Widget _buildQwertyRows(KeyboardTheme theme) {
    return Column(
      children: [
        _buildKeyRow(_row1, theme),
        _buildKeyRow(_row2, theme, indent: true),
        _buildShiftRow(_row3, theme),
      ],
    );
  }

  Widget _buildSymbolRows(KeyboardTheme theme) {
    final r1 = _showSymbolsPage2 ? _sym2Row1 : _symRow1;
    final r2 = _showSymbolsPage2 ? _sym2Row2 : _symRow2;
    final r3 = _showSymbolsPage2 ? _sym2Row3 : _symRow3;
    return Column(
      children: [
        _buildKeyRow(r1, theme, isSymbol: true),
        _buildKeyRow(r2, theme, isSymbol: true),
        _buildSymbolShiftRow(r3, theme),
      ],
    );
  }

  Widget _buildKeyRow(
    List<String> keys,
    KeyboardTheme theme, {
    bool indent = false,
    bool isSymbol = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: indent ? 18 : 4,
        vertical: 2.5,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: keys
            .map(
              (key) => Expanded(
                child: _KeyButton(
                  label:
                      (!isSymbol && (_isShift || _isCapsLock))
                          ? key.toUpperCase()
                          : key,
                  onTap: () =>
                      isSymbol ? _insertText(key) : _onKeyTap(key),
                  theme: theme,
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildShiftRow(List<String> keys, KeyboardTheme theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2.5),
      child: Row(
        children: [
          // Shift key
          _SpecialKeyButton(
            icon:
                _isCapsLock
                    ? Icons.keyboard_capslock
                    : (_isShift
                        ? Icons.arrow_upward_rounded
                        : Icons.arrow_upward_outlined),
            isActive: _isShift || _isCapsLock,
            onTap: _onShiftTap,
            theme: theme,
            flex: 15,
          ),
          const SizedBox(width: 4),
          ...keys.map(
            (key) => Expanded(
              flex: 10,
              child: _KeyButton(
                label:
                    (_isShift || _isCapsLock) ? key.toUpperCase() : key,
                onTap: () => _onKeyTap(key),
                theme: theme,
              ),
            ),
          ),
          const SizedBox(width: 4),
          // Backspace key
          _SpecialKeyButton(
            icon: Icons.backspace_outlined,
            onTap: _deleteBackward,
            onLongPressStart: _startBackspaceRepeat,
            onLongPressEnd: _stopBackspaceRepeat,
            theme: theme,
            flex: 15,
          ),
        ],
      ),
    );
  }

  Widget _buildSymbolShiftRow(List<String> keys, KeyboardTheme theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2.5),
      child: Row(
        children: [
          // Toggle symbol page
          _SpecialKeyButton(
            label: _showSymbolsPage2 ? '1/2' : '2/2',
            onTap: () {
              if (_hapticEnabled) HapticFeedback.lightImpact();
              setState(() => _showSymbolsPage2 = !_showSymbolsPage2);
            },
            theme: theme,
            flex: 15,
          ),
          const SizedBox(width: 4),
          ...keys.map(
            (key) => Expanded(
              flex: 10,
              child: _KeyButton(
                label: key,
                onTap: () => _insertText(key),
                theme: theme,
              ),
            ),
          ),
          const SizedBox(width: 4),
          _SpecialKeyButton(
            icon: Icons.backspace_outlined,
            onTap: _deleteBackward,
            onLongPressStart: _startBackspaceRepeat,
            onLongPressEnd: _stopBackspaceRepeat,
            theme: theme,
            flex: 15,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomRow(KeyboardTheme theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2.5),
      child: Row(
        children: [
          // 123 / ABC toggle
          _SpecialKeyButton(
            label: _showSymbols ? 'ABC' : '123',
            onTap: () {
              if (_hapticEnabled) HapticFeedback.lightImpact();
              setState(() {
                _showSymbols = !_showSymbols;
                _showSymbolsPage2 = false;
              });
            },
            theme: theme,
            flex: 12,
          ),
          const SizedBox(width: 4),
          // Comma
          _KeyButton(
            label: ',',
            onTap: () => _insertText(','),
            theme: theme,
            width: 36,
          ),
          const SizedBox(width: 4),
          // Space bar
          Expanded(
            flex: 50,
            child: _SpaceBar(
              languageName: _currentLanguage.shortName,
              onTap: () => _insertText(' '),
              theme: theme,
            ),
          ),
          const SizedBox(width: 4),
          // Period
          _KeyButton(
            label: '.',
            onTap: () => _insertText('.'),
            theme: theme,
            width: 36,
          ),
          const SizedBox(width: 4),
          // Enter
          _SpecialKeyButton(
            icon: Icons.keyboard_return_rounded,
            onTap: _sendEnter,
            theme: theme,
            flex: 12,
            isEnter: true,
          ),
        ],
      ),
    );
  }
}

// ─── Individual Key Widgets ─────────────────────────────────────────────────

class _KeyButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  final KeyboardTheme theme;
  final double? width;

  const _KeyButton({
    required this.label,
    required this.onTap,
    required this.theme,
    this.width,
  });

  @override
  State<_KeyButton> createState() => _KeyButtonState();
}

class _KeyButtonState extends State<_KeyButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 60),
        width: widget.width,
        height: 52,
        margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          color: _pressed ? theme.keyPressed : theme.keyBg,
          borderRadius: BorderRadius.circular(8),
          boxShadow: _pressed ? [] : theme.keyShadow,
        ),
        alignment: Alignment.center,
        child: Text(
          widget.label,
          style: TextStyle(
            color: theme.text,
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

class _SpecialKeyButton extends StatefulWidget {
  final String? label;
  final IconData? icon;
  final VoidCallback onTap;
  final VoidCallback? onLongPressStart;
  final VoidCallback? onLongPressEnd;
  final KeyboardTheme theme;
  final int flex;
  final bool isActive;
  final bool isEnter;

  const _SpecialKeyButton({
    this.label,
    this.icon,
    required this.onTap,
    this.onLongPressStart,
    this.onLongPressEnd,
    required this.theme,
    this.flex = 10,
    this.isActive = false,
    this.isEnter = false,
  });

  @override
  State<_SpecialKeyButton> createState() => _SpecialKeyButtonState();
}

class _SpecialKeyButtonState extends State<_SpecialKeyButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    Color bg;
    if (widget.isEnter) {
      bg = _pressed ? theme.accent : theme.enterKey;
    } else if (widget.isActive) {
      bg = theme.accent.withValues(alpha: 0.3);
    } else {
      bg = _pressed ? theme.keyPressed : theme.specialKey;
    }

    return Expanded(
      flex: widget.flex,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) {
          setState(() => _pressed = false);
          widget.onTap();
        },
        onTapCancel: () => setState(() => _pressed = false),
        onLongPressStart:
            widget.onLongPressStart != null
                ? (_) {
                  setState(() => _pressed = true);
                  widget.onLongPressStart!();
                }
                : null,
        onLongPressEnd:
            widget.onLongPressEnd != null
                ? (_) {
                  setState(() => _pressed = false);
                  widget.onLongPressEnd!();
                }
                : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 60),
          height: 52,
          margin: const EdgeInsets.symmetric(horizontal: 1),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(8),
            boxShadow: _pressed ? [] : theme.keyShadow,
          ),
          alignment: Alignment.center,
          child:
              widget.icon != null
                  ? Icon(
                    widget.icon,
                    color: widget.isEnter ? Colors.white : theme.text,
                    size: 20,
                  )
                  : Text(
                    widget.label ?? '',
                    style: TextStyle(
                      color: theme.text,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
        ),
      ),
    );
  }
}

class _SpaceBar extends StatefulWidget {
  final String languageName;
  final VoidCallback onTap;
  final KeyboardTheme theme;

  const _SpaceBar({
    required this.languageName,
    required this.onTap,
    required this.theme,
  });

  @override
  State<_SpaceBar> createState() => _SpaceBarState();
}

class _SpaceBarState extends State<_SpaceBar> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 60),
        height: 52,
        margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          color: _pressed ? theme.keyPressed : theme.keyBg,
          borderRadius: BorderRadius.circular(8),
          boxShadow: _pressed ? [] : theme.keyShadow,
        ),
        alignment: Alignment.center,
        child: Text(
          widget.languageName,
          style: TextStyle(
            color: theme.subtext,
            fontSize: 12,
            fontWeight: FontWeight.w500,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
}
