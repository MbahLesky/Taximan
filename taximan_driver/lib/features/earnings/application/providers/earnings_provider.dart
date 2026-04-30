import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/models/earnings.dart';

final earningsProvider = Provider<Earnings>(
  (ref) => const Earnings(
    today: 18500,
    week: 92000,
    total: 340000,
    completedTrips: 7,
  ),
);
