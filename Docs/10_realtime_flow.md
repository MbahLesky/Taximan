# Taximan — Real-Time Flow

## 1. Purpose

This document defines how real-time communication and synchronization work in the Taximan system.

Taxi apps depend heavily on real-time updates. This document ensures that passenger and driver apps stay synchronized at all times.

---

# 2. Real-Time Overview

Taximan uses:

* **Cloud Firestore (real-time listeners)**
* **Firebase Cloud Messaging (push notifications)**

### Rule

* Firestore → continuous updates
* FCM → alerts and wake-ups

---

# 3. Core Real-Time Flows

## 3.1 Booking Real-Time Flow

### Passenger Side

1. Passenger creates booking (`status: searching`)
2. Passenger listens to:

   * booking document changes

### Driver Side

1. Drivers listen for new bookings:

   * where `status = searching`
2. Driver receives request

### Flow Summary

```text
Passenger creates booking → Firestore updates → Drivers receive via listener → Driver responds → Booking updates → Passenger sees update
```

---

## 3.2 Driver Matching Flow (Real-Time)

### Step-by-Step

1. Booking created (`searching`)
2. Eligible drivers receive request
3. Driver:

   * Accepts OR
   * Rejects OR
   * Proposes fare
4. First valid accepted response:

   * assigns driver
   * updates booking
5. All other drivers stop seeing request

### Key Real-Time Events

* Booking status changes
* Driver assignment
* Fare proposals

---

## 3.3 Fare Proposal Flow

### Driver

* Creates proposal -> stored in `fare_proposals`

### Passenger

* Listens to proposals
* Sees proposal instantly

### Flow

```text
Driver proposes fare → Firestore write → Passenger listener updates UI → Passenger responds → Firestore update → Driver sees response
```

---

## 3.4 Driver Location Flow

This is the most sensitive part.

### Driver Side

* Sends location updates periodically
* Updates `driver_locations/{driverId}`

### Passenger Side

* Listens to assigned driver’s location

### Flow

```text
Driver moves → App updates location → Firestore updates → Passenger listener → Map updates
```

### Important Rules

* Update every 2–5 seconds (not every second)
* Only update when driver is:

  * online OR
  * in active trip

---

## 3.5 Trip Status Flow

### Status Updates

* `accepted`
* `driver_arriving`
* `arrived`
* `in_progress`
* `completed`
* `cancelled`

### Flow

```text
Driver action → Firestore update → Passenger listener → UI updates instantly
```

### Example

1. Driver taps "Arrived"
2. Firestore updates:

   * trip.status = arrived
3. Passenger app updates automatically

---

## 3.6 Payment Flow (Real-Time)

### Flow

1. Trip ends
2. Payment record created
3. Driver confirms payment
4. Firestore updates:

   * payment.status = paid
5. Passenger sees confirmation

---

## 3.7 Notification Flow

### Use FCM for:

* New ride request (driver)
* Driver assigned (passenger)
* Fare proposal
* Driver arrival
* Trip start
* Trip completion

### Flow

```text
Event occurs → Cloud Function triggers → FCM sent → Device receives → App updates / opens
```

---

# 4. Listener Strategy

## 4.1 Passenger App Listeners

Passenger should listen to:

* `bookings/{bookingId}`
* `trips/{tripId}`
* `driver_locations/{driverId}`

---

## 4.2 Driver App Listeners

Driver should listen to:

* available bookings
* assigned booking
* trip document

---

## 4.3 Important Rule

Do NOT:

* listen to entire collections blindly
* create too many listeners
* keep listeners active unnecessarily

Instead:

* listen only to relevant documents
* unsubscribe when not needed

---

# 5. Real-Time State Transitions

## Booking

```text
searching → proposal → accepted → driver_arriving → arrived → in_progress → completed
```

## Trip

```text
driver_arriving → arrived → in_progress → completed
```

---

# 6. Conflict Handling

## Problem

Multiple drivers may try to accept the same booking.

## Solution

Use:

* Firestore transactions OR
* Cloud Functions

Rule:

* First valid acceptance wins
* Others fail silently or get "request unavailable"

---

# 7. Timeout Handling

## Booking Timeout

* If no driver responds:

  * booking expires
  * status → cancelled

## Request Timeout (Driver)

* Driver must respond within X seconds (e.g., 15–30 sec)
* Otherwise request expires

---

# 8. Offline Handling in Real-Time

## Allowed

* Passive listening (cached)
* Viewing last known state

## Not Allowed

* Sending booking requests
* Accepting rides
* Updating trip status

---

# 9. Performance Considerations

* Throttle location updates
* Use indexed queries
* Avoid deep nested listeners
* Limit writes per second
* Use lightweight documents for real-time data

---

# 10. Security Considerations

* Only assigned driver can update trip
* Only passenger can cancel booking
* Only verified drivers receive requests
* Validate critical updates via Cloud Functions

---

# 11. Summary

Taximan real-time system is built on:

* Firestore listeners for continuous updates
* FCM for event-based alerts

Core principle:

**Write once → Sync everywhere instantly**

If this layer is done right, the app will feel fast, responsive, and reliable.
