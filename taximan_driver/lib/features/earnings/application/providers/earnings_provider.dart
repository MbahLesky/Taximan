import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/models/earnings.dart';
import '../../../trip/application/providers/trip_providers.dart';

final earningsProvider = FutureProvider<Earnings>((ref) async {
  final summary = await ref.watch(driverEarningsProvider.future);
  return Earnings(
    today: summary.today,
    week: summary.week,
    total: summary.total,
    completedTrips: summary.completedTrips,
  );
});
