import 'dart:math' as math;

class FareEstimator {
  const FareEstimator._();

  static const int baseFare = 200;
  static const int distanceRatePerKm = 100;
  static const double luggageRate = 0.10;
  static const int minimumLuggageFee = 50;
  static const double privateRideMultiplier = 2.5;

  static int calculate({
    required double distanceKm,
    required bool isRideSharing,
    required int luggageCount,
  }) {
    final distanceFare = distanceKm * distanceRatePerKm;
    final perPieceLuggageFee = math.max(
      minimumLuggageFee.toDouble(),
      distanceFare * luggageRate,
    );
    final luggageFee = perPieceLuggageFee * math.max(0, luggageCount);
    final sharedFare = baseFare + distanceFare + luggageFee;
    final fare = isRideSharing
        ? sharedFare
        : sharedFare * privateRideMultiplier;

    return fare.round();
  }
}
