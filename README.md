# DEEN — Your Islamic Digital World

Flutter starter project for the DEEN app.

## Included screens
- Home dashboard with prayer-time placeholders and quick access
- Digital Tasbih counter (interactive)
- Qibla screen placeholder (compass/location not connected yet)
- Personal Files list UI (demo entries; local/cloud file picker not connected)
- Islamic Community feed UI (local demo posts and like state)
- More, Quran/Duas/Calendar placeholders and Zakat estimate calculator

## Run
Install Flutter SDK, then run:

```bash
flutter pub get
flutter run
```

## Important
This is the first UI + interaction foundation, not a production-ready Islamic social platform.
Prayer times, Hijri date, Qibla sensors, Quran content/audio, file upload/download/storage,
authentication, cloud database, chat, comments, notifications, moderation and live streaming
still need real service integrations and testing.

Prayer times are intentionally shown as `—:—` rather than invented live timings.
Zakat output is an estimate only and should be checked against current nisab and scholarly guidance.

## GitHub
Create an empty repository named `deen-islamic-app`, then from this project folder:

```bash
git init
git add .
git commit -m "Initial DEEN Flutter app"
git branch -M main
git remote add origin https://github.com/YOUR-USERNAME/deen-islamic-app.git
git push -u origin main
```

Replace `YOUR-USERNAME` with your GitHub username. Never share your password or access token.
