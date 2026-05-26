import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taximan_passenger/features/ratings/application/providers/rating_state_provider.dart';

void main() {
  group('RatingController', () {
    late ProviderContainer container;
    late RatingController controller;

    setUp(() {
      container = ProviderContainer();
      controller = container.read(ratingStateProvider.notifier);
    });

    tearDown(() {
      container.dispose();
    });

    RatingState currentState() => container.read(ratingStateProvider);

    test('clamps selected rating between 1 and 5', () {
      controller.selectRating(9);
      expect(currentState().selectedRating, 5);

      controller.selectRating(0);
      expect(currentState().selectedRating, 1);
    });

    test('creates a pending rating and marks submission in progress', () {
      controller
        ..selectRating(4)
        ..setComment('Smooth ride');

      final rating = controller.submit(
        tripId: 'trip-1',
        bookingId: 'booking-1',
        passengerId: 'passenger-1',
        driverId: 'driver-1',
      );

      expect(rating.rating, 4);
      expect(rating.comment, 'Smooth ride');
      expect(currentState().isSubmitting, isTrue);
      expect(currentState().submittedRating, rating);
    });

    test('clears issue type when issue reporting is disabled', () {
      controller.setIssueReport(reportIssue: true, issueType: 'safety');
      expect(currentState().issueType, 'safety');

      controller.setIssueReport(reportIssue: false);
      expect(currentState().reportIssue, isFalse);
      expect(currentState().issueType, isNull);
    });

    test('stores success, error, and reset states', () {
      final rating = controller.submit(
        tripId: 'trip-1',
        bookingId: 'booking-1',
        passengerId: 'passenger-1',
        driverId: 'driver-1',
      );

      controller.setSubmitted(rating);
      expect(currentState().isSubmitting, isFalse);
      expect(currentState().errorMessage, isNull);

      controller.setError('Failed');
      expect(currentState().isSubmitting, isFalse);
      expect(currentState().errorMessage, 'Failed');

      controller.reset();
      expect(currentState().selectedRating, 5);
      expect(currentState().submittedRating, isNull);
      expect(currentState().errorMessage, isNull);
    });
  });
}
