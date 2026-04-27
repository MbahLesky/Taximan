# Taximan — MVP Scope

## 1. Purpose

This document defines the **Minimum Viable Product (MVP)** scope for Taximan. It clearly outlines what features will be included in the first version and what will be excluded to ensure fast, focused development.

The goal is to launch a **functional ride-booking system** with core features only.

---

## 2. MVP Objective

The MVP aims to:

* Enable passengers to request and track rides
* Enable drivers to receive and complete trips
* Provide real-time interaction between passenger and driver
* Validate the business model and user experience

---

## 3. In-Scope Features

### 3.1 Passenger Features

#### 1. Authentication

* Register (email and phone)
* Login
* Logout

#### 2. Location and Trip Booking

* Detect current location
* Enter pickup location
* Enter destination
* View route on map
* Schedule ride
* Ride sharing option

#### 3. Driver Matching

* Request a ride
* Find nearby drivers
* Assign driver

#### 4. Trip Tracking

* View driver location
* Track trip status
* See trip progress

#### 5. Payments

* Escrow payment option
* Cash payment

#### 6. Rating and Feedback

* Rate driver after trip
* Submit basic feedback

#### 7. Account and History

* View profile
* View trip history
* View trip details

---

### 3.2 Driver Features

#### 1. Authentication

* Register
* Login
* Logout

#### 2. Driver Onboarding

* Enter personal details
* Add vehicle details
* Upload required documents
* Verification status (pending/approved)

#### 3. Availability

* Toggle online/offline status
* Set availability days and time slots

#### 4. Booking Management

* Receive ride requests
* Accept or reject requests

#### 5. Trip Execution

* Navigate to pickup
* Mark arrival
* Start trip
* End trip

#### 6. Earnings and Records

* View completed trips
* View earnings summary

#### 7. Account

* View and edit profile
* View vehicle details

---

## 4. Core System Capabilities

* Real-time booking and trip updates
* Driver availability tracking
* Basic fare estimation
* Trip lifecycle management
* Firebase-based backend integration

---

## 5. Out-of-Scope Features (Not Included in MVP)

These features are intentionally excluded to keep development lean:

### Payments

* Mobile Money integration
* Card payments
* In-app wallet

### Advanced Ride Features

* Multi-stop trips
* Intercity rides

### Communication

* In-app chat
* In-app calling

### Promotions

* Promo codes
* Discounts
* Referral system

### Driver Features

* Driver subscriptions
* Advanced earnings analytics

### Admin Features

* Full admin dashboard
* Automated driver verification

### Offline Features

* Offline booking
* Offline trip execution

---

## 6. Constraints

* The system is **online-first**
* All critical actions require internet connection
* Firebase will handle backend and real-time data
* MVP should be simple, stable, and testable

---

## 7. Success Criteria

The MVP is considered successful if:

* A passenger can request a ride and complete a trip
* A driver can receive, accept, and complete a ride
* Trip status updates correctly in real time
* Basic payment (cash) works
* Users can view trip history and rate rides

---

## 8. Post-MVP Roadmap (Preview)

After validating the MVP, the following can be added:

* Mobile Money payments
* Push notifications refinement
* Admin dashboard
* Promotions and referrals
* Advanced pricing (surge pricing)
* Improved UI/UX

---

## 9. Summary

The Taximan MVP focuses strictly on **core ride-booking functionality**. By limiting scope, the project can be built faster, tested early, and improved based on real user feedback.