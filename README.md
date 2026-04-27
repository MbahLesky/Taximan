# Taximan

Taximan is a mobile vehicle-booking platform that connects passengers with nearby drivers for fast, reliable, and convenient transportation.

This repository contains the full project, including:

* Passenger mobile app
* Driver mobile app
* Shared documentation

---

## Project Structure

```text
taximan/
├── docs/                 # All project documentation
├── taximan_passenger/    # Passenger Flutter app
├── taximan_driver/       # Driver Flutter app
└── README.md
```

---

## Applications

### Passenger App

Allows users to:

* Register and login
* Request rides
* Track drivers in real time
* Pay for trips
* Rate drivers
* View trip history

### Driver App

Allows drivers to:

* Register and login
* Complete onboarding
* Go online/offline
* Receive ride requests
* Execute trips
* View earnings

---

## Tech Stack

* **Frontend:** Flutter (Passenger & Driver)
* **State Management:** Riverpod
* **Routing:** GoRouter
* **Backend:** Firebase
* **Database:** Cloud Firestore
* **Storage:** Firebase Storage
* **Notifications:** Firebase Cloud Messaging
* **Maps:** Google Maps Platform
* **Local Storage:** SharedPreferences

---

## Architecture

* Two separate Flutter apps
* Shared Firebase backend
* Real-time updates using Firestore listeners
* Online-first system with limited offline support

---

## Development Phases

Current Phase:
**Phase 01 — Project Foundation**

Next Phase:
**Phase 02 — Authentication**

Refer to:
`docs/12_development_roadmap.md` for full roadmap

---

## Setup Instructions

### 1. Clone Repository

```bash
git clone <repo_url>
cd taximan
```

### 2. Open Apps

```bash
cd taximan_passenger
flutter pub get
flutter run
```

```bash
cd ../taximan_driver
flutter pub get
flutter run
```

---

## Firebase Setup

You must add Firebase configuration files:

### Android

* Place `google-services.json` in:

```
android/app/
```

### iOS (if used)

* Place `GoogleService-Info.plist` in:

```
ios/Runner/
```

---

## Important Notes

* The app is **online-first**
* Critical actions require internet connection
* Do not modify structure without updating `/docs`

---

## Documentation

All project documentation is located in:

```text
/docs/
```

Key documents:

* Project overview
* MVP scope
* Feature breakdown
* User flows
* Architecture
* Database schema
* API logic
* Real-time flow
* Offline strategy

---

## Contribution Guidelines

* Follow the structure defined in `/docs`
* Do not add features outside MVP scope
* Keep code modular and clean
* Update documentation when adding features

---

## Status

* Project initialized
* Structure created
* Ready for Authentication phase

---

## Summary

Taximan is built as a scalable, real-time transportation platform with a clean architecture and strong foundation for future growth.
