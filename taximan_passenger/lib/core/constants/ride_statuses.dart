class BookingStatus {
  const BookingStatus._();

  static const draft = 'draft';
  static const searching = 'searching';
  static const proposal = 'proposal';
  static const accepted = 'accepted';
  static const driverArriving = 'driver_arriving';
  static const arrived = 'arrived';
  static const inProgress = 'in_progress';
  static const completed = 'completed';
  static const cancelled = 'cancelled';

  static const active = [
    draft,
    searching,
    proposal,
    accepted,
    driverArriving,
    arrived,
    inProgress,
  ];
}

class TripStatus {
  const TripStatus._();

  static const driverArriving = 'driver_arriving';
  static const arrived = 'arrived';
  static const inProgress = 'in_progress';
  static const completed = 'completed';
  static const cancelled = 'cancelled';
  static const pending = 'pending';

  static const upcoming = [driverArriving, arrived, pending];
  static const active = [driverArriving, arrived, inProgress];
}
