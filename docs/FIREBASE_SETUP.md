# Firebase Setup for Spotly

This document outlines the Firebase configuration and setup process for the Spotly application.

## Project Information

- **Project ID**: spotly-6790d
- **Project Number**: 1051998072292
- **Package Name**: com.jml.spotly

## Security Approach (Updated)

For security reasons, we've implemented a server-centric approach for Firebase:

1. **No API keys in client code** - API keys are stored in `.environment` file and not hardcoded
2. **Backend proxy for sensitive operations** - Critical operations use our backend rather than direct API calls
3. **Environment variables** - All configuration is loaded from environment variables
4. **Build-time injection for web** - Web Firebase config is injected during build time

See `SECURE_API_USAGE.md` for more details on our security approach.

## Environment Variables

All sensitive configuration values are stored in the `.environment` file. This approach keeps API keys and secrets out of version control:

```
# Firebase Android Configuration
FIREBASE_API_KEY=...

# Firebase iOS Configuration
FIREBASE_IOS_API_KEY=...

# Firebase Web Configuration
FIREBASE_WEB_API_KEY=...

# Google Maps API Key
GOOGLE_MAPS_API_KEY=...
```

## Setup Steps Completed

1. Created a Firebase project in the Firebase Console
2. Added an Android app with the package name `com.jml.spotly`
3. Downloaded and placed the `google-services.json` file in `android/app/`
4. Added iOS configuration through `GoogleService-Info.plist` in `ios/Runner/`
5. Added web configuration through `firebase-config.js` in `web/`
6. Updated the Gradle files to include Firebase dependencies:
   - Added Google services classpath to project-level build.gradle
   - Applied Google services plugin in app-level build.gradle
   - Updated application ID to match Firebase configuration
7. Created Firebase configuration files in the Flutter app to use environment variables
8. Implemented secure API service for backend-proxied operations

## Firebase Services Used

- **Firebase Authentication**: For user authentication
- **Cloud Firestore**: For database storage
- **Firebase Storage**: For storing images and other files
- **Firebase Messaging**: For push notifications

## Adding New Firebase Services

To add new Firebase services to the project:

1. Add the required dependency to `pubspec.yaml`
2. Run `flutter pub get` to install the dependency
3. Initialize the service in `lib/config/firebase/firebase_service.dart`
4. Create a repository and data sources for the service as needed

## Security Considerations

- API keys are stored in the `.environment` file, not hardcoded in source files
- Firebase Admin SDK operations are performed through a backend API
- All API keys are accessed through environment variables for both client and server
- Web configuration is injected at build time to prevent exposing keys
- Use Firebase Authentication for secure user identity management

## Troubleshooting

If you encounter issues with Firebase integration:

1. Verify that `.environment` file contains all necessary configuration
2. Check that the application ID in `build.gradle.kts` matches the one in Firebase
3. Ensure all required dependencies are properly installed
4. Look for error messages in the debug console during initialization
5. Verify that backend proxy services are correctly configured

## Further Resources

- [Firebase Security Best Practices](https://firebase.google.com/docs/rules/basics)
- [Google API Security Best Practices](https://developers.google.com/maps/api-security-best-practices)
- [OWASP Mobile Security Testing Guide](https://owasp.org/www-project-mobile-security-testing-guide/)
- [Firebase Flutter Documentation](https://firebase.google.com/docs/flutter/setup)
- [Firebase Console](https://console.firebase.google.com/project/spotly-6790d)
- [Firebase Authentication Guide](https://firebase.google.com/docs/auth)
- [Cloud Firestore Guide](https://firebase.google.com/docs/firestore) 