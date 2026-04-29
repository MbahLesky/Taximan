# Taximan Driver App

Taximan Driver is the driver-facing Flutter app for onboarding, managing availability, receiving ride requests, executing trips, and reviewing earnings.

## Current Phase

Phase 1: Driver App Foundation + UI Prototype.

This build uses dummy data only. Firebase, authentication, Firestore, real maps, real-time trip updates, payments, and backend ride logic are intentionally not implemented yet.

## Completed Work

- Renamed the app display name to `Taximan Driver`.
- Added Driver color theme and Material 3 styling.
- Added GoRouter navigation for all requested driver prototype screens.
- Added Riverpod app wrapper for future state management.
- Added a basic SharedPreferences service.
- Added reusable UI widgets: `AppButton`, `AppTextField`, `AppCard`, and `BottomNavShell`.
- Added dummy driver, vehicle, document, request, trip, and earnings data.
- Added a simple green driver app icon placeholder and Android launcher icon assets.

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
│   ├── onboarding/
│   ├── availability/
│   ├── booking_management/
│   ├── trip/
│   ├── earnings/
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
assets/icons/taximan_driver_icon.png
```

Android launcher PNGs were updated in the `android/app/src/main/res/mipmap-*` folders. A final production icon can replace these assets later.

## Next Phase

Driver Authentication: real registration, login, session handling, and driver profile creation after Firebase configuration is added.
