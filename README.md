# DEEN — Your Islamic Digital World

DEEN is a Flutter app foundation with a premium dark emerald and gold Islamic
visual theme.

## Current screens and interactions

- Home dashboard with prayer-time placeholders and quick access.
- Digital Tasbih counter.
- Qibla information screen (live compass/location not connected).
- Personal Files demo list (real file picking, upload and cloud storage not connected).
- Islamic Community demo feed (local post/like state; no server-side accounts or feed yet).
- More tools, Zakat estimate calculator, and step-by-step Janaza guide.

## Run locally

```bash
flutter pub get
flutter analyze
flutter test
flutter run
```

## Firebase Hosting

The repository includes `firebase.json`, `.firebaserc`, and a GitHub Actions
workflow for Firebase Hosting. Follow [FIREBASE_SETUP.md](FIREBASE_SETUP.md)
and add the required GitHub Actions service-account secret before expecting
automatic deployment.

## Backend status

Firebase Hosting deployment is scaffolded separately from Firebase app
services. Firebase Authentication, Firestore, Storage, Messaging, live prayer
times, Hijri calendar, Qibla sensors, Quran audio, and production community
features still require configuration, implementation, security rules, and
device testing. Do not treat demo/local interactions as cloud-backed features.

Prayer times are intentionally displayed as placeholders rather than
inventing live timings. Zakat output is an estimate only and should be checked
against current nisab and qualified scholarly guidance.

Educational content aims to follow Ahl-e-Sunnat wal-Jamaat guidance and uses
the commonly followed Hanafi method in Pakistan where a fiqhi method is needed.
Legitimate differences should be noted; verify detailed rulings with qualified
scholars.

## Repository

[ahmad03466784806-star/Deen](https://github.com/ahmad03466784806-star/Deen)
