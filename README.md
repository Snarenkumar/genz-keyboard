# CodeKeys ⌨️

**A programmer's keyboard for Android** — built with Flutter and Kotlin. Install it as a real system keyboard and use language-specific code snippets, symbols, and shortcuts in any app.

![Dart](https://img.shields.io/badge/Dart-0175C2?style=flat&logo=dart&logoColor=white)
![Flutter](https://img.shields.io/badge/Flutter-02569B?style=flat&logo=flutter&logoColor=white)
![Kotlin](https://img.shields.io/badge/Kotlin-7F52FF?style=flat&logo=kotlin&logoColor=white)
![Android](https://img.shields.io/badge/Android-3DDC84?style=flat&logo=android&logoColor=white)

---

## ✨ Features

- 🔤 **Full QWERTY keyboard** with shift, caps lock, symbols (2 pages)
- ⚡ **One-tap code snippets** — tap `for` to insert a full for-loop template
- 🔄 **Language switcher** — switch between C++, Python, JavaScript, Java, and Dart
- 🎨 **Dark & Light themes** — code-editor aesthetic (Catppuccin-inspired)
- 📱 **Real system keyboard (IME)** — works in WhatsApp, Chrome, any app
- 💾 **Persistent settings** — saves your preferred language and theme
- 📳 **Haptic feedback** — optional vibration on key press
- ⌫ **Hold-to-repeat backspace** — natural delete experience

## 🗣️ Supported Languages

| Language   | Snippets Include                                          |
|------------|----------------------------------------------------------|
| **C++**    | `cout <<`, `cin >>`, `#include`, `int main(){}`, `for`, `class`, `vector<>`, `std::` |
| **Python** | `print()`, `def`, `for i in range()`, `if __name__`, `try/except`, `lambda`, `class` |
| **JavaScript** | `console.log()`, `=>`, `===`, `async`, `const`, `querySelector`, `setTimeout` |
| **Java**   | `System.out.println()`, `public static void main`, `@Override`, `try/catch`, `class` |
| **Dart**   | `print()`, `void main(){}`, `setState()`, `Widget`, `async/await`, `?.`, `??`, `StatefulWidget` |

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────┐
│                  CodeKeys App                        │
├─────────────┬───────────────────────────────────────┤
│  Main App   │         IME Service                    │
│  (Activity) │    (InputMethodService)                │
│             │                                        │
│  Setup      │  ┌──────────────────────────────────┐  │
│  Screen     │  │     Flutter Keyboard UI           │  │
│             │  │  ┌────────────────────────────┐   │  │
│  Settings   │  │  │   Language Switcher Bar    │   │  │
│  Screen     │  │  ├────────────────────────────┤   │  │
│             │  │  │   Snippet Row (scrollable) │   │  │
│             │  │  ├────────────────────────────┤   │  │
│             │  │  │   QWERTY Keys / Symbols    │   │  │
│             │  │  ├────────────────────────────┤   │  │
│             │  │  │   Space / Enter / Special  │   │  │
│             │  │  └────────────────────────────┘   │  │
│             │  └──────────┬───────────────────────┘  │
│             │             │ MethodChannel             │
│             │             ▼                           │
│             │     InputConnection.commitText()        │
└─────────────┴───────────────────────────────────────┘
```

## 📁 Project Structure

```
programerkeyboard/
├── android/app/src/main/
│   ├── kotlin/com/codekeys/codekeys/
│   │   ├── CodeKeysApplication.kt   # Pre-warms FlutterEngine
│   │   ├── CodeKeysIME.kt           # InputMethodService (IME)
│   │   └── MainActivity.kt          # Settings app activity
│   ├── res/xml/method.xml            # IME declaration
│   └── AndroidManifest.xml           # IME permissions & service
├── lib/
│   ├── main.dart                     # Dual entry points
│   ├── keyboard_view.dart            # Full keyboard UI
│   ├── language_switcher.dart        # Language picker bar
│   ├── snippet_row.dart              # Code snippet buttons
│   ├── settings_screen.dart          # App settings
│   ├── setup_screen.dart             # Setup guide / onboarding
│   ├── theme.dart                    # Dark/light theme system
│   └── languages/
│       ├── language_model.dart       # Base model & registry
│       ├── cpp.dart                  # C++ snippets
│       ├── python.dart               # Python snippets
│       ├── javascript.dart           # JavaScript snippets
│       ├── java.dart                 # Java snippets
│       └── dart_lang.dart            # Dart snippets
├── pubspec.yaml
└── README.md
```

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (3.11+)
- [Android Studio](https://developer.android.com/studio) with Kotlin support
- Android device or emulator (API 21+)

### Build & Run

```bash
# 1. Clone the repository
git clone https://github.com/Snarenkumar/genz-keyboard.git
cd genz-keyboard

# 2. Get dependencies
flutter pub get

# 3. Run the app (installs to device/emulator)
flutter run

# 4. Build debug APK
flutter build apk --debug
```

### Enable the Keyboard on Android

1. **Install the app** on your Android device
2. **Open the CodeKeys app** — you'll see the setup screen
3. **Tap "Open Keyboard Settings"** → Enable **CodeKeys** in the list
4. **Open any text field** (WhatsApp, Chrome, Notes, etc.)
5. **Switch keyboard**: Tap the keyboard icon in the navigation bar, or long-press the space bar in your current keyboard, and select **CodeKeys**
6. **Start coding!** 🎉

### Testing in Emulator

1. Run `flutter run` to install the app
2. Open Settings → System → Languages & Input → On-screen keyboard → Manage keyboards
3. Enable "CodeKeys"
4. Open any app with a text field
5. Switch to CodeKeys using the keyboard switcher in the bottom navigation bar

---

## 📖 Usage Guide

Once CodeKeys is enabled and selected as your keyboard, here's how to use every feature:

### 1. 🔄 Switching Programming Languages

The **top row** of the keyboard shows language tabs:

```
[ ⚙️ C++ ]  [ 🐍 PY ]  [ 📦 JS ]  [ ☕ JAVA ]  [ 🎯 DART ]
```

- **Tap any language tab** to instantly switch — the snippet row below updates with language-specific shortcuts
- The **currently selected language** is highlighted with a blue accent chip
- Your selected language is **saved automatically** — it will persist even after closing the keyboard
- The **space bar** shows the current language name (e.g., `C++`) so you always know which mode you're in

### 2. ⚡ Using Code Snippets

The **second row** (below the language tabs) contains scrollable **code snippet buttons** shown in green:

```
[ cout << ]  [ cin >> ]  [ endl ]  [ :: ]  [ -> ]  [ #include ]  [ main() ] ...
```

- **Tap a snippet** to insert the full code template at your cursor position
- **Scroll horizontally** to see more snippets — each language has 8–12 snippets
- Snippets insert **complete templates**, not just keywords. For example:
  - Tapping `for` in C++ inserts: `for (int i = 0; i < n; i++) {  }`
  - Tapping `def` in Python inserts: `def function_name():` with cursor positioned at the function name
  - Tapping `console.log` in JS inserts: `console.log()` with cursor inside the parentheses
- **Smart cursor placement**: After inserting, the cursor is automatically moved to the most useful position (e.g., inside parentheses or brackets)

### 3. ⌨️ Keyboard Modes

CodeKeys has **three input modes** you can switch between:

#### QWERTY Mode (Default)
The standard letter keyboard layout with full A-Z keys.

#### Symbols Page 1 — Tap `123`
Common symbols used in programming:
```
[ 1 ] [ 2 ] [ 3 ] [ 4 ] [ 5 ] [ 6 ] [ 7 ] [ 8 ] [ 9 ] [ 0 ]
[ @ ] [ # ] [ $ ] [ _ ] [ & ] [ - ] [ + ] [ ( ] [ ) ] [ / ]
[ * ] [ " ] [ ' ] [ : ] [ ; ] [ ! ] [ ? ]
```

#### Symbols Page 2 — Tap `2/2`
Extended/special characters:
```
[ ~ ] [ ` ] [ | ] [ · ] [ √ ] [ π ] [ ÷ ] [ × ] [ ¶ ] [ ∆ ]
[ £ ] [ € ] [ ¥ ] [ ^ ] [ ° ] [ = ] [ { ] [ } ] [ \ ] [ % ]
[ © ] [ ® ] [ ™ ] [ < ] [ > ] [ [ ] [ ] ]
```

**How to switch between modes:**

| You're in...     | Tap this...  | To get to...          |
|------------------|--------------|-----------------------|
| QWERTY (letters) | `123`        | Symbols Page 1        |
| Symbols Page 1   | `2/2`        | Symbols Page 2        |
| Symbols Page 2   | `1/2`        | Symbols Page 1        |
| Any Symbols page | `ABC`        | Back to QWERTY        |

### 4. ⬆️ Shift & Caps Lock

The **Shift key** (⬆️ arrow on the left) has three states:

| Tap count | State       | Icon                | Behavior                              |
|-----------|-------------|---------------------|---------------------------------------|
| 1 tap     | **Shift**   | ↑ (filled arrow)    | Next letter typed will be UPPERCASE, then auto-reverts to lowercase |
| 2 taps    | **Caps Lock** | ⇪ (caps icon)     | ALL letters typed will be UPPERCASE until you tap again |
| 3 taps    | **Off**     | ↑ (outline arrow)   | Back to normal lowercase              |

### 5. ⌫ Backspace

- **Tap** the backspace key (⌫) to delete one character
- **Hold** the backspace key to **continuously delete** characters (repeats every 80ms for fast deletion)
- Release to stop deleting

### 6. ↵ Enter Key

- The **blue Enter key** (↵) on the bottom-right sends a newline / return action
- Works the same as the Enter key on any standard keyboard
- Provides **medium haptic feedback** for tactile confirmation

### 7. 📊 Bottom Row Controls

The bottom row contains essential utility keys:

```
[ 123 ]  [ , ]  [          C++          ]  [ . ]  [ ↵ ]
```

| Key         | Function                                          |
|-------------|---------------------------------------------------|
| `123` / `ABC` | Toggle between QWERTY and Symbol mode           |
| `,` (comma)  | Inserts a comma                                  |
| Space bar    | Inserts a space — displays current language name |
| `.` (period) | Inserts a period                                 |
| `↵` (Enter)  | Sends Enter / newline                            |

---

## ⚙️ Settings Guide

Open the **CodeKeys app** to access Settings (gear icon in the app). Available options:

### Keyboard Settings
| Setting            | Description                                              | Default  |
|--------------------|----------------------------------------------------------|----------|
| **Default Language** | Choose which language loads when the keyboard opens     | C++      |

### Appearance
| Setting         | Description                                    | Default  |
|-----------------|------------------------------------------------|----------|
| **Dark Theme**  | Toggle between dark (VS Code) and light mode   | On       |

### Feedback
| Setting             | Description                           | Default  |
|---------------------|---------------------------------------|----------|
| **Haptic Feedback** | Vibrate on every key press            | On       |
| **Sound Feedback**  | Play a click sound on key press       | Off      |

> **Note**: Settings are saved automatically and persist across app restarts and keyboard sessions.

---

## 🎯 Quick Reference

| Action                    | How to do it                                              |
|---------------------------|-----------------------------------------------------------|
| Switch language           | Tap a language tab at the top (C++, PY, JS, JAVA, DART)  |
| Insert code snippet       | Tap a green snippet button in the second row              |
| See more snippets         | Scroll the snippet row horizontally                       |
| Type uppercase letter     | Tap Shift (⬆️) once, then type the letter                |
| Enable caps lock          | Tap Shift (⬆️) twice                                     |
| Type numbers & symbols    | Tap `123` at bottom-left                                  |
| Type extended symbols     | In symbol mode, tap `2/2`                                 |
| Return to letters         | Tap `ABC` at bottom-left                                  |
| Delete one character      | Tap ⌫ (backspace)                                        |
| Fast delete many chars    | Hold ⌫ (backspace)                                       |
| New line                  | Tap the blue ↵ key                                       |
| Check current language    | Look at the space bar label                               |
| Change default language   | Open CodeKeys app → Settings → Default Language           |
| Toggle dark/light theme   | Open CodeKeys app → Settings → Dark Theme                 |
| Toggle vibration          | Open CodeKeys app → Settings → Haptic Feedback            |

---

## 💡 Tips & Tricks

1. **Code on WhatsApp/Telegram**: Use CodeKeys in any messaging app to share code snippets with friends — just switch to CodeKeys, select your language, and tap the snippet you need
2. **Quick brackets**: Switch to Symbols Page 1 (`123`) for `( )`, or Symbols Page 2 for `{ } [ ] < >`
3. **Arrow operator shortcut**: In C++ mode, tap the `->` snippet instead of typing dash and greater-than separately
4. **Smart templates**: Snippets like `for`, `if`, and `class` insert full boilerplate — you just fill in the blanks
5. **Switch mid-conversation**: You can switch languages anytime without losing your typed text — only the snippet row changes

---

## 🎨 Design

### Dark Theme (Default)
- **Background**: Deep dark blue-gray (`#1E1E2E`) — VS Code inspired
- **Keys**: Subtle elevated surfaces with smooth press animations
- **Snippets**: Green accent (`#A6E3A1`) — visually distinct from regular keys
- **Language switcher**: Blue accent (`#89B4FA`) chips

### Light Theme
- Clean white keys on light gray background
- Same green/blue accent system adapted for light mode

## 🔧 Technical Details

- **Flutter** renders the keyboard UI inside a native `InputMethodService`
- **Platform Channels** (`MethodChannel`) bridge Flutter ↔ Kotlin for text input
- **Pre-warmed FlutterEngine** cached in `Application.onCreate()` for fast startup
- **SharedPreferences** persists language selection, theme, and feedback settings
- Keyboard height: ~300dp (adjustable)

## 📄 License

MIT License — feel free to use, modify, and distribute.

## 🤝 Contributing

Contributions are welcome! Feel free to:
- Add new programming languages
- Improve the keyboard layout
- Add gesture typing support
- Build the iOS keyboard extension

---

**Built with ❤️ for programmers who code on the go.**
