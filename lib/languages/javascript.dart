import 'language_model.dart';

const javascriptLanguage = ProgrammingLanguage(
  name: 'JavaScript',
  shortName: 'JS',
  icon: '🟨',
  snippets: [
    Snippet(label: 'log()', code: 'console.log()', cursorOffset: 1),
    Snippet(label: '=>', code: ' => ', cursorOffset: 0),
    Snippet(label: '===', code: ' === ', cursorOffset: 0),
    Snippet(
      label: 'async',
      code: 'async function () {\n    \n}',
      cursorOffset: 6,
    ),
    Snippet(label: 'const', code: 'const  = ', cursorOffset: 3),
    Snippet(label: 'let', code: 'let  = ', cursorOffset: 3),
    Snippet(
      label: 'querySelector',
      code: 'document.querySelector("")',
      cursorOffset: 2,
    ),
    Snippet(
      label: 'setTimeout',
      code: 'setTimeout(() => {\n    \n}, )',
      cursorOffset: 2,
    ),
    Snippet(
      label: 'function',
      code: 'function () {\n    \n}',
      cursorOffset: 6,
    ),
    Snippet(label: 'if', code: 'if () {\n    \n}', cursorOffset: 8),
    Snippet(
      label: 'for',
      code: 'for (let i = 0; i < n; i++) {\n    \n}',
      cursorOffset: 2,
    ),
    Snippet(label: '//', code: '// ', cursorOffset: 0),
    Snippet(label: '\${}', code: '\${}', cursorOffset: 1),
    Snippet(label: '...', code: '...', cursorOffset: 0),
    Snippet(label: 'await', code: 'await ', cursorOffset: 0),
    Snippet(label: 'import', code: "import {  } from '';", cursorOffset: 2),
    Snippet(label: 'export', code: 'export default ', cursorOffset: 0),
  ],
  symbols: ['{', '}', '[', ']', '(', ')', ';', ':', '\'', '"', '`', '=', '!', '/'],
);
