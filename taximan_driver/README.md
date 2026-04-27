# Taximan Driver App

The Driver App allows drivers to receive ride requests, execute trips, and track earnings.

---

## Features (MVP)

* Authentication
* Driver onboarding
* Availability (online/offline)
* Booking management
* Trip execution
* Earnings tracking
* Account management

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
│   ├── onboarding/
│   ├── availability/
│   ├── booking_management/
│   ├── trip/
│   ├── earnings/
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
**Driver Onboarding**

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

* Driver must be verified before going online
* Driver cannot accept rides offline
* Real-time updates are critical

---

## Development Rules

* Follow `/docs` strictly
* Keep actions fast and clear
* Use large buttons for driver actions
* Keep logic inside providers/controllers

---

## Summary

This app is responsible for the driver workflow — receiving requests, completing trips, and earning income.
