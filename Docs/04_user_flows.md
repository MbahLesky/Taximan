# Taximan — User Flows

## 1. Purpose

This document defines the complete user flows for both passengers and drivers in the Taximan MVP.

It describes how users interact with the system from start to finish, including booking, matching, and trip execution.

---

# 2. Passenger Flow

## 2.1 Authentication Flow

**Open App → Onboarding (optional) → Register/Login → Access Home Screen**

---

## 2.2 Ride Booking Flow

**Step 1: Open Home Screen**

* App loads map
* Detect current location

**Screen 1: Plan Route**

* Select pickup using current location, Bamenda autocomplete, or map pin
* Select destination using the same three methods
* Choose pickup time: now or a scheduled current/future date and time

**Screen 2: Ride Details**

* Choose whether ride sharing is allowed
* Enter passenger count and luggage details
* Select payment method
* Propose an amount of pay
* Add optional notes for the driver

**Screen 3: Driver Preference**

* Search and select an available driver to propose the trip to
* Or skip driver selection and allow automatic matching

**Screen 4: Trip Summary**

* Display route on map
* Show pickup, destination, date/time, ride sharing, passengers, luggage,
  payment method, proposed fare, selected driver, distance, and ETA
* Passenger confirms booking request
* Booking is uploaded to Firestore in the `bookings` collection

---

## 2.3 Driver Matching Flow

**Step 5: Searching for Driver**

* System searches for nearby available drivers
* Booking request is sent to drivers

**Step 6: Driver Interaction**

* Driver can:

  * Accept ride
  * Reject ride
  * Propose a different fare

**Step 7: Passenger Decision (if proposal exists)**

* Passenger can:

  * Accept proposed fare
  * Reject and continue searching
  * Cancel ride

**Step 8: Driver Assigned**

* Driver is confirmed
* Passenger sees:

  * Driver details
  * Vehicle details
  * Estimated arrival time

---

## 2.4 Pre-Trip Flow

**Step 9: Driver En Route**

* Passenger tracks driver in real time

**Step 10: Driver Arrival**

* Driver marks "Arrived"
* Passenger is notified

---

## 2.5 Trip Execution Flow

**Step 11: Start Trip**

* Driver starts trip
* Status changes to "In Progress"

**Step 12: During Trip**

* Passenger tracks route progress

**Step 13: End Trip**

* Driver ends trip
* Final fare is confirmed

---

## 2.6 Post-Trip Flow

**Step 14: Payment**

* Passenger pays (cash or escrow)

**Step 15: Rating and Feedback**

* Passenger rates driver
* Passenger can leave feedback

**Step 16: Trip Stored**

* Trip is saved in history

---

# 3. Driver Flow

## 3.1 Authentication & Onboarding Flow

**Open App → Register/Login → Complete Profile → Add Vehicle → Upload Documents → Await Approval**

---

## 3.2 Availability Flow

**Step 1: Driver Opens App**

* Driver lands on dashboard

**Step 2: Toggle Availability**

* Driver switches:

  * Offline → Online
* System marks driver as available

---

## 3.3 Booking Management Flow

**Step 3: Receive Ride Request**

* Driver gets notification
* Request shows:

  * Pickup location
  * Destination
  * Estimated fare

**Step 4: Driver Decision**

* Driver can:

  * Accept ride
  * Reject ride
  * Propose a new fare

**Step 5: Wait for Passenger Response (if proposal made)**

* Passenger accepts or rejects proposal

---

## 3.4 Trip Execution Flow

**Step 6: Navigate to Pickup**

* Driver follows map to passenger

**Step 7: Arrival**

* Driver marks "Arrived"

**Step 8: Start Trip**

* Driver starts trip

**Step 9: During Trip**

* Driver follows route to destination

**Step 10: End Trip**

* Driver ends trip
* Fare is finalized

---

## 3.5 Post-Trip Flow

**Step 11: Earnings Update**

* Trip amount is recorded
* Earnings updated

**Step 12: Trip Stored**

* Trip added to history

---

# 4. Booking Lifecycle

This describes the system-level flow.

**draft → searching → proposal(optional) → accepted → driver_arriving → arrived → in_progress → completed / cancelled**

---

# 5. Trip Lifecycle

**accepted → driver_arriving → arrived → trip_started → trip_completed**

---

# 6. Cancellation Flow

## Passenger Cancellation

* Allowed during:

  * Searching
  * Before trip starts

## Driver Cancellation

* Allowed before trip starts

## System Behavior

* Update booking status to "cancelled"
* Notify both parties
* Release driver back to available pool

---

# 7. Error & Edge Cases

* No drivers available → show retry option
* Driver rejects request → continue searching
* Passenger rejects proposal → continue searching
* Network loss → block critical actions
* Driver inactive → auto-cancel request
* Timeout → request expires

---

# 8. Real-Time Interaction Points

Real-time updates are required for:

* Driver availability updates
* Booking status changes
* Driver location tracking
* Trip status updates
* Fare negotiation responses

---

# 9. Summary

The Taximan system revolves around a structured flow:

**Passenger requests → Driver responds → Trip executed → Payment → Feedback**

This flow must remain fast, reliable, and synchronized across both apps.
