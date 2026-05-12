class DummyData {
  const DummyData._();

  static const passengerName = 'Mireille Ngono';
  static const passengerPhone = '+237 6 77 45 22 18';
  static const passengerEmail = 'mireille.ngono@example.com';
  static const pickupLocation = 'Mvan Carrefour, Yaounde';
  static const destination = 'Bonamoussadi, Douala';
  static const estimatedFare = '4,500 FCFA';
  static const proposedFare = '5,000 FCFA';
  static const distance = '14.8 km';
  static const eta = '18 min';
  static const remainingTime = '11 min';
  static const driverName = 'Jean Talla';
  static const driverRating = '4.8';
  static const vehicleName = 'Toyota Corolla';
  static const vehiclePlate = 'LT 4821 AB';
  static const paymentMethod = 'Cash';
  static const driverNote = 'Traffic is heavy near the bridge.';

  static const destinationSuggestions = [
    'Douala Grand Mall',
    'University of Yaounde I',
    'Akwa Palace',
    'Bastos Roundabout',
  ];

  static const recentDestinations = [
    'Carrefour Warda',
    'Marche Central',
    'Bonapriso',
  ];

  static const quickActions = ['Ride now', 'Schedule', 'Cash'];

  static const nearbyDrivers = [
    {
      'name': 'Jean Talla',
      'vehicle': 'Toyota Corolla',
      'plate': 'LT 4821 AB',
      'rating': '4.8',
      'eta': '4 min',
      'distance': '1.2 km',
    },
    {
      'name': 'Nadine Abena',
      'vehicle': 'Hyundai Accent',
      'plate': 'CE 1930 BA',
      'rating': '4.7',
      'eta': '7 min',
      'distance': '2.4 km',
    },
    {
      'name': 'Samuel Mefire',
      'vehicle': 'Toyota Yaris',
      'plate': 'LT 7745 AC',
      'rating': '4.9',
      'eta': '9 min',
      'distance': '3.1 km',
    },
  ];

  static const tripHistory = [
    {
      'date': 'Apr 26, 2026',
      'pickup': 'Mvan Carrefour',
      'destination': 'Bastos',
      'fare': '2,800 FCFA',
      'status': 'Completed',
    },
    {
      'date': 'Apr 21, 2026',
      'pickup': 'Akwa',
      'destination': 'Bonamoussadi',
      'fare': '3,500 FCFA',
      'status': 'Completed',
    },
    {
      'date': 'Apr 18, 2026',
      'pickup': 'Carrefour Warda',
      'destination': 'Melen',
      'fare': '2,000 FCFA',
      'status': 'Completed',
    },
  ];
}
