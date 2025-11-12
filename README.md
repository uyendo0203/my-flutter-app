# My Flutter App

A beautiful Flutter application with iOS and web support.

## Features

- 📱 iOS support
- 🌐 Web support
- 🎨 Modern UI design

## Getting Started

### Prerequisites

- Flutter SDK
- Xcode (for iOS development)
- Chrome (for web development)

### Installation

1. Clone the repository:
```bash
git clone <your-repo-url>
cd my-flutter-app
```

2. Get dependencies:
```bash
flutter pub get
```

3. For iOS development:
```bash
cd ios
pod install
```

### Running the app

#### On iOS Simulator:
```bash
flutter run -d "iPhone 15 Pro"
```

#### On Web:
```bash
flutter run -d chrome
```

#### On macOS:
```bash
flutter run -d macos
```

## Development

### Project Structure

```
lib/
├── main.dart          # Main application entry point
├── models/            # Data models
├── screens/           # UI screens
├── widgets/           # Reusable widgets
└── services/          # Business logic and APIs
```

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.