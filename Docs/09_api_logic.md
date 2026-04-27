# Taximan — API Logic

## 1. Purpose

This document defines the backend and application logic required for the Taximan MVP.

Although Taximan uses Firebase instead of a traditional REST API, the system still needs clear logic for booking creation, driver matching, fare proposals, trip execution, payment confirmation, ratings, and earnings.

---

# 2. Logic Layer Overview

Taximan uses:

* Flutter repositories for client-side Firebase interaction
* Cloud Firestore for real-time data
* Cloud Functions for critical backend operations
* Firebase Cloud Messaging for notifications

Critical actions should be validated through Cloud Functions or Firestore transactions where possible.

---

# 3. Authentication Logic

## 3.1 Passenger Registration

Flow:

1. Passenger enters name, email, phone, and password.
2. Firebase Auth creates user account.
3. Passenger profile is created in `users/{userId}`.
4. User is redirected to Passenger Home Screen.

Required Firestore data:

* `id`
* `fullName`
* `email`
* `phone`
* `role: passenger`
* `defaultPaymentMethod`
* `createdAt`

---

## 3.2 Driver Registration

Flow:

1. Driver enters name, email, phone, and password.
2. Firebase Auth creates driver account.
3. Driver profile is created in `drivers/{driverId}`.
4. Verification status is set to `pending`.
5. Driver is redirected to onboarding screens.

Required Firestore data:

* `id`
* `fullName`
* `email`
* `phone`
* `role: driver`
* `verificationStatus: pending`
* `availabilityStatus: offline`
* `isAvailable: false`
* `createdAt`

---

# 4. Driver Onboarding Logic

## 4.1 Add Vehicle

Flow:

1. Driver enters vehicle details.
2. Vehicle document is created in `vehicles`.
3. Vehicle is linked to driver by `driverId`.

---

## 4.2 Upload Documents

Flow:

1. Driver selects required documents.
2. Files are uploaded to Firebase Storage.
3. Document metadata is saved in `driver_documents`.
4. Document status is set to `pending`.

---

## 4.3 Verification

For MVP, verification is manual.

Rules:

* Driver cannot go online unless `verificationStatus = approved`.
* Driver cannot receive ride requests unless approved and online.

---

# 5. Driver Availability Logic

## 5.1 Go Online

Conditions:

* Driver must be authenticated.
* Driver must be approved.
* Driver must have internet connection.
* Driver must have location permission enabled.

Flow:

1. Driver taps “Go Online”.
2. App checks verification status.
3. App checks network and location permission.
4. Driver document is updated:

   * `availabilityStatus: online`
   * `isAvailable: true`
5. Driver location starts updating.

---

## 5.2 Go Offline

Flow:

1. Driver taps “Go Offline”.
2. Driver document is updated:

   * `availabilityStatus: offline`
   * `isAvailable: false`
3. Driver location updates stop.
4. Driver should no longer receive new requests.

---

# 6. Fare Estimation Logic

## 6.1 Basic Fare Formula

Initial MVP formula:

```text
estimatedFare = baseFare + (distanceKm * pricePerKm)
```

Example:

```text
baseFare = 500
pricePerKm = 250
distanceKm = 4
estimatedFare = 500 + (4 * 250) = 1500
```

## 6.2 Required Inputs

* Pickup location
* Destination location
* Distance in kilometers
* Estimated duration

## 6.3 Fare Rules

* Fare is estimated before booking.
* Final fare may be updated if driver proposes a different fare and passenger accepts.
* Surge pricing is not included in MVP.

---

# 7. Booking Creation Logic

## 7.1 Create Booking

Flow:

1. Passenger enters pickup location, destination, pickup time, ride sharing option, and payment method.
2. System calculates estimated fare.
3. Booking document is created in `bookings`.
4. Booking status is set to `searching`.
5. Driver matching begins.

Required booking fields:

* `passengerId`
* `pickupLocation`
* `destinationLocation`
* `pickupTimeType`
* `scheduledPickupTime`
* `isRideSharing`
* `distanceKm`
* `estimatedDurationMinutes`
* `estimatedFare`
* `paymentMethod`
* `paymentStatus: pending`
* `status: searching`

---

# 8. Driver Matching Logic

## 8.1 Find Nearby Drivers

Conditions:

Drivers are eligible if:

* `verificationStatus = approved`
* `availabilityStatus = online`
* `isAvailable = true`
* Driver is within search radius
* Driver has no active trip

## 8.2 Matching Flow

1. System searches for eligible drivers.
2. Booking request is sent to nearby drivers.
3. Drivers can accept, reject, or propose new fare.
4. First valid accepted response assigns the driver.
5. Driver becomes unavailable.
6. Booking status changes to `accepted`.
7. Trip record is created.

## 8.3 No Driver Found

If no drivers are available:

* Show “No drivers available”
* Allow passenger to retry
* Keep booking cancellable

---

# 9. Fare Proposal Logic

## 9.1 Driver Proposes Fare

