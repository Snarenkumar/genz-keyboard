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
