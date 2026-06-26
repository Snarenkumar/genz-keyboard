import 'language_model.dart';

const javaLanguage = ProgrammingLanguage(
  name: 'Java',
  shortName: 'JAVA',
  icon: '☕',
  snippets: [
    Snippet(
      label: 'sout',
      code: 'System.out.println()',
      cursorOffset: 1,
    ),
    Snippet(
      label: 'main()',
      code: 'public static void main(String[] args) {\n    \n}',
      cursorOffset: 2,
    ),
    Snippet(label: '@Override', code: '@Override\n', cursorOffset: 0),
    Snippet(label: 'new', code: 'new ', cursorOffset: 0),
    Snippet(label: 'instanceof', code: ' instanceof ', cursorOffset: 0),
    Snippet(
      label: 'try/catch',
      code: 'try {\n    \n} catch (Exception e) {\n    \n}',
      cursorOffset: 0,
    ),
    Snippet(
      label: 'class',
      code: 'public class  {\n    \n}',
      cursorOffset: 6,
    ),
    Snippet(label: 'import', code: 'import ;', cursorOffset: 1),
    Snippet(label: 'private', code: 'private ', cursorOffset: 0),
    Snippet(label: 'public', code: 'public ', cursorOffset: 0),
    Snippet(label: 'void', code: 'void ', cursorOffset: 0),
    Snippet(label: 'final', code: 'final ', cursorOffset: 0),
    Snippet(label: 'static', code: 'static ', cursorOffset: 0),
    Snippet(label: 'return', code: 'return ;', cursorOffset: 1),
    Snippet(
      label: 'for',
      code: 'for (int i = 0; i < n; i++) {\n    \n}',
      cursorOffset: 2,
    ),
    Snippet(label: 'null', code: 'null', cursorOffset: 0),
    Snippet(label: 'this.', code: 'this.', cursorOffset: 0),
  ],
  symbols: ['{', '}', '[', ']', '(', ')', ';', ':', '<', '>', '@', '\"', '.', ','],
);
