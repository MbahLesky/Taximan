# Taximan — Screen List

## 1. Purpose

This document lists the main screens required for the Taximan MVP.

The screens are grouped by application, feature, and user flow to guide UI design and Flutter implementation.

---

# 2. Passenger App Screens

## 2.1 Startup and Authentication

### 1. Splash Screen

**Purpose:** Display app logo while checking authentication state.

### 2. Onboarding Screen

**Purpose:** Briefly introduce the app and its value.

### 3. Register Screen

**Purpose:** Allow passenger registration using email or phone.

### 4. Login Screen

**Purpose:** Allow existing passengers to sign in.

### 5. Forgot Password Screen

**Purpose:** Allow users to reset password.

---

## 2.2 Location and Trip Booking

### 6. Passenger Home Screen

**Purpose:** Main map screen where passenger starts a booking.

### 7. Route & Time Screen

**Purpose:** Allow passenger to choose pickup, destination, and pickup time.
Locations are limited to supported Bamenda places and can be selected through
current location, autocomplete, or a map pin style picker.

### 8. Ride Details Screen

**Purpose:** Capture ride sharing preference, passenger count, luggage,
payment method, proposed fare amount, and optional trip notes.

### 9. Driver Preference Screen

**Purpose:** Let passenger optionally search and select a preferred driver,
or skip the step and use automatic driver matching.

### 10. Trip Summary Screen

**Purpose:** Show route, distance, ETA, pickup time, ride sharing, passenger
and luggage details, fare pricing, payment method, selected driver, and
Firestore upload action.

---

## 2.3 Driver Matching

### 11. Searching for Driver Screen

**Purpose:** Show search/loading state while nearby drivers are being contacted.

### 12. Fare Proposal Screen

**Purpose:** Show driver fare proposal and allow passenger to accept or reject it.

### 13. Driver Assigned Screen

**Purpose:** Display assigned driver details, vehicle information, ETA, and trip status.

---

## 2.4 Trip Tracking

### 14. Driver En Route Screen

**Purpose:** Track driver movement toward pickup point.

### 15. Driver Arrived Screen

**Purpose:** Inform passenger that the driver has arrived.

### 16. Trip In Progress Screen

**Purpose:** Track trip route and progress after trip starts.

---

## 2.5 Payments

### 17. Payment Screen

**Purpose:** Display fare and allow passenger to confirm cash or escrow payment.

### 18. Payment Confirmation Screen

**Purpose:** Confirm payment status after trip completion.

---

## 2.6 Rating and Feedback

### 19. Rating Screen

**Purpose:** Allow passenger to rate driver after trip.

### 20. Feedback Screen

**Purpose:** Allow passenger to leave optional feedback or report issue.

---

## 2.7 Account and History

### 21. Passenger Profile Screen

**Purpose:** View and edit basic passenger profile.

### 22. Trip History Screen

**Purpose:** Show list of previous trips.

### 23. Trip Details Screen

**Purpose:** Show detailed information about a selected trip.

### 24. Settings Screen

**Purpose:** Manage preferences and basic app settings.

---

# 3. Driver App Screens

## 3.1 Startup and Authentication

### 1. Splash Screen

**Purpose:** Display app logo while checking authentication and verification state.

### 2. Onboarding Screen

**Purpose:** Introduce driver app and explain driver requirements.

### 3. Register Screen

**Purpose:** Allow driver registration.

### 4. Login Screen

**Purpose:** Allow existing drivers to sign in.

### 5. Forgot Password Screen

**Purpose:** Allow drivers to reset password.

---

## 3.2 Driver Onboarding

### 6. Driver Personal Information Screen

**Purpose:** Collect driver’s personal details.

### 7. Vehicle Details Screen

**Purpose:** Collect vehicle type, plate number, model, color, and capacity.

### 8. Document Upload Screen

**Purpose:** Upload required driver and vehicle documents.

### 9. Profile Photo Screen

**Purpose:** Upload driver profile photo.

### 10. Verification Pending Screen

**Purpose:** Inform driver that account is waiting for approval.

### 11. Verification Rejected Screen

**Purpose:** Inform driver of rejected verification and allow correction.

---

## 3.3 Availability

### 12. Driver Dashboard Screen

**Purpose:** Main screen showing online/offline status, map, today’s rides, and earnings summary.

### 13. Availability Schedule Screen

**Purpose:** Allow driver to set available days and time slots.

---

## 3.4 Booking Management

### 14. Incoming Ride Request Screen

**Purpose:** Show pickup, destination, estimated fare, and accept/reject actions.

### 15. Fare Proposal Screen

**Purpose:** Allow driver to submit a different fare proposal.

### 16. Request Timeout Screen

**Purpose:** Inform driver when a request expires.

---

## 3.5 Trip Execution

### 17. Navigate to Pickup Screen

**Purpose:** Guide driver to passenger pickup point.

### 18. Mark Arrival Screen

**Purpose:** Allow driver to mark arrival at pickup point.

### 19. Trip Start Screen

**Purpose:** Allow driver to start the trip.

### 20. Trip In Progress Screen

**Purpose:** Guide driver to destination and show active trip details.

### 21. Trip Completed Screen

**Purpose:** Show trip summary after trip ends.

---

## 3.6 Earnings and Records

### 22. Earnings Screen

**Purpose:** Show total, daily, and weekly earnings.

### 23. Driver Trip History Screen

**Purpose:** Show completed driver trips.

### 24. Driver Trip Details Screen

**Purpose:** Show full details of a selected trip.

---

## 3.7 Account

### 25. Driver Profile Screen

**Purpose:** View and edit driver profile.

### 26. Vehicle Information Screen

**Purpose:** View and update vehicle information.

### 27. Document Status Screen

**Purpose:** View document approval status.

### 28. Driver Settings Screen

**Purpose:** Manage app preferences and account settings.

---

# 4. Shared Screens

These screens may appear in both apps.

## 4.1 No Internet Screen / Banner

**Purpose:** Inform user that internet is required for critical actions.

## 4.2 Loading Screen

**Purpose:** Show loading state during network or system operations.

## 4.3 Empty State Screen

**Purpose:** Show when no data is available.

## 4.4 Error Screen

**Purpose:** Show recoverable and non-recoverable error states.

## 4.5 Notification Permission Screen

**Purpose:** Request permission for push notifications.

## 4.6 Location Permission Screen

**Purpose:** Request permission for location access.

---

# 5. MVP Screen Priority

## Phase 1 — Must Build First

### Passenger

* Splash Screen
* Register Screen
* Login Screen
* Passenger Home Screen
* Destination Search Screen
* Ride Summary Screen
* Searching for Driver Screen
* Driver Assigned Screen
* Trip In Progress Screen
* Payment Screen
* Rating Screen
* Trip History Screen

### Driver

* Splash Screen
* Register Screen
* Login Screen
* Driver Personal Information Screen
* Vehicle Details Screen
* Document Upload Screen
* Verification Pending Screen
* Driver Dashboard Screen
* Incoming Ride Request Screen
* Navigate to Pickup Screen
* Trip In Progress Screen
* Trip Completed Screen
* Earnings Screen

---

# 6. Summary

The MVP requires a clear set of passenger and driver screens that support the full ride-booking lifecycle.

The first build should focus on the core flow:

**Passenger books ride → Driver accepts → Trip starts → Trip ends → Payment → Rating**
