# Taximan — Error Handling

## 1. Purpose

This document defines how errors and edge cases are handled across the Taximan system.

Proper error handling ensures the app remains stable, predictable, and user-friendly under all conditions.

---

## 2. Error Handling Principles

Taximan follows these core rules:

* Never fail silently
* Always inform the user clearly
* Provide recovery options when possible
* Keep messages simple and actionable
* Prevent invalid operations

---

## 3. Error Categories

## 3.1 Network Errors

Occurs when:

* No internet connection
* Poor connection
* Request timeout

### Handling

* Show persistent banner:

  * **"No internet connection"**
* Disable critical actions:

  * booking
  * accepting ride
  * starting/ending trip
* Provide retry button where applicable

---

## 3.2 Authentication Errors

Occurs when:

* Invalid login credentials
* Expired session
* Unauthorized access

### Handling

* Show message:

  * **"Invalid email or password"**
  * **"Session expired. Please login again"**
* Redirect to login if session invalid

---

## 3.3 Location Errors

Occurs when:

* Location permission denied
* GPS unavailable
* Location not accurate

### Handling

* Show prompt:

  * **"Location access is required to use this feature"**
* Provide action:

  * Open device settings
* Disable booking if location unavailable

---

## 3.4 Booking Errors

Occurs when:

* No drivers available
* Booking request fails
* Booking times out

### Handling

* Show message:

  * **"No drivers available nearby. Try again"**
* Provide:

  * Retry button
  * Cancel option

---

## 3.5 Driver Matching Errors

Occurs when:

* All drivers reject request
* Request expires
* Multiple conflicts

### Handling

* Automatically continue searching OR
* Show message:

  * **"Unable to find a driver. Please try again"**

---

## 3.6 Fare Proposal Errors

Occurs when:

* Proposal expires
* Driver cancels
* Passenger delays response

### Handling

* Show message:

  * **"This offer is no longer available"**
* Return to searching state

---

## 3.7 Trip Execution Errors

Occurs when:

* Driver tries to start trip too early
* Driver tries to end trip offline
* Trip state mismatch

### Handling

* Validate before action
* Show message:

  * **"You must arrive before starting the trip"**
  * **"Internet connection required to complete this action"**

---

## 3.8 Payment Errors

Occurs when:

* Payment not confirmed
* Payment mismatch
* Escrow failure (future)

### Handling

* Show message:

  * **"Payment not confirmed"**
* Allow retry
* Keep payment status pending until confirmed

---

## 3.9 Data Errors

Occurs when:

* Missing fields
* Corrupt data
* Firestore read/write failure

### Handling

* Show fallback UI:

  * **"Something went wrong. Please try again"**
* Log error
* Retry fetch

---

## 3.10 Notification Errors

Occurs when:

* Notification not delivered
* Notification delayed

### Handling

* Do not rely solely on notifications
* Always sync via Firestore listeners
* Notifications act as support, not source of truth

---

# 4. UI Error States

## 4.1 Error Screen

Used for major failures.

Should include:

* Title
* Short explanation
* Retry button

---

## 4.2 Inline Errors

Used in forms and small interactions.

Examples:

* Invalid email
* Required field missing

---

## 4.3 Snackbars / Banners

Used for temporary alerts.

Examples:

* No internet
* Action failed
* Request expired

---

# 5. Loading & Timeout Handling

## 5.1 Loading States

Always show loading when:

* sending request
* fetching data
* waiting for driver

---

## 5.2 Timeout Rules

Examples:

* Driver request timeout: 15–30 seconds
* Booking search timeout: configurable

### Handling

* auto-cancel OR retry
* inform user:

  * **"Request timed out. Trying again..."**

---

# 6. Retry Strategy

Provide retry for:

* network requests
* failed booking
* data fetch

Do NOT auto-retry:

* critical state changes (like trip end) without user action

---

# 7. Logging and Debugging

For development:

* log all errors
* capture Firebase errors
* track failed operations

For production (later):

* integrate crash reporting (e.g., Crashlytics)

---

# 8. Preventive Validation

Before executing actions:

* check network
* validate input
* validate user role
* validate trip state

Example:

* Driver cannot start trip if not arrived
* Passenger cannot book ride without destination

---

# 9. Edge Cases

Handle:

* app closed during trip
* driver disconnects mid-trip
* passenger disconnects mid-trip
* duplicate booking attempts
* multiple driver responses

---

# 10. Fallback Strategy

If something fails:

* revert to last known valid state
* notify user
* allow recovery

---

# 11. User Message Style

Keep messages:

* short
* clear
* human

Avoid:

* technical terms
* long explanations

Good example:

✔ "No drivers available. Try again."
Bad example:

✘ "Driver matching service unavailable due to system error."

---

# 12. Summary

Error handling ensures Taximan remains stable and usable under all conditions.

Core approach:

**Detect → Inform → Prevent → Recover**

A well-handled error experience builds user trust and keeps the app reliable.
