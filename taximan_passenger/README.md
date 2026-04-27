# Taximan Passenger App

The Passenger App allows users to request rides, track drivers, and complete trips.

---

## Features (MVP)

* Authentication (register/login)
* Location-based ride booking
* Driver matching
* Real-time trip tracking
* Payment (cash)
* Rating and feedback
* Trip history

---

## Tech Stack

* Flutter
* Riverpod
* GoRouter
* Firebase Auth
* Cloud Firestore
* Firebase Messaging
* Google Maps
* SharedPreferences

---

## Project Structure

```text
lib/
├── core/
├── shared/
├── features/
│   ├── auth/
│   ├── booking/
│   ├── driver_matching/
│   ├── trip/
│   ├── payments/
│   ├── ratings/
│   └── account/
```

---

## Current Status

Phase:
**Project Foundation**

Completed:

* App setup
* Routing
* Theme
* Placeholder screens

Next:
**Authentication Implementation**

---

## Running the App

```bash
flutter pub get
flutter run
```

---

## Firebase Setup

Add:

```text
android/app/google-services.json
```

---

## Notes

* App is **online-first**
* Offline only supports cached data
* Do not implement booking logic yet (until Phase 04)

---

## Development Rules

* Follow `/docs` strictly
* Keep UI clean and simple
* Use Riverpod for all state
* Do not put logic in UI

---

## Summary

This app is responsible for the full passenger ride experience — from booking to payment and rating.
