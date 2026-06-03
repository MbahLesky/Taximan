# Taximan — Notification Flow

## 1. Purpose

This document defines how notifications are handled in the Taximan system.

Notifications ensure that passengers and drivers are informed of important events even when the app is in the background or closed.

---

## 2. Notification System Overview

Taximan uses:

* **Firebase Cloud Messaging (FCM)** → push notifications
* **Firestore (`notifications` collection)** → notification history

---

## 3. Notification Types

## 3.1 Passenger Notifications

* Driver assigned
* Fare proposal received
* Proposal accepted/rejected
* Driver arriving
* Driver arrived
* Trip started
* Trip completed
* Payment confirmed

---

## 3.2 Driver Notifications

* New ride request
* Fare proposal response
* Ride cancelled
* Trip started (confirmation)
* Payment confirmed

---

## 4. Notification Triggers

## 4.1 New Ride Request (Driver)

### Trigger

* Passenger creates booking

### Action

* Send notification to nearby drivers

### Payload

```json
{
  "title": "New Ride Request",
  "body": "A passenger nearby needs a ride",
  "type": "new_booking",
  "bookingId": "booking_id"
}
```

---

## 4.2 Driver Assigned (Passenger)

### Trigger

* Driver accepts ride

### Action

* Notify passenger

```json
{
  "title": "Driver Assigned",
  "body": "Your driver is on the way",
  "type": "driver_assigned",
  "bookingId": "booking_id"
}
```

---

## 4.3 Fare Proposal (Passenger)

### Trigger

* Driver proposes a fare

### Action

* Notify passenger instantly

```json
{
  "title": "New Fare Proposal",
  "body": "Driver proposed a new fare",
  "type": "fare_proposals",
  "bookingId": "booking_id"
}
```

---

## 4.4 Proposal Response (Driver)

### Trigger

* Passenger accepts/rejects proposal

### Action

* Notify driver

```json
{
  "title": "Proposal Update",
  "body": "Passenger responded to your proposal",
  "type": "proposal_response",
  "bookingId": "booking_id"
}
```

---

## 4.5 Driver Arriving (Passenger)

### Trigger

* Driver is heading to pickup

```json
{
  "title": "Driver is Coming",
  "body": "Your driver is on the way",
  "type": "driver_arriving",
  "tripId": "trip_id"
}
```

---

## 4.6 Driver Arrived (Passenger)

### Trigger

* Driver marks "Arrived"

```json
{
  "title": "Driver Arrived",
  "body": "Your driver has arrived",
  "type": "driver_arrived",
  "tripId": "trip_id"
}
```

---

## 4.7 Trip Started (Passenger)

### Trigger

* Driver starts trip

```json
{
  "title": "Trip Started",
  "body": "Your trip has begun",
  "type": "trip_started",
  "tripId": "trip_id"
}
```

---

## 4.8 Trip Completed (Passenger + Driver)

### Trigger

* Driver ends trip

```json
{
  "title": "Trip Completed",
  "body": "Your trip is complete",
  "type": "trip_completed",
  "tripId": "trip_id"
}
```

---

## 4.9 Payment Confirmation

### Trigger

* Payment confirmed

```json
{
  "title": "Payment Confirmed",
  "body": "Payment received successfully",
  "type": "payment_confirmed",
  "tripId": "trip_id"
}
```

---

## 4.10 Ride Cancelled

### Trigger

* Passenger or driver cancels ride

```json
{
  "title": "Ride Cancelled",
  "body": "The ride has been cancelled",
  "type": "ride_cancelled",
  "bookingId": "booking_id"
}
```

---

## 5. Notification Delivery Flow

```text
Event → Firestore Update → Cloud Function Trigger → FCM Push → Device → App Handles
```

---

## 6. In-App Notification Handling

When app is **foreground**:

* show in-app banner/snackbar
* update UI directly

When app is **background/closed**:

* show push notification
* tapping opens relevant screen

---

## 7. Deep Linking

Each notification should navigate user to the correct screen.

Examples:

* `bookingId` → Booking details screen
* `tripId` → Trip tracking screen
* `payment` → Payment confirmation screen

---

## 8. Notification Storage

Store all notifications in:

`notifications/{notificationId}`

Fields:

* userId
* title
* body
* type
* relatedId
* isRead
* createdAt

---

## 9. Read / Unread Logic

* New notifications → `isRead = false`
* When opened → update to `true`
* Show badge count in app

---

## 10. Priority Rules

High priority (instant):

* New ride request
* Driver assigned
* Fare proposal
* Trip status updates

Medium priority:

* Payment confirmation
* Ride cancelled

Low priority:

* History / summary notifications (future)

---

## 11. Performance Considerations

* Avoid sending duplicate notifications
* Use Cloud Functions to centralize logic
* Send only relevant notifications to users
* Keep payload lightweight

---

## 12. Summary

Notifications in Taximan ensure that both passenger and driver stay informed in real time.

Core flow:

**Event happens → Notification sent → User informed instantly**

This improves responsiveness, reduces missed actions, and enhances overall experience.
