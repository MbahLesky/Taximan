# Taximan — Offline Strategy

## 1. Purpose

This document defines how offline behavior is handled in the Taximan MVP.

Taximan is designed as an **online-first application**, with limited offline capabilities to improve user experience without compromising real-time operations.

---

## 2. Offline Strategy Overview

Taximan uses a hybrid approach:

* **Cloud Firestore offline persistence** → for cached data
* **SharedPreferences** → for lightweight local storage
* **Network checks** → to control critical actions

---

## 3. Core Principle

**If an action affects a live trip → it must be online**

**If an action is read-only → it can be offline (cached)**

---

## 4. Offline Capabilities

## 4.1 Supported Offline Features

These features can work without internet using cached data:

### Passenger

* View profile
* View trip history
* View previous trip details
* View last known booking state
* Access app settings

### Driver

* View profile
* View vehicle info
* View earnings history
* View completed trips
* Access app settings

---

## 4.2 SharedPreferences Usage

Use SharedPreferences for:

* User session (basic flags, not auth token)
* Selected role (passenger/driver)
* App settings (theme, language)
* Last selected payment method
* Onboarding completion
* Cached UI preferences

---

## 4.3 Firestore Offline Persistence Usage

Use Firestore offline for:

* Cached user profile
* Cached trips
* Cached bookings
* Cached ratings
* Cached notifications

Firestore will:

* cache reads automatically
* queue writes (but we will restrict critical ones)

---

## 5. Restricted Offline Features

These actions must NOT work offline:

### Passenger

* Booking a ride
* Accepting fare proposals
* Cancelling ride after assignment
* Payment confirmation

### Driver

* Going online
* Accepting ride requests
* Proposing fare
* Starting trip
* Ending trip
* Updating availability during trip

---

## 6. Network Handling

## 6.1 Network Detection

The app must:

* detect internet connectivity
* listen for network changes
* update UI accordingly

Recommended:

* use a connectivity package
* expose network state via a provider

---

## 6.2 Offline UI Behavior

When offline:

* show “No Internet Connection” banner
* disable critical action buttons
* allow navigation through cached screens

---

## 7. Write Control Strategy

Firestore offline persistence can queue writes automatically.

For Taximan:

### Rule

**Do NOT allow critical writes to be queued offline**

Instead:

* check network before write
* block action if offline

---

## 8. Example Scenarios

## 8.1 Passenger Opens App Offline

Allowed:

* view profile
* view trip history

Blocked:

* request ride

---

## 8.2 Driver Tries to Go Online Offline

Result:

* action blocked
* show message: "Internet connection required"

---

## 8.3 Driver Loses Connection During Trip

Behavior:

* UI shows connection warning
* trip state remains unchanged
* driver cannot end trip until connection returns

---

## 8.4 Passenger Loses Connection During Tracking

Behavior:

* map freezes on last known location
* show "Reconnecting..." message
* resume updates when connection returns

---

## 9. Data Consistency Rules

* Critical data must always be written online
* Avoid conflicting states between passenger and driver
* Do not rely on queued writes for:

  * bookings
  * trips
  * payments

---

## 10. Performance Considerations

* Limit reliance on large cached collections
* Clear outdated cache when needed
* Avoid excessive Firestore reads offline

---

## 11. Error Handling

When offline:

* show clear error messages
* provide retry options
* do not silently fail critical actions

---

## 12. Future Enhancements (Optional)

If offline support becomes more important:

* introduce local database (e.g., Drift)
* implement sync engine
* handle conflict resolution

---

## 13. Summary

Taximan uses a controlled offline strategy:

* Firestore for cached reads
* SharedPreferences for lightweight data
* Strict online enforcement for critical actions

This ensures:

* real-time accuracy
* consistent state between passenger and driver
* reliable trip execution
