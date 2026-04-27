# Taximan — System Architecture

## 1. Purpose

This document defines the overall system architecture for the Taximan MVP, including application structure, backend services, data flow, and real-time interactions.

---

## 2. Architecture Overview

Taximan follows a **client–server architecture** with real-time capabilities.

### Components

* **Passenger Mobile App (Flutter)**
* **Driver Mobile App (Flutter)**
* **Firebase Backend**
* **Google Maps Platform**

---

## 3. High-Level Architecture

```
Passenger App  ─────┐
                   │
                   │
                Firebase Backend
                   │
                   │
Driver App     ────┘
```

Both apps communicate directly with Firebase for:

* Authentication
* Database operations
* Real-time updates
* Notifications

---

## 4. Client Applications

## 4.1 Passenger App

Handles:

* User authentication
* Trip booking
* Driver tracking
* Payments
* Ratings
* History

## 4.2 Driver App

Handles:

* Authentication
* Driver onboarding
* Availability (online/offline)
* Booking requests
* Trip execution
* Earnings tracking

---

## 5. Backend (Firebase)

## 5.1 Firebase Authentication

Handles:

* Passenger login/signup
* Driver login/signup
* Session management

---

## 5.2 Cloud Firestore

Acts as the **main database**.

Stores:

* Users (passengers)
* Drivers
* Vehicles
* Bookings
* Trips
* Payments
* Ratings
* Earnings

Provides:

* Real-time listeners
* Offline persistence (limited use)

---

## 5.3 Firebase Cloud Messaging (FCM)

Handles:

* Ride request notifications
* Driver assigned alerts
* Trip status updates
* System alerts

---

## 5.4 Firebase Storage

Stores:

* Driver documents
* Profile photos
* Vehicle images

---

## 5.5 Cloud Functions

Handles backend logic such as:

* Driver matching
* Fare calculation
* Booking state transitions
* Notifications triggering
* Commission calculations (future)

---

## 6. Maps and Location

## Google Maps Platform

Used for:

* Map display
* Location detection
* Place search (pickup/destination)
* Route calculation
* Distance and ETA

---

## 7. Data Flow

## 7.1 Booking Flow

1. Passenger creates booking
2. Booking stored in Firestore
3. Available drivers receive request (via listeners/FCM)
4. Driver responds (accept/reject/propose fare)
5. Booking updated in Firestore
6. Passenger receives update

---

## 7.2 Trip Flow

1. Driver accepts booking
2. Trip status updates to "driver_arriving"
3. Driver reaches pickup → status "arrived"
4. Driver starts trip → status "in_progress"
5. Driver ends trip → status "completed"

---

## 7.3 Location Tracking Flow

1. Driver app updates location periodically
2. Location stored in Firestore (or transient state)
3. Passenger app listens to updates
4. Map updates in real time

---

## 8. Real-Time Communication

Real-time updates are handled using:

* Firestore listeners (primary)
* Firebase Cloud Messaging (for push alerts)

Used for:

* Booking updates
* Driver matching
* Trip status changes
* Location updates

---

## 9. Offline Strategy

## Supported

* Cached reads (profile, history)
* Local settings (SharedPreferences)

## Not Supported

* Booking
* Driver matching
* Trip execution
* Payment

System enforces **online-first behavior**.

---

## 10. Security Overview

* Firebase Authentication for identity
* Firestore security rules to restrict data access
* Drivers must be verified before going online
* Sensitive operations validated via backend logic

---

## 11. Scalability Considerations

* Firestore supports real-time scaling
* Cloud Functions handle backend logic
* Stateless mobile clients
* Modular feature structure

---

## 12. Future Architecture Extensions

* Admin dashboard (React + Firebase)
* Payment gateway integration
* Advanced matching algorithms
* Analytics and reporting services
* Dedicated microservices (if scaling beyond Firebase)

---

## 13. Summary

Taximan uses a **real-time, online-first architecture** powered by Firebase.

Both passenger and driver apps operate independently but are synchronized through a shared backend, ensuring consistent data, real-time updates, and scalable operations.
