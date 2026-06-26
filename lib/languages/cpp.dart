import 'language_model.dart';

const cppLanguage = ProgrammingLanguage(
  name: 'C++',
  shortName: 'C++',
  icon: '⚙️',
  snippets: [
    Snippet(label: 'cout <<', code: 'cout << ', cursorOffset: 0),
    Snippet(label: 'cin >>', code: 'cin >> ', cursorOffset: 0),
    Snippet(label: 'endl', code: 'endl;', cursorOffset: 0),
    Snippet(label: '::', code: '::', cursorOffset: 0),
    Snippet(label: '->', code: '->', cursorOffset: 0),
    Snippet(label: '#include', code: '#include <>', cursorOffset: 1),
    Snippet(
      label: 'main()',
      code: 'int main() {\n    \n    return 0;\n}',
      cursorOffset: 18,
    ),
    Snippet(
      label: 'for',
      code: 'for (int i = 0; i < n; i++) {\n    \n}',
      cursorOffset: 2,
    ),
    Snippet(label: 'if', code: 'if () {\n    \n}', cursorOffset: 8),
    Snippet(
      label: 'class',
      code: 'class  {\npublic:\n    \n};',
      cursorOffset: 18,
    ),
    Snippet(label: 'nullptr', code: 'nullptr', cursorOffset: 0),
    Snippet(label: 'std::', code: 'std::', cursorOffset: 0),
    Snippet(label: 'vector', code: 'vector<>', cursorOffset: 1),
    Snippet(label: '//', code: '// ', cursorOffset: 0),
    Snippet(label: '/* */', code: '/*  */', cursorOffset: 3),
    Snippet(label: 'using', code: 'using namespace std;', cursorOffset: 0),
    Snippet(label: 'template', code: 'template <typename T>', cursorOffset: 0),
  ],
  symbols: ['{', '}', '[', ']', '(', ')', '<', '>', ';', ':', '#', '&', '*', '"'],
);
