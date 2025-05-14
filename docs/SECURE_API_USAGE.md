# Secure API Usage in Spotly

This document outlines the secure approach for handling API keys and sensitive configuration in the Spotly application.

## Security Overview

In Spotly, we follow these security principles:

1. **Never expose API keys in client-side code** - All sensitive keys are stored server-side or in secure environment variables
2. **Proxy API requests through a backend service** - Client does not make direct API calls requiring keys
3. **Environment variables for configuration** - All sensitive configuration is loaded from environment variables
4. **Build-time injection for web** - Web configuration is injected during build time

## Architecture

### Client-Side (Flutter App)

- Environment variables are loaded from `.environment` file (which is not committed to version control)
- App makes requests to our backend API rather than directly to third-party services
- Firebase Authentication is handled through secure channels

### Server-Side (Backend API)

- Stores all API keys securely in environment variables
- Provides proxy endpoints for Google Maps, Firebase, and other services
- Handles API key rotation and management
- Implements proper rate limiting and request validation

## Implementation

### Environment Variables

All sensitive configuration is stored in the `.environment` file:

```
# API keys are never hardcoded
FIREBASE_API_KEY=...
GOOGLE_MAPS_API_KEY=...
```

### Secure API Service

We've implemented a `SecureApiService` that communicates with our backend:

```dart
// Example: Getting Google Places data
final places = await SecureApiService.getPlaces(
  latitude: 37.7749,
  longitude: -122.4194,
  radius: 1000,
);
```

The backend adds the API key before making the request to Google's services.

### Web Configuration

For web builds, configuration is injected at build time:

1. Web config template uses placeholders: `__FIREBASE_WEB_API_KEY__`
2. Build script replaces placeholders with actual values from environment variables
3. No sensitive values are stored in version control

## Build Process

1. Development: Use local `.environment` file
2. CI/CD: Environment variables are injected by the CI/CD system
3. Web builds: Run `dart run scripts/inject_web_env.dart` before building

## Backend Implementation

The backend API implements these endpoints:

- `/api/v1/places/nearby` - Proxies requests to Google Places API
- `/api/v1/firebase/{operation}` - Proxies Firebase Admin SDK operations

All backend API requests require proper authentication and validation.

## Security Testing

We regularly perform:

1. Code review focusing on security
2. Static analysis to detect exposed secrets
3. Network traffic analysis to ensure no keys are leaked
4. Third-party security assessments

## Resources

- [OWASP Mobile Security Testing Guide](https://owasp.org/www-project-mobile-security-testing-guide/)
- [Firebase Security Rules Guide](https://firebase.google.com/docs/rules)
- [Keeping API Keys Secure in Mobile Apps](https://developers.google.com/maps/api-security-best-practices) 