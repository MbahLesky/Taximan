# Taximan — UI Guidelines

## 1. Purpose

This document defines the visual and interface guidelines for the Taximan Passenger App and Taximan Driver App.

The goal is to keep both apps consistent, professional, easy to use, and visually connected as part of the same product.

---

## 2. Design Direction

Taximan should feel:

* Fast
* Reliable
* Safe
* Local-friendly
* Modern
* Simple to use

The UI should prioritize clarity over decoration.

---

## 3. Brand Approach

Taximan uses a **shared design system** with slight visual differences between the Passenger App and Driver App.

### Passenger App

Focus:

* Comfort
* Trust
* Simplicity

### Driver App

Focus:

* Action
* Earnings
* Work dashboard
* Operational clarity

---

## 4. Color System

## 4.1 Shared Colors

```text
Background: #F8FAFC
Surface/Card: #FFFFFF
Text Primary: #111827
Text Secondary: #6B7280
Border: #E5E7EB
Success: #16A34A
Warning: #F59E0B
Error: #DC2626
Info: #2563EB
```

---

## 4.2 Passenger App Colors

```text
Primary: #F8D828
Primary Dark: #2B2501
Primary Light: #FDF2B8
Accent: #FACC15
```

---

## 4.3 Driver App Colors

```text
Primary: #22C55E
Primary Dark: #166534
Primary Light: #DCFCE7
Accent: #06B6D4
```

---

## 5. Typography

Use clean, readable typography.

Recommended font:

```text
Inter
```

Fallback:

```text
Roboto
```

## 5.1 Text Styles

```text
Display / Hero: 28–32px, Bold
Screen Title: 22–24px, Bold
Section Title: 18–20px, SemiBold
Body Text: 14–16px, Regular
Caption: 12–13px, Regular
Button Text: 14–16px, SemiBold
```

---

## 6. Spacing System

Use consistent spacing.

```text
4px   Extra small
8px   Small
12px  Compact
16px  Default
20px  Medium
24px  Large
32px  Extra large
```

Default screen padding:

```text
16px
```

Card padding:

```text
16px
```

---

## 7. Border Radius

Use rounded corners but keep it professional.

```text
Small: 8px
Medium: 12px
Large: 16px
Extra Large: 24px
```

Recommended default:

```text
16px
```

---

## 8. Buttons

## 8.1 Primary Button

Use for main actions.

Examples:

* Book Ride
* Confirm Ride
* Accept Request
* Start Trip
* End Trip

Style:

```text
Height: 48–56px
Radius: 14–16px
Text: SemiBold
```

Passenger primary button uses Passenger Primary color.
Driver primary button uses Driver Primary color.

---

## 8.2 Secondary Button

Use for less important actions.

Examples:

* Edit Pickup
* Change Payment Method
* View Details

Style:

```text
Background: Primary Light
Text: Primary Dark
Border: None or light border
```

---

## 8.3 Danger Button

Use for destructive actions.

Examples:

* Cancel Ride
* Reject Request
* Logout

Style:

```text
Background: Error or Error Light
Text: White or Error
```

---

## 9. Inputs and Forms

Input fields should be clean and easy to tap.

Style:

```text
Height: 48–56px
Radius: 12–16px
Border: #E5E7EB
Background: #FFFFFF
```

Input states:

* Default
* Focused
* Error
* Disabled

---

## 10. Cards

Cards are used for:

* Ride summary
* Driver details
* Trip history
* Earnings
* Booking requests

Style:

```text
Background: #FFFFFF
Radius: 16px
Padding: 16px
Border: #E5E7EB
Shadow: subtle
```

Avoid heavy shadows.

---

## 11. Map UI Guidelines

Map screens should stay clean.

## 11.1 Passenger Map

Main overlays:

* Pickup field
* Destination field
* Current location button
* Ride summary bottom sheet
* Driver assigned card

## 11.2 Driver Map

Main overlays:

* Online/offline status
* Incoming request card
* Navigation card
* Trip action button

## 11.3 Bottom Sheets

Use bottom sheets for:

* Ride summary
* Driver assigned details
* Trip status
* Payment confirmation

Bottom sheet style:

```text
Radius top-left/top-right: 24px
Padding: 16–24px
Background: #FFFFFF
```

---

## 12. Icons

Use simple, familiar icons.

Recommended icon package:

```text
Lucide-style icons or Material Icons
```

Use icons for:

* Location
* Destination
* Payment
* History
* Profile
* Earnings
* Vehicle
* Rating

Do not overuse icons.

---

## 13. Passenger App UI Notes

Passenger UI should be simple and calm.

Important actions:

* Set destination
* Confirm ride
* Track driver
* Pay
* Rate driver

Avoid clutter on the map screen.

---

## 14. Driver App UI Notes

Driver UI should be more action-focused.

Important actions:

* Go online/offline
* Accept ride
* Reject ride
* Propose fare
* Mark arrived
* Start trip
* End trip

Buttons should be large and easy to press while on the move.

---

## 15. Status Colors

Use consistent colors for statuses.

```text
Online / Available: Success
Offline: Text Secondary
Busy / In Trip: Info
Pending / Searching: Warning
Cancelled / Error: Error
Completed: Success
```

---

## 16. Empty States

Empty states should be friendly and useful.

Examples:

* No trips yet
* No earnings yet
* No notifications
* No drivers available

Each empty state should include:

* short title
* short description
* optional action button

---

## 17. Error States

Error messages should be direct and helpful.

Examples:

```text
No internet connection. Please reconnect to continue.
Location permission is required to book a ride.
No drivers available nearby. Try again.
```

---

## 18. Loading States

Use loading states for:

* signing in
* searching for driver
* calculating fare
* loading trip history
* uploading documents

Avoid blank screens.

---

## 19. Accessibility

Basic accessibility rules:

* Buttons should be large enough to tap
* Text should be readable
* Do not rely only on color to show status
* Use clear labels
* Maintain strong contrast

---

## 20. Summary

Taximan should use a clean shared design system with slightly different colors for Passenger and Driver apps.

The Passenger App should feel calm and trustworthy.
The Driver App should feel practical, fast, and work-focused.
