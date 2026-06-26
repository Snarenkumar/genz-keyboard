import 'package:flutter/material.dart';
import 'languages/language_model.dart';
import 'theme.dart';

/// Horizontal scrollable row of code snippet buttons.
class SnippetRow extends StatelessWidget {
  final ProgrammingLanguage language;
  final ValueChanged<Snippet> onSnippetTap;
  final KeyboardTheme theme;

  const SnippetRow({
    super.key,
    required this.language,
    required this.onSnippetTap,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38,
      decoration: BoxDecoration(
        color: theme.base,
        border: Border(
          bottom: BorderSide(color: theme.border.withValues(alpha: 0.3), width: 0.5),
        ),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        itemCount: language.snippets.length,
        itemBuilder: (context, index) {
          final snippet = language.snippets[index];
          return Padding(
            padding: const EdgeInsets.only(right: 5),
            child: _SnippetButton(
              snippet: snippet,
              onTap: () => onSnippetTap(snippet),
              theme: theme,
            ),
          );
        },
      ),
    );
  }
}

class _SnippetButton extends StatefulWidget {
  final Snippet snippet;
  final VoidCallback onTap;
  final KeyboardTheme theme;

  const _SnippetButton({
    required this.snippet,
    required this.onTap,
    required this.theme,
  });

  @override
  State<_SnippetButton> createState() => _SnippetButtonState();
}

class _SnippetButtonState extends State<_SnippetButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnim,
        builder: (context, child) {
          return Transform.scale(scale: _scaleAnim.value, child: child);
        },
        child: Tooltip(
          message: widget.snippet.code,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: theme.snippetBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: theme.snippetBorder, width: 1),
            ),
            child: Center(
              child: Text(
                widget.snippet.label,
                style: TextStyle(
                  color: theme.snippetText,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'monospace',
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
