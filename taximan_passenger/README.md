# Taximan Passenger App

Taximan Passenger is the rider-facing Flutter app for booking taxis, viewing driver assignment, tracking a trip, confirming payment, and leaving a rating.

## Current Phase

Phase 4: Passenger Booking UI complete, with Firebase-backed data providers.

The passenger booking flow now stores and reads core booking, driver, fare proposal, trip, profile, payment, and rating data through repositories/providers instead of local dummy data.

## Completed Work

- Renamed the app display name to `Taximan Passenger`.
- Added Passenger color theme and Material 3 styling.
- Added GoRouter navigation for all requested passenger prototype screens.
- Added Riverpod app wrapper for future state management.
- Added a basic SharedPreferences service.
- Added reusable UI widgets: `AppButton`, `AppTextField`, `AppCard`, and `BottomNavShell`.
- Added Firebase-backed providers for passenger profile, bookings, drivers, trips, fare proposals, payments, and ratings.
- Added a network status provider for online-first booking actions.
- Added a simple yellow passenger app icon placeholder and Android launcher icon assets.

## Dependencies

- `flutter_riverpod`
- `go_router`
- `firebase_core`
- `shared_preferences`
- `connectivity_plus`
- `cupertino_icons`

Not added yet: `firebase_storage`, `firebase_messaging`, and `google_maps_flutter`.

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

`Firebase.initializeApp()` is already present. Firestore and Auth-backed passenger flows are now wired through repositories; remaining backend work is real-time matching, maps, notifications, and payment processing.

## App Icon

Placeholder icon:

```text
assets/icons/taximan_passenger_icon.png
```

Android launcher PNGs were updated in the `android/app/src/main/res/mipmap-*` folders. A final production icon can replace these assets later.

## Next Phase

Phase 5 / Phase 7: complete driver operations UI and real-time passenger-driver synchronization.
