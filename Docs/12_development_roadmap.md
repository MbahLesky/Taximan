# Taximan — Development Roadmap

## 1. Purpose

This document defines the step-by-step development roadmap for the Taximan MVP.

It guides implementation across the Passenger App, Driver App, Firebase backend, and shared project documentation.

---

## 2. Development Approach

Taximan will be built using a phased approach:

1. Plan and document first
2. Build UI with dummy data
3. Add Firebase integration
4. Add real-time ride logic
5. Test complete passenger-driver flow
6. Polish and prepare MVP release

---

# 3. Phase 1 — Project Foundation

## Goal

Set up the project structure and technical foundation.

## Tasks

* Create root `taximan/` folder
* Create shared `docs/` folder
* Create `taximan_passenger/` Flutter app
* Create `taximan_driver/` Flutter app
* Connect both apps to the same Firebase project
* Set up Git/GitHub repository
* Add base README
* Configure Flutter theme
* Configure routing with GoRouter
* Configure Riverpod
* Add SharedPreferences
* Add network status provider

## Deliverables

* Project folder structure ready
* Passenger app boots successfully
* Driver app boots successfully
* Firebase initialized
* Basic navigation working

---

# 4. Phase 2 — Authentication

## Goal

Allow passengers and drivers to register, login, and maintain sessions.

## Passenger Tasks

* Build splash screen
* Build onboarding screen
* Build register screen
* Build login screen
* Build forgot password screen
* Create passenger profile in Firestore after registration

## Driver Tasks

* Build splash screen
* Build onboarding screen
* Build register screen
* Build login screen
* Build forgot password screen
* Create driver profile in Firestore after registration

## Deliverables

* Passenger authentication working
* Driver authentication working
* Profile documents created correctly
* Auth routing working

---

# 5. Phase 3 — Driver Onboarding

## Goal

Allow drivers to submit required profile, vehicle, and document information.

## Tasks

* Build driver personal information screen
* Build vehicle details screen
* Build document upload screen
* Build profile photo upload screen
* Save vehicle details to Firestore
* Upload documents to Firebase Storage
* Save document metadata to Firestore
* Show verification pending screen
* Block unverified drivers from going online

## Deliverables

* Driver onboarding completed
* Driver verification status handled
* Vehicle and document data stored correctly

---

# 6. Phase 4 — Passenger Booking UI

Status: Complete in the passenger app. The UI now reads passenger profile,
recent bookings, available drivers, driver details, fare proposals, and trip
history from Firebase-backed providers instead of local dummy data.

## Goal

Build the passenger ride-booking experience and connect it to persisted data.

## Tasks

* Build passenger home map screen
* Add Route & Time screen for pickup, destination, and pickup time
* Add Ride Details screen for sharing, passengers, luggage, payment, fare, and notes
* Add Driver Preference screen for optional driver selection
* Add ride summary screen
* Show estimated fare, distance, ETA, and route preview
* Add ride sharing option
* Add payment method selection
* Build searching for driver screen
* Build fare proposal screen
* Build driver assigned screen

## Deliverables

* Complete passenger booking UI flow
* Navigation between booking screens working
* Firebase-backed booking data displayed correctly

---

# 7. Phase 5 — Driver Operations UI

## Goal

Build the driver work dashboard and trip request flow using dummy/mock data first.

## Tasks

* Build driver dashboard
* Add online/offline toggle
* Add availability schedule screen
* Build incoming ride request screen
* Build fare proposal screen
* Build request timeout screen
* Build navigate to pickup screen
* Build mark arrival screen
* Build trip start screen
* Build trip in progress screen
* Build trip completed screen

## Deliverables

* Complete driver operation UI flow
* Driver can simulate receiving and completing a ride
* Mock data displayed correctly

---

# 8. Phase 6 — Firebase Data Integration

## Goal

Connect UI flows to Firebase data.

## Tasks

* Create Firestore repositories
* Create models for:

  * user
  * driver
  * vehicle
  * booking
  * trip
  * payment
  * rating
  * earning
  * notification
