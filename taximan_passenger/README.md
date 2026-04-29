# Taximan Passenger App

Taximan Passenger is the rider-facing Flutter app for booking taxis, viewing driver assignment, tracking a trip, confirming payment, and leaving a rating.

## Current Phase

Phase 1: Passenger App Foundation + UI Prototype.

This build uses dummy data only. Firebase, authentication, Firestore, real maps, real payments, and backend ride logic are intentionally not implemented yet.

## Completed Work

- Renamed the app display name to `Taximan Passenger`.
- Added Passenger color theme and Material 3 styling.
- Added GoRouter navigation for all requested passenger prototype screens.
- Added Riverpod app wrapper for future state management.
- Added a basic SharedPreferences service.
- Added reusable UI widgets: `AppButton`, `AppTextField`, `AppCard`, and `BottomNavShell`.
- Added dummy passenger, trip, driver, fare, and payment data.
- Added a simple yellow passenger app icon placeholder and Android launcher icon assets.

## Dependencies

- `flutter_riverpod`
- `go_router`
- `firebase_core`
- `shared_preferences`
- `connectivity_plus`
- `cupertino_icons`

Not added yet: `firebase_auth`, `cloud_firestore`, `firebase_storage`, `firebase_messaging`, and `google_maps_flutter`.

## Folder Structure

```text
lib/
├── core/
│   ├── constants/
│   ├── services/
│   ├── theme/
│   └── utils/
├── shared/
│   ├── widgets/
│   └── dummy/
├── features/
│   ├── auth/
│   ├── booking/
│   ├── matching/
│   ├── trip/
│   ├── payments/
│   ├── ratings/
│   └── account/
├── router/
├── app.dart
└── main.dart
```

## How To Run

```bash
flutter pub get
flutter run
```

## Firebase Setup Still Required

Before backend work starts, add Firebase configuration files:

```text
android/app/google-services.json
ios/Runner/GoogleService-Info.plist
```

`Firebase.initializeApp()` is already present, but backend features remain TODO.

## App Icon

Placeholder icon:

```text
assets/icons/taximan_passenger_icon.png
```

Android launcher PNGs were updated in the `android/app/src/main/res/mipmap-*` folders. A final production icon can replace these assets later.

## Next Phase

Passenger Authentication: real registration, login, session handling, and passenger profile creation after Firebase configuration is added.
