# Spotly

A Flutter application for discovering and sharing local events and places.

## ⚠️ Important Notice

This application is proprietary software owned by Spotly Inc. Unauthorized use, distribution, or modification of this software is strictly prohibited and may result in legal action. This software is not free to use and requires proper licensing.

## Features

- View events and places on a map
- Create and manage events
- Search for nearby places
- User profiles and authentication
- Dark mode support
- Responsive design
- Push notifications
- Cross-platform support (iOS & Android)
- Real-time event updates
- Social sharing
- Event categories and tags
- User ratings and reviews
- Offline support
- Analytics and reporting

## Prerequisites

- Flutter SDK (latest stable version)
- Android Studio / VS Code
- Git
- ImageMagick (for generating app icons)
- Firebase account
- Google Maps API key
- Backend API access

## Setup

1. Clone the repository:
```bash
git clone https://github.com/yourusername/spotly.git
cd spotly
```

2. Install dependencies:
```bash
flutter pub get
```

3. Create a `.env` file in the root directory with the following variables:
```
# Google Maps
GOOGLE_MAPS_API_KEY=your_google_maps_api_key

# Firebase
FIREBASE_API_KEY=your_firebase_api_key
FIREBASE_APP_ID=your_firebase_app_id
FIREBASE_MESSAGING_SENDER_ID=your_firebase_messaging_sender_id
FIREBASE_PROJECT_ID=your_firebase_project_id
FIREBASE_STORAGE_BUCKET=your_firebase_storage_bucket
FIREBASE_IOS_CLIENT_ID=your_firebase_ios_client_id
FIREBASE_ANDROID_CLIENT_ID=your_firebase_android_client_id

# Backend API
API_BASE_URL=your_api_base_url
API_TIMEOUT=30000

# App Configuration
APP_NAME=Spotly
APP_VERSION=1.0.0
APP_BUILD_NUMBER=1
```

4. Set up Firebase:
   - Create a new Firebase project
   - Add Android and iOS apps to your Firebase project
   - Download and add the configuration files:
     - Android: `google-services.json` to `android/app/`
     - iOS: `GoogleService-Info.plist` to `ios/Runner/`
   - Enable Firebase Cloud Messaging for push notifications
   - Configure Firebase Authentication
   - Set up Firebase Cloud Firestore
   - Configure Firebase Storage

5. Set up Google Maps:
   - Create a Google Cloud project
   - Enable Maps SDK for Android and iOS
   - Create API keys with appropriate restrictions
   - Add the API keys to your `.env` file

6. Generate app icons:
```bash
# Windows
scripts\generate_icons.bat

# Linux/macOS
chmod +x scripts/generate_icons.sh
./scripts/generate_icons.sh
```

7. Run the app:
```bash
flutter run
```

## Project Structure

```
lib/
├── config/           # App configuration
│   ├── firebase/    # Firebase configuration
│   ├── routes/      # App routing
│   └── theme/       # App theming
├── core/            # Core functionality
├── data/            # Data layer
├── domain/          # Business logic
└── presentation/    # UI layer
```

## Architecture

The app follows Clean Architecture principles with the following layers:
- Presentation Layer: UI components and state management
- Domain Layer: Business logic and use cases
- Data Layer: Data sources and repositories
- Core: Common utilities and services

## State Management

The app uses BLoC (Business Logic Component) pattern for state management, with the following features:
- Event-driven state updates
- Separation of concerns
- Testable business logic
- Reactive programming

## Testing

The app includes:
- Unit tests for business logic
- Widget tests for UI components
- Integration tests for features
- Performance testing
- Security testing

## Performance Optimization

- Lazy loading of images
- Caching of data
- Efficient state management
- Memory leak prevention
- Battery usage optimization

## Security

- Secure API communication
- Data encryption
- User authentication
- Permission management
- Input validation

## Contact Information

For licensing inquiries, support, or business opportunities, please contact:

- Email: tanuijobs11@gmail.com
- Phone: +254707696045

## Legal Notice

This software is proprietary and confidential. Unauthorized copying, distribution, or use of this software, via any medium, is strictly prohibited. This software is licensed, not sold. By using this software, you agree to be bound by the terms of the license agreement.

## License

This project is proprietary software owned by Spotly Inc. All rights reserved. Unauthorized use, distribution, or modification is prohibited.

For licensing information, please contact:
- Email: tanuijobs11@gmail.com
- Phone: +254707696045
