import 'language_model.dart';

const dartLanguage = ProgrammingLanguage(
  name: 'Dart',
  shortName: 'DART',
  icon: '🎯',
  snippets: [
    Snippet(label: 'print()', code: 'print()', cursorOffset: 1),
    Snippet(
      label: 'main()',
      code: 'void main() {\n  \n}',
      cursorOffset: 2,
    ),
    Snippet(
      label: 'setState',
      code: 'setState(() {\n  \n});',
      cursorOffset: 4,
    ),
    Snippet(label: 'Widget', code: 'Widget ', cursorOffset: 0),
    Snippet(label: 'async', code: 'async ', cursorOffset: 0),
    Snippet(label: 'await', code: 'await ', cursorOffset: 0),
    Snippet(label: '?.', code: '?.', cursorOffset: 0),
    Snippet(label: '??', code: ' ?? ', cursorOffset: 0),
    Snippet(label: 'final', code: 'final ', cursorOffset: 0),
    Snippet(label: 'var', code: 'var ', cursorOffset: 0),
    Snippet(label: '@override', code: '@override\n', cursorOffset: 0),
    Snippet(label: 'BuildContext', code: 'BuildContext ', cursorOffset: 0),
    Snippet(label: '=>', code: ' => ', cursorOffset: 0),
    Snippet(label: 'late', code: 'late ', cursorOffset: 0),
    Snippet(
      label: 'StatefulWidget',
      code:
          'class  extends StatefulWidget {\n  @override\n  State<> createState() => _State();\n}\n\nclass _State extends State<> {\n  @override\n  Widget build(BuildContext context) {\n    return Container();\n  }\n}',
      cursorOffset: 0,
    ),
    Snippet(label: 'const', code: 'const ', cursorOffset: 0),
    Snippet(label: '\${}', code: '\${}', cursorOffset: 1),
    Snippet(label: 'import', code: "import '';", cursorOffset: 2),
  ],
  symbols: ['{', '}', '[', ']', '(', ')', ';', ':', '<', '>', '@', '\"', '\'', '?', '.', ','],
);
