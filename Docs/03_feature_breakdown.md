# Taximan — Feature Breakdown

## 1. Purpose

This document breaks down the core MVP features for the Taximan Passenger App and Taximan Driver App.

Each feature is described with its main purpose, expected functionality, and basic implementation notes.

---

# 2. Passenger Features

## 2.1 Authentication

### Purpose

Allow passengers to create and access their accounts securely.

### Functionalities

* Register with email and phone
* Login
* Logout
* Maintain user session
* Store basic profile information

### Notes

Firebase Authentication will be used for account management. Passenger profile data will be stored in Cloud Firestore.

---

## 2.2 Location and Trip Booking

### Purpose

Allow passengers to select their pickup point and destination, then request a ride.

### Functionalities

* Detect passenger’s current location
* Allow manual pickup entry
* Allow destination search
* Show pickup and destination on map
* Display route preview
* Show fare estimate, with option for drivers to propose their own price
* Request ride
* Schedule ride
* Select ride sharing option

### Notes

Google Maps Platform will handle maps, places, directions, and route display.

---

## 2.3 Driver Matching

### Purpose

Connect passengers with available drivers.

### Functionalities

* Search for nearby available drivers
* Match passenger with suitable driver
* Display driver details
* Display vehicle details
* Show estimated driver arrival time
* Allow passenger to cancel while searching

### Notes

Driver matching will depend on driver availability, location, and booking status.

---

## 2.4 Trip Tracking

### Purpose

Allow passengers to follow trip progress in real time.

### Functionalities

* Track driver location before pickup
* Show trip status updates
* Show route progress
* Notify passenger when driver arrives
* Notify passenger when trip starts
* Notify passenger when trip ends

### Notes

Firestore real-time listeners will be used for trip and location updates.

---

## 2.5 Payments

### Purpose

Allow passengers to pay for completed trips.

### Functionalities

* Select payment method
* Cash payment
* Escrow payment option
* View trip fare
* View payment status

### Notes

Cash payment will be supported in the MVP. Escrow payment can be represented in the system flow, but full payment gateway integration may come later depending on implementation capacity.

---

## 2.6 Rating and Feedback

### Purpose

Allow passengers to rate drivers and submit feedback after trips.

### Functionalities

* Rate driver after trip
* Submit optional comment
* Report issue after trip
* Store rating with trip record

### Notes

Ratings will help improve driver quality and trust.

---

## 2.7 Account and History

### Purpose

Allow passengers to manage their account and view previous rides.

### Functionalities

* View profile
* Edit basic profile details
* View trip history
* View trip details
* View payment history
* Manage basic app preferences

### Notes

Trip history should be readable from cached Firestore data when offline.

---

# 3. Driver Features

## 3.1 Authentication

### Purpose

Allow drivers to create and access their accounts securely.

### Functionalities

* Register
* Login
* Logout
* Maintain user session
* Store basic driver profile information

### Notes

Firebase Authentication will be used for driver account access.

---

## 3.2 Driver Onboarding

### Purpose

Collect driver and vehicle information before allowing drivers to operate.

### Functionalities

* Enter personal details
* Add vehicle details
* Upload required documents
* Upload profile photo
* View verification status
* Restrict access until approved

### Notes

Driver documents and images will be stored in Firebase Storage. Driver verification will be manual for the MVP.

---

## 3.3 Availability

### Purpose

Allow drivers to control when they are available to receive rides.

### Functionalities

* Toggle online/offline status
* Set availability days
* Set availability time slots
* Show current availability status
* Prevent unverified drivers from going online

### Notes

Only approved drivers should be allowed to go online and receive bookings.

---

## 3.4 Booking Management

### Purpose

Allow drivers to receive and respond to passenger booking requests.

### Functionalities

* Receive ride requests
* View pickup location
* View destination
* View estimated fare
* Accept ride request or submit a fare proposal
* Reject ride request
* Handle request timeout

---

## 3.5 Trip Execution

### Purpose

Allow drivers to complete the full ride process.

### Functionalities

* Navigate to passenger pickup point
* Mark arrival
* Start trip
* End trip
* Update trip status
* View trip summary

### Notes

Trip execution requires active internet connection because it affects live trip status.

---

## 3.6 Earnings and Records

### Purpose

Allow drivers to view completed trips and income.

### Functionalities

* View completed trips
* View daily earnings
* View weekly earnings
* View total earnings
* View trip income details

### Notes

Initial MVP can calculate earnings from completed trip records.

---

## 3.7 Account

### Purpose

Allow drivers to manage account and vehicle information.

### Functionalities

* View profile
* Edit basic profile details
* View vehicle details
* View document status
* Manage app preferences

### Notes

Some profile changes may require re-verification depending on the field changed.

---

# 4. Shared Feature Rules

## 4.1 Online-First Rule

Critical ride actions require internet connection:

* Booking a ride
* Accepting a ride
* Starting a trip
* Ending a trip
* Confirming payment
* Going online as driver

## 4.2 Offline Support

Offline support is limited to:

* Cached profile data
* Trip history
* Basic settings
* Last known app state

## 4.3 Real-Time Updates

Real-time updates are required for:

* Driver matching
* Driver location tracking
* Booking status
* Trip status
* Payment status

---

# 5. Summary

The Taximan MVP is built around 14 core features: 7 for passengers and 7 for drivers. Each feature should remain focused, simple, and aligned with the MVP scope.
