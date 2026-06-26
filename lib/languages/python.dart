import 'language_model.dart';

const pythonLanguage = ProgrammingLanguage(
  name: 'Python',
  shortName: 'PY',
  icon: '🐍',
  snippets: [
    Snippet(label: 'print()', code: 'print()', cursorOffset: 1),
    Snippet(label: 'def', code: 'def ():\n    ', cursorOffset: 7),
    Snippet(label: 'self.', code: 'self.', cursorOffset: 0),
    Snippet(label: 'import', code: 'import ', cursorOffset: 0),
    Snippet(
      label: '__name__',
      code: 'if __name__ == "__main__":\n    ',
      cursorOffset: 0,
    ),
    Snippet(
      label: 'for',
      code: 'for i in range():\n    ',
      cursorOffset: 6,
    ),
    Snippet(label: '->', code: ' -> ', cursorOffset: 0),
    Snippet(
      label: 'class',
      code: 'class :\n    def __init__(self):\n        ',
      cursorOffset: 0,
    ),
    Snippet(label: 'lambda', code: 'lambda : ', cursorOffset: 1),
    Snippet(
      label: 'try',
      code: 'try:\n    \nexcept Exception as e:\n    ',
      cursorOffset: 0,
    ),
    Snippet(
      label: 'with',
      code: 'with open("", "r") as f:\n    ',
      cursorOffset: 0,
    ),
    Snippet(label: '#', code: '# ', cursorOffset: 0),
    Snippet(label: '\"\"\"', code: '\"\"\"  \"\"\"', cursorOffset: 4),
    Snippet(label: 'from', code: 'from  import ', cursorOffset: 8),
    Snippet(label: 'return', code: 'return ', cursorOffset: 0),
    Snippet(label: 'None', code: 'None', cursorOffset: 0),
    Snippet(label: 'True', code: 'True', cursorOffset: 0),
  ],
  symbols: [':', '(', ')', '[', ']', '{', '}', '#', '\"', '\'', '_', '=', '@', ','],
);
