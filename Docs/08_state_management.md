# Taximan — State Management

## 1. Purpose

This document defines the state management strategy for the Taximan mobile applications (Passenger and Driver).

The goal is to ensure a **clean, scalable, and maintainable architecture** using Riverpod.

---

## 2. State Management Overview

Taximan uses:

* **Riverpod** for state management
* **Feature-based architecture**
* **Separation of concerns (UI, logic, data)**

---

## 3. State Types

## 3.1 Global State

Used across the entire app.

Examples:

* Auth state (logged in / logged out)
* Current user (passenger or driver)
* Network status
* App settings (theme, preferences)

---

## 3.2 Feature State

Scoped to specific features.

Examples:

* Booking state
* Driver matching state
* Trip state
* Earnings state
* Payment state

---

## 3.3 UI State

Local to screens/widgets.

Examples:

* Loading states
* Form inputs
* Toggle switches
* Dialog visibility

---

## 4. Folder Structure (Flutter)

Use a **feature-first structure**.

```id="k3fj92"
lib/
│
├── core/
│   ├── services/
│   ├── utils/
│   ├── constants/
│
├── shared/
│   ├── widgets/
│   ├── models/
│
├── features/
│   ├── auth/
│   ├── booking/
│   ├── driver_matching/
│   ├── trip/
│   ├── payments/
│   ├── ratings/
│   ├── account/
│
└── main.dart
```

Each feature contains:

```id="k9dk21"
feature_name/
│
├── data/
│   ├── models/
│   ├── repositories/
│
├── application/
│   ├── providers/
│   ├── controllers/
│
├── presentation/
│   ├── screens/
│   ├── widgets/
```

---

## 5. Riverpod Provider Types

## 5.1 StateProvider

Use for simple UI state.

Example:

* toggles
* selected options
* temporary values

---

## 5.2 StateNotifierProvider

Use for **business logic and complex state**.

Examples:

* booking flow
* trip lifecycle
* driver availability
* payment state

---

## 5.3 FutureProvider

Use for:

* one-time data fetch
* loading user profile
* fetching trip history

---

## 5.4 StreamProvider

Use for:

* real-time Firestore data
* trip updates
* driver location updates
* booking status changes

---

## 6. Core Providers

## 6.1 Auth Provider

Manages authentication state.

Responsibilities:

* login
* logout
* current user
* role (passenger or driver)

---

## 6.2 User Provider

Stores current user profile.

Responsibilities:

* fetch user data
* update profile
* cache user data

---

## 6.3 Driver Provider

Stores driver-specific data.

Responsibilities:

* driver profile
* availability status
* verification status

---

## 6.4 Booking Provider

Manages booking lifecycle.

Responsibilities:

* create booking
* update booking status
* handle fare proposals
* cancel booking

---

## 6.5 Trip Provider

Manages active trip state.

Responsibilities:

* track trip status
* start trip
* end trip
* sync with Firestore

---

## 6.6 Location Provider

Handles location updates.

Responsibilities:

* get current location
* update driver location
* stream location changes

---

## 6.7 Payment Provider

Handles payments.

Responsibilities:

* process payment
* track payment status
* update records

---

## 6.8 Earnings Provider (Driver)

Handles driver earnings.

Responsibilities:

* fetch earnings
* calculate totals
* update earnings after trip

---

## 7. Data Flow Pattern

Each feature follows:

```id="k19slx"
UI → Provider (StateNotifier) → Repository → Firebase → Response → Update State → UI
```

---

## 8. Repository Pattern

Each feature uses repositories to separate Firebase logic.

Example:

* AuthRepository
* BookingRepository
* TripRepository
* PaymentRepository

Responsibilities:

* interact with Firestore
* handle API logic
* abstract data layer

---

## 9. Real-Time Handling

Use **StreamProvider** for:

* bookings
* trips
* driver locations

Example:

* Passenger listens to booking status
* Passenger listens to driver location
* Driver listens to incoming booking requests

---

## 10. Offline Handling

## Supported

* Cached Firestore reads
* SharedPreferences for:

  * user session
  * settings
  * small preferences

## Not Supported

* Booking actions
* Trip execution
* Payment updates

Providers should:

* check network status
* block critical actions when offline

---

## 11. Error Handling

Each provider should handle:

* loading state
* success state
* error state

Use consistent pattern:

```id="k91slc"
loading → success → error
```

---

## 12. Naming Conventions

Use consistent naming:

* `authProvider`
* `bookingProvider`
* `tripProvider`
* `driverProvider`

Controllers:

* `BookingController`
* `TripController`

Repositories:

* `BookingRepository`
* `TripRepository`

---

## 13. Key Rules

* Do not put business logic in UI
* Keep providers focused on one responsibility
* Use repositories for Firebase interactions
* Use StreamProvider for real-time data
* Avoid deeply nested providers
* Keep state predictable and traceable

---

## 14. Summary

Taximan uses Riverpod with a feature-based structure to ensure:

* clean separation of concerns
* scalable architecture
* real-time synchronization
* maintainable codebase

This structure allows both Passenger and Driver apps to grow without becoming complex or unmanageable.