* Implement booking creation
* Implement driver availability updates
* Implement trip document creation
* Implement payment record creation
* Implement rating submission
* Implement earnings creation
* Add Firestore indexes where required

## Deliverables

* App reads and writes real Firestore data
* Passenger booking data saved
* Driver availability saved
* Trip data saved
* Payment, rating, and earnings records saved

---

# 9. Phase 7 — Real-Time Logic

## Goal

Make passenger and driver apps communicate in real time.

## Tasks

* Add passenger booking listener
* Add driver incoming request listener
* Add fare proposal listener
* Add assigned driver listener
* Add trip status listener
* Add driver location listener
* Add driver location updates
* Throttle driver location writes
* Handle request timeout
* Handle cancellation
* Handle first-driver-accepts logic using transaction or Cloud Function

## Deliverables

* Passenger can create ride request
* Driver receives ride request
* Driver can accept, reject, or propose fare
* Passenger sees driver updates live
* Trip status updates sync across apps

---

# 10. Phase 8 — Trip Execution

## Goal

Complete the full ride lifecycle.

## Tasks

* Driver marks arrival
* Driver starts trip
* Driver ends trip
* Passenger sees each status update
* Payment screen appears after trip completion
* Driver confirms cash payment
* Earnings record is generated
* Passenger rates driver
* Trip appears in history

## Deliverables

* End-to-end ride flow working
* Booking and trip statuses update correctly
* Payment and earnings records created
* Rating flow works

---

# 11. Phase 9 — Offline and Error Handling

## Goal

Make the app stable under poor network conditions.

## Tasks

* Add no-internet banner
* Disable critical buttons offline
* Allow cached history/profile viewing
* Show retry options
* Handle failed Firebase writes
* Handle location permission errors
* Handle notification permission errors
* Handle no-driver-found state
* Handle timeout state

## Deliverables

* Online-first behavior enforced
* Critical actions blocked offline
* User-friendly error states added

---

# 12. Phase 10 — Notifications

## Goal

Add push notifications for important ride events.

## Tasks

* Configure Firebase Cloud Messaging
* Save device tokens
* Trigger ride request notifications
* Trigger driver assigned notification
* Trigger fare proposal notification
* Trigger driver arrived notification
* Trigger trip started/completed notifications
* Store notification records in Firestore

## Deliverables

* Push notifications working
* Notification records stored
* Users receive key ride alerts

---

# 13. Phase 11 — Testing and Polish

## Goal

Prepare MVP for real testing.

## Tasks

* Test passenger registration
* Test driver registration
* Test driver onboarding
* Test ride booking
* Test fare proposal
* Test trip execution
* Test payment confirmation
* Test rating
* Test history
* Test offline behavior
* Fix UI issues
* Fix state management bugs
* Improve empty/loading/error states

## Deliverables

* Stable MVP build
* Complete passenger-driver test flow
* Ready for pilot users

---

# 14. Recommended Build Order

Build in this exact order:

1. Project foundation
2. Authentication
3. Driver onboarding
4. Passenger booking UI
5. Driver operation UI
6. Firebase integration
7. Real-time sync
8. Trip execution
9. Offline handling
10. Notifications
11. Testing and polish

---

# 15. MVP Completion Checklist

Taximan MVP is complete when:

* Passenger can register and login
* Driver can register and login
* Driver can complete onboarding
* Driver can go online after approval
* Passenger can create a booking
* Driver can receive booking
* Driver can accept, reject, or propose fare
* Passenger can accept or reject fare proposal
* Driver can start and complete trip
* Passenger can pay using cash or escrow placeholder
* Passenger can rate driver
* Driver earnings are recorded
* Trip history works
* Critical actions are blocked offline

---

# 16. Summary

This roadmap breaks Taximan MVP development into clear, manageable phases.

Each phase should be completed and tested before moving to the next one. This keeps the project clean, reduces bugs, and makes it easier for AI agents to build consistently.
