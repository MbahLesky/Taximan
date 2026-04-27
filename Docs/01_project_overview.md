# Taximan — Project Overview

## 1. Introduction

**Taximan** is a mobile vehicle-booking platform that connects passengers with nearby drivers for fast, reliable, and convenient transportation. The system consists of two separate mobile applications:

* **Taximan Passenger App** — for users who request rides
* **Taximan Driver App** — for drivers who accept and complete trips

Both applications are connected through a shared backend powered by Firebase.

---

## 2. Problem Statement

In many local environments, including Cameroon, transportation systems face several challenges:

* Difficulty finding available taxis quickly
* Lack of transparency in pricing
* Poor coordination between drivers and passengers
* No real-time tracking of trips
* Inefficient manual booking processes
* Difficulty locating taxis in remote areas or within residential quarters

These issues result in delays, uncertainty, and poor user experience.

---

## 3. Proposed Solution

Taximan provides a digital platform where:

* Passengers can easily request rides from their mobile devices
* Drivers can receive and manage ride requests in real time
* Trips are tracked live using GPS
* Pricing is estimated before booking
* Both parties have visibility and control throughout the trip
* Passengers can request rides directly from their current location or doorstep

The system aims to simplify transportation, improve efficiency, and enhance user trust.

---

## 4. Target Users

### 4.1 Passengers

* Individuals looking for quick and reliable transportation
* Students, workers, and general commuters
* Users with smartphones and internet access

### 4.2 Drivers

* Taxi drivers and vehicle owners
* Individuals looking to earn income through ride services
* Drivers with valid licenses and vehicles

---

## 5. Core Features

### 5.1 Passenger Features

1. Authentication
2. Location and Trip Booking
3. Driver Matching
4. Trip Tracking
5. Payments
6. Rating and Feedback
7. Account and History

### 5.2 Driver Features

1. Authentication
2. Driver Onboarding
3. Availability
4. Booking Management
5. Trip Execution
6. Earnings and Records
7. Account

---

## 6. MVP Objective

The goal of the MVP (Minimum Viable Product) is to deliver a functional system where:

* Passengers can register, request rides, and track trips
* Drivers can register, go online, accept bookings, and complete trips
* Trips are managed in real time using a shared backend
* Payments are handled simply (starting with cash)
* Basic rating and history features are available

The MVP focuses on **core ride-booking functionality**, excluding advanced features.

---

## 7. Tech Stack

### Mobile Applications

* Flutter (Passenger and Driver apps)

### State Management

* Riverpod

### Backend

* Firebase

### Firebase Services

* Firebase Authentication (user management)
* Cloud Firestore (database and real-time updates)
* Firebase Cloud Messaging (notifications)
* Firebase Storage (documents and images)
* Cloud Functions (backend logic)

### Maps and Location

* Google Maps Platform (Maps, Places, Directions APIs)

### Local Storage

* SharedPreferences (app settings and lightweight data)

---

## 8. System Architecture Overview

Taximan follows a **client–server architecture**:

* Two mobile clients (Passenger and Driver apps)
* Firebase backend handling authentication, data storage, and real-time communication
* Real-time listeners used for booking, driver matching, and trip tracking

The system is designed as **online-first**, with limited offline support.

---

## 9. Offline Strategy

Taximan uses a hybrid offline approach:

### Supported Offline

* Viewing cached data (profile, trip history)
* App settings and preferences (via SharedPreferences)

### Not Supported Offline (Requires Internet)

* Booking a ride
* Accepting ride requests
* Trip execution (start/end trip)
* Real-time tracking
* Payment confirmation

All critical operations require an active internet connection to ensure consistency and accuracy.

---

## 10. Future Expansion (Post-MVP)

After the MVP, the platform can be extended with:

* Mobile Money integration
* Card payments
* Scheduled rides
* Ride sharing (pooling)
* Driver subscription plans
* Admin dashboard for system management
* Promotions and referral systems
* Advanced analytics and reporting

---

## 11. Summary

Taximan is designed as a scalable, real-time transportation platform that bridges the gap between passengers and drivers. The MVP focuses on delivering a simple, reliable ride-booking experience while laying the foundation for future expansion.