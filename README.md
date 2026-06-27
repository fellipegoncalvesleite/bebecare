# BabyCare

BabyCare is a Flutter app in Portuguese for tracking a baby's routine, development and care. It is a local demo app, with no real backend and no real authentication.

## What You Can Use

1. Início shows the daily overview and quick actions.
2. Crescimento saves weight and height records over time.
3. Vacinas shows the vaccination schedule and status.
4. Estímulos brings age appropriate activities, stories, songs and animal sounds.
5. Conta keeps the local profile, appearance settings and demo login.
6. Light and dark mode are included through the shared app theme.

## Project Structure

```text
lib/
  main.dart
  data/       static content (media, activities)
  models/     data models
  screens/    one file per screen + app shell with bottom navigation
  services/   sound player and other services
  theme/      color palettes and theming
  widgets/    shared widgets
```

## How To Run

```bash
flutter pub get
flutter run
```

Asset credits are listed in [ASSETS_LICENSES.md](ASSETS_LICENSES.md).
