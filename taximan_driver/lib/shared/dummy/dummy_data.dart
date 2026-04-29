class DummyData {
  const DummyData._();

  static const driverName = 'Samuel F.';
  static const driverEmail = 'samuel.driver@example.com';
  static const driverPhone = '+237 6 91 24 77 05';
  static const driverRating = '4.9';
  static const verificationStatus = 'Pending verification';
  static const availabilityStatus = 'Offline';
  static const vehicleType = 'Taxi';
  static const vehicleModel = 'Toyota Corolla';
  static const vehiclePlate = 'LT 4821 AB';
  static const vehicleColor = 'Yellow';
  static const vehicleCapacity = '4 passengers';
  static const todayEarnings = '18,500 XAF';
  static const weeklyEarnings = '92,000 XAF';
  static const totalEarnings = '340,000 XAF';
  static const completedTripsCount = '7';
  static const incomingPickup = 'Mvan Carrefour, Yaounde';
  static const incomingDestination = 'Bastos Roundabout';
  static const estimatedFare = '3,000 XAF';
  static const passengerName = 'Mireille N.';
  static const passengerRating = '4.7';
  static const tripDistance = '8.4 km';
  static const tripEta = '16 min';
  static const remainingTime = '9 min';
  static const paymentMethod = 'Cash';
  static const commission = '450 XAF';
  static const netEarning = '2,550 XAF';
  static const rejectionReason = 'Driver license image is blurry.';

  static const completedTrips = [
    {
      'date': 'Apr 28, 2026',
      'passenger': 'Mireille N.',
      'destination': 'Bastos',
      'fare': '3,000 XAF',
      'status': 'Completed',
    },
    {
      'date': 'Apr 27, 2026',
      'passenger': 'Eric M.',
      'destination': 'Akwa',
      'fare': '4,200 XAF',
      'status': 'Completed',
    },
    {
      'date': 'Apr 26, 2026',
      'passenger': 'Claudia T.',
      'destination': 'Bonapriso',
      'fare': '3,800 XAF',
      'status': 'Completed',
    },
  ];

  static const documents = [
    {'name': 'National ID', 'status': 'Approved'},
    {'name': 'Driver license', 'status': 'Rejected'},
    {'name': 'Vehicle registration', 'status': 'Pending'},
    {'name': 'Insurance', 'status': 'Pending'},
    {'name': 'Road worthiness', 'status': 'Approved'},
  ];
}
