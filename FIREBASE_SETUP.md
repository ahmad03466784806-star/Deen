# DEEN Firebase setup

The repository is prepared for Firebase Hosting. The project alias is set to
`deen-app-5baeb`, and Hosting serves the Flutter web build from `build/web`.

## One-time account setup

1. Open the Firebase console and select project `deen-app-5baeb`.
2. In Project settings, register a Web app for DEEN if one does not exist.
3. In GitHub, open **Settings → Secrets and variables → Actions**.
4. Add a repository secret named `FIREBASE_SERVICE_ACCOUNT_DEEN_APP_5BAEB`
   containing a Firebase service-account JSON credential with permission to
   deploy Hosting for this project.
5. In Firebase Console → Hosting, confirm Hosting is enabled.

Do not commit service-account JSON, private keys, API credentials, or user data.

## Deploy from a trusted local environment

Install Flutter and Firebase CLI, then run:

```bash
flutter pub get
flutter test
flutter build web --release
firebase login
firebase use deen-app-5baeb
firebase deploy --only hosting
```

The GitHub Actions workflow builds the web app and deploys to Firebase Hosting
when changes reach `main`. It requires the repository secret described above.

## What is not connected yet

Hosting deployment is separate from app backend integration. Firebase
Authentication, Cloud Firestore, Cloud Storage, Cloud Messaging, and security
rules have not been activated in Dart code. Before enabling those services,
register the Android and Web apps in Firebase, run FlutterFire configuration
for the exact app IDs, add the generated `firebase_options.dart` securely
as normal non-secret client configuration, and design/test Firestore and
Storage security rules. Never use permissive production rules.

## Local build checks

```bash
flutter pub get
flutter analyze
flutter test
flutter build web --release
```
