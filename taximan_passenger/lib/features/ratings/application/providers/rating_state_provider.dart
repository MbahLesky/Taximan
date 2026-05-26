import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/models/rating.dart';

const _unset = Object();

class RatingState {
  const RatingState({
    this.selectedRating = 5,
    this.comment = '',
    this.reportIssue = false,
    this.issueType,
    this.submittedRating,
    this.isSubmitting = false,
    this.errorMessage,
  });

  final int selectedRating;
  final String comment;
  final bool reportIssue;
  final String? issueType;
  final Rating? submittedRating;
  final bool isSubmitting;
  final String? errorMessage;

  RatingState copyWith({
    int? selectedRating,
    String? comment,
    bool? reportIssue,
    Object? issueType = _unset,
    Object? submittedRating = _unset,
    bool? isSubmitting,
    Object? errorMessage = _unset,
  }) {
    return RatingState(
      selectedRating: selectedRating ?? this.selectedRating,
      comment: comment ?? this.comment,
      reportIssue: reportIssue ?? this.reportIssue,
      issueType: issueType == _unset ? this.issueType : issueType as String?,
      submittedRating: submittedRating == _unset
          ? this.submittedRating
          : submittedRating as Rating?,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage:
          errorMessage == _unset ? this.errorMessage : errorMessage as String?,
    );
  }
}

class RatingController extends StateNotifier<RatingState> {
  RatingController() : super(const RatingState());

  void selectRating(int rating) {
    state = state.copyWith(selectedRating: rating.clamp(1, 5).toInt());
  }

  void setComment(String comment) {
    state = state.copyWith(comment: comment);
  }

  void setIssueReport({required bool reportIssue, String? issueType}) {
    state = state.copyWith(
      reportIssue: reportIssue,
      issueType: reportIssue ? issueType : null,
    );
  }

  Rating submit({
    required String tripId,
    required String bookingId,
    required String passengerId,
    required String driverId,
  }) {
    state = state.copyWith(isSubmitting: true, errorMessage: null);

    final rating = Rating(
      id: '',
      tripId: tripId,
      bookingId: bookingId,
      passengerId: passengerId,
      driverId: driverId,
      rating: state.selectedRating,
      comment: state.comment,
      reportIssue: state.reportIssue,
      issueType: state.issueType,
      createdAt: DateTime.now(),
    );

    state = state.copyWith(
      submittedRating: rating,
      isSubmitting: true,
      errorMessage: null,
    );

    return rating;
  }

  void setSubmitted(Rating rating) {
    state = state.copyWith(
      submittedRating: rating,
      isSubmitting: false,
      errorMessage: null,
    );
  }

  void setError(String message) {
    state = state.copyWith(isSubmitting: false, errorMessage: message);
  }

  void reset() {
    state = const RatingState();
  }
}

final ratingStateProvider =
    StateNotifierProvider<RatingController, RatingState>(
      (ref) => RatingController(),
    );