Flow:

1. Driver receives ride request.
2. Driver selects “Propose Fare”.
3. Driver enters proposed fare.
4. Proposal is saved in `fare_proposals`.
5. Booking status changes to `proposal`.
6. Passenger receives proposal.

---

## 9.2 Passenger Accepts Proposal

Flow:

1. Passenger accepts proposed fare.
2. Proposal status changes to `accepted`.
3. Booking `finalFare` is updated.
4. Driver is assigned.
5. Booking status changes to `accepted`.
6. Trip is created.

---

## 9.3 Passenger Rejects Proposal

Flow:

1. Passenger rejects proposed fare.
2. Proposal status changes to `rejected`.
3. Booking returns to `searching`.
4. System continues searching for drivers.

---

# 10. Trip Creation Logic

A trip is created when:

* A driver accepts a booking directly, or
* A passenger accepts a driver fare proposal.

Trip fields are copied from booking:

* `bookingId`
* `passengerId`
* `driverId`
* `vehicleId`
* `pickupLocation`
* `destinationLocation`
* `estimatedFare`
* `finalFare`
* `paymentMethod`
* `paymentStatus`
* `status: driver_arriving`

---

# 11. Trip Execution Logic

## 11.1 Driver Arriving

After acceptance:

* Trip status = `driver_arriving`
* Booking status = `driver_arriving`
* Passenger listens to driver location updates

---

## 11.2 Driver Arrived

Flow:

1. Driver reaches pickup.
2. Driver taps “Arrived”.
3. Trip status updates to `arrived`.
4. Booking status updates to `arrived`.
5. Passenger is notified.

---

## 11.3 Start Trip

Conditions:

* Driver must be assigned to the trip.
* Trip status must be `arrived`.
* Internet connection is required.

Flow:

1. Driver taps “Start Trip”.
2. Trip status updates to `in_progress`.
3. Booking status updates to `in_progress`.
4. Start timestamp is recorded.

---

## 11.4 End Trip

Conditions:

* Trip status must be `in_progress`.
* Internet connection is required.

Flow:

1. Driver taps “End Trip”.
2. Final fare is confirmed.
3. Trip status updates to `completed`.
4. Booking status updates to `completed`.
5. Payment record is created or updated.
6. Earnings record is created.
7. Driver availability is set back to `online` and `isAvailable: true`.

---

# 12. Payment Logic

## 12.1 Cash Payment

Flow:

1. Trip ends.
2. Passenger pays driver physically.
3. Driver confirms cash received.
4. Payment status changes to `paid`.
5. Trip payment status changes to `paid`.

---

## 12.2 Escrow Payment

For MVP, escrow can exist as a selected method, but full real payment integration can be delayed.

Flow placeholder:

1. Passenger selects escrow.
2. Payment status remains `pending`.
3. System marks escrow flow for future gateway integration.

---

# 13. Earnings Logic

Earnings are created after trip completion.

## 13.1 Formula

```text
commissionAmount = finalFare * commissionRate
netAmount = finalFare - commissionAmount
```

Default commission rate:

```text
commissionRate = 0.15
```

## 13.2 Earnings Record

Create record in `earnings` with:

* `driverId`
* `tripId`
* `bookingId`
* `grossAmount`
* `commissionRate`
* `commissionAmount`
* `netAmount`
* `paymentMethod`
* `status`

---

# 14. Rating Logic

Flow:

1. Trip is completed.
2. Passenger rates driver.
3. Rating is saved in `ratings`.
4. Driver `ratingAverage` and `ratingCount` are updated.

Rules:

* One rating per trip.
* Rating should be between 1 and 5.
* Feedback comment is optional.

---

# 15. Cancellation Logic

## 15.1 Passenger Cancels

Allowed when:

* Booking status is `searching`
* Booking status is `proposal`
* Trip has not started

Flow:

1. Passenger cancels.
2. Booking status changes to `cancelled`.
3. Trip status changes to `cancelled` if trip already exists.
4. Driver is released if assigned.

---

## 15.2 Driver Cancels

Allowed before trip starts.

Flow:

1. Driver cancels.
2. Booking status changes to `cancelled` or returns to `searching`.
3. Passenger is notified.
4. Driver is released.

---

# 16. Notification Logic

Notifications should be triggered for:

* Booking request received
* Driver assigned
* Fare proposal received
* Proposal accepted/rejected
* Driver arrived
* Trip started
* Trip completed
* Payment confirmed

---

# 17. Network Rules

Critical operations must check internet connection before execution:

* Create booking
* Accept booking
* Submit fare proposal
* Accept proposal
* Start trip
* End trip
* Confirm payment
* Go online as driver

If offline:

* Show error message
* Block action
* Do not queue critical write

---

# 18. Summary

Taximan API logic is built around clear real-time flows:

**Register → Book Ride → Match Driver → Execute Trip → Pay → Rate → Record Earnings**

All critical actions must be validated, synchronized, and protected from offline conflicts.
