# 🤖 AI Chat Application

A modern, feature-rich mobile chat application powered by Google's Gemini AI, built with Flutter and Firebase.


## ✨ Features

### 🔐 Authentication
- Email/Password authentication
- Google Sign-In integration
- Secure user session management
- Automatic user data creation and storage

### 💬 Chat Features
- Real-time AI-powered conversations using Gemini 2.5 Flash Lite
- Image recognition and analysis
- Animated typing effect for AI responses
- Message history with timestamps
- Multiple chat sessions support
- Chat history management (load, delete)

### 📱 User Interface
- Modern, clean Material Design
- Smooth animations and transitions
- Responsive layout for all screen sizes
- Dark-themed chat bubbles
- Intuitive navigation drawer
- Suggested questions for quick start

### 💾 Data Management
- Cloud Firestore for data persistence
- Real-time synchronization across devices
- Efficient chat history storage
- User profile management

## 🏗️ Architecture

This project follows **Clean Architecture** principles with clear separation of concerns:

```
lib/
├── core/
│   ├── services/          # Core services (Auth, Firestore, API)
│   └── utils/             # Constants, themes, routing
├── features/
│   ├── auth/
│   │   ├── auth_cubit/    # Authentication state management
│   │   ├── models/        # User data models
│   │   └── views/         # Login & Register pages
│   └── home/
│       ├── chat_ai_cubit/ # Chat state management
│       ├── models/        # Message & Chat models
│       ├── services/      # AI & Native services
│       └── views/         # Home page & widgets
└── main.dart
```

### State Management
- **BLoC Pattern** using `flutter_bloc` for predictable state management
- Clear separation between UI and business logic
- Reactive UI updates based on state changes

## 🛠️ Tech Stack

### Frontend
- **Flutter 3.x** - Cross-platform UI framework
- **Dart** - Programming language
- **flutter_screenutil** - Responsive UI sizing
- **animated_text_kit** - Text animations

### Backend & Services
- **Firebase Authentication** - User authentication
- **Cloud Firestore** - NoSQL database
- **Google Generative AI** - Gemini AI integration

### State Management
- **flutter_bloc** - BLoC pattern implementation
- **Cubit** - Simplified state management

### Additional Packages
- **image_picker** - Camera & Gallery access
- **google_sign_in** - Google OAuth
- **gap** - Spacing widgets

## 📋 Prerequisites

Before you begin, ensure you have:
- Flutter SDK (3.0.0 or higher)
- Dart SDK (3.0.0 or higher)
- Android Studio / Xcode for emulators
- Firebase project setup
- Google Gemini API key

## 🚀 Getting Started

### 1. Clone the Repository
```bash
git clone https://github.com/yusuf-4444/chat-app-ai.git
cd chat-app-ai
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Firebase Setup

#### a. Create a Firebase Project
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project
3. Enable Authentication (Email/Password & Google)
4. Create a Firestore Database

#### b. Configure Firebase for Flutter
```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure Firebase
flutterfire configure
```

#### c. Update Firestore Rules
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;

      match /chats/{chatId} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
    }
  }
}
```

### 4. Get Gemini API Key
1. Visit [Google AI Studio](https://makersuite.google.com/app/apikey)
2. Create an API key
3. Update `lib/core/utils/app_constants.dart`:
```dart
class AppConstants {
  static const String apiKey = "YOUR_GEMINI_API_KEY_HERE";
}
```

### 5. Run the App
```bash
# For Android
flutter run

# For iOS
flutter run

# For Web
flutter run -d chrome
```

## 📱 Supported Platforms

- ✅ Android
- ✅ iOS
- ✅ Web
- ✅ Windows
- ✅ macOS

## 🔧 Configuration

### App Constants
Update `lib/core/utils/app_constants.dart`:
```dart
class AppConstants {
  static const String apiKey = "YOUR_API_KEY";
}
```

### Theme Customization
Modify `lib/core/utils/app_themes.dart` to customize the app theme.

## 📸 Screenshots

> Add your app screenshots here

## 🎯 Key Features Explained

### Chat Session Management
- Each chat is assigned a unique ID based on timestamp
- Messages are stored in Firestore under user's collection
- Chat history is sorted by last update time

### Image Processing
- Support for camera and gallery image selection
- Images are sent to Gemini AI for analysis
- Local image preview before sending

### Animated Responses
- AI responses use typewriter animation effect
- Only new messages animate (old messages display instantly)
- Smooth scrolling to latest message

## 🔒 Security Best Practices

- ✅ API keys stored in constants (move to environment variables in production)
- ✅ Firestore security rules implemented
- ✅ User authentication required for all operations
- ✅ User can only access their own data

### Production Security Checklist
- [ ] Move API keys to environment variables
- [ ] Enable App Check for Firebase
- [ ] Implement rate limiting
- [ ] Add input validation
- [ ] Enable Google reCAPTCHA

## 🐛 Known Issues

- Image paths are not persisted in Firestore (images lost after app restart)
- No offline support for messages
- Limited error handling for network failures

## 🛣️ Roadmap

- [ ] Add voice message support
- [ ] Implement message search
- [ ] Add dark mode toggle
- [ ] Export chat history
- [ ] Multi-language support
- [ ] Offline message caching
- [ ] Push notifications
- [ ] Share chats with other users

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 Code Style

This project follows the [Effective Dart](https://dart.dev/guides/language/effective-dart) style guide.

Run the following before committing:
```bash
# Format code
dart format .

# Analyze code
flutter analyze

# Run tests
flutter test
```

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 Author

**Yusuf Mohamed**
- GitHub: [@yusuf-4444](https://github.com/yusuf-4444)
- LinkedIn: [Yusuf Mohamed](https://www.linkedin.com/in/yusuf-mohamed-8a2798306/)
- Portfolio: Coming Soon 🚀

## 🙏 Acknowledgments

- [Flutter Team](https://flutter.dev) for the amazing framework
- [Firebase](https://firebase.google.com) for backend services
- [Google AI](https://ai.google.dev) for Gemini API
- [BLoC Library](https://bloclibrary.dev) for state management

## 📞 Support

If you have any questions or need help, please:
- Open an issue on GitHub
- Reach out via email
- Connect on LinkedIn

---

⭐ If you found this project helpful, please give it a star!

**Made with ❤️ and Flutter**
