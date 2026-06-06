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
}

class TripStatus {
  const TripStatus._();

  static const pending = 'pending';
  static const driverArriving = 'driver_arriving';
  static const arrived = 'arrived';
  static const inProgress = 'in_progress';
  static const completed = 'completed';
  static const cancelled = 'cancelled';

  static const upcoming = [pending, driverArriving, arrived];
  static const active = [driverArriving, arrived, inProgress];
  static const trackable = [pending, driverArriving, arrived, inProgress];
}
