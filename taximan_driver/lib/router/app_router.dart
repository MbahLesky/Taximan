import 'package:go_router/go_router.dart';

import '../features/account/presentation/screens/document_status_screen.dart';
import '../features/account/presentation/screens/driver_profile_screen.dart';
import '../features/account/presentation/screens/driver_settings_screen.dart';
import '../features/account/presentation/screens/vehicle_information_screen.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/screens/onboarding_screen.dart';
import '../features/auth/presentation/screens/register_screen.dart';
import '../features/auth/presentation/screens/splash_screen.dart';
import '../features/availability/presentation/screens/availability_schedule_screen.dart';
import '../features/availability/presentation/screens/driver_dashboard_screen.dart';
import '../features/booking_management/presentation/screens/fare_proposals_screen.dart';
import '../features/booking_management/presentation/screens/incoming_ride_request_screen.dart';
import '../features/booking_management/presentation/screens/request_timeout_screen.dart';
import '../features/earnings/presentation/screens/driver_trip_details_screen.dart';
import '../features/earnings/presentation/screens/driver_trip_history_screen.dart';
import '../features/earnings/presentation/screens/earnings_screen.dart';
import '../features/onboarding/presentation/screens/document_upload_screen.dart';
import '../features/onboarding/presentation/screens/driver_personal_info_screen.dart';
import '../features/onboarding/presentation/screens/profile_photo_screen.dart';
import '../features/onboarding/presentation/screens/vehicle_details_screen.dart';
import '../features/onboarding/presentation/screens/verification_pending_screen.dart';
import '../features/onboarding/presentation/screens/verification_rejected_screen.dart';
import '../features/trip/presentation/screens/mark_arrival_screen.dart';
import '../features/trip/presentation/screens/navigate_to_pickup_screen.dart';
import '../features/trip/presentation/screens/trip_completed_screen.dart';
import '../features/trip/presentation/screens/trip_in_progress_screen.dart';
import '../features/trip/presentation/screens/trip_start_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/driver-personal-info',
      builder: (context, state) => const DriverPersonalInfoScreen(),
    ),
    GoRoute(
      path: '/vehicle-details',
      builder: (context, state) => const VehicleDetailsScreen(),
    ),
    GoRoute(
      path: '/document-upload',
      builder: (context, state) => const DocumentUploadScreen(),
    ),
    GoRoute(
      path: '/profile-photo',
      builder: (context, state) => const ProfilePhotoScreen(),
    ),
    GoRoute(
      path: '/verification-pending',
      builder: (context, state) => const VerificationPendingScreen(),
    ),
    GoRoute(
      path: '/verification-rejected',
      builder: (context, state) => const VerificationRejectedScreen(),
    ),
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const DriverDashboardScreen(),
    ),
    GoRoute(
      path: '/availability-schedule',
      builder: (context, state) => const AvailabilityScheduleScreen(),
    ),
    GoRoute(
      path: '/incoming-request',
      builder: (context, state) => const IncomingRideRequestScreen(),
    ),
    GoRoute(
      path: '/fare-proposal',
      builder: (context, state) => const FareProposalScreen(),
    ),
    GoRoute(
      path: '/request-timeout',
      builder: (context, state) => const RequestTimeoutScreen(),
    ),
    GoRoute(
      path: '/navigate-to-pickup',
      builder: (context, state) => const NavigateToPickupScreen(),
    ),
    GoRoute(
      path: '/mark-arrival',
      builder: (context, state) => const MarkArrivalScreen(),
    ),
    GoRoute(
      path: '/trip-start',
      builder: (context, state) => const TripStartScreen(),
    ),
    GoRoute(
      path: '/trip-in-progress',
      builder: (context, state) => const TripInProgressScreen(),
    ),
    GoRoute(
      path: '/trip-completed',
      builder: (context, state) => const TripCompletedScreen(),
    ),
    GoRoute(
      path: '/earnings',
      builder: (context, state) => const EarningsScreen(),
    ),
    GoRoute(
      path: '/trip-history',
      builder: (context, state) => const DriverTripHistoryScreen(),
    ),
    GoRoute(
      path: '/trip-details',
      builder: (context, state) => const DriverTripDetailsScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const DriverProfileScreen(),
    ),
    GoRoute(
      path: '/vehicle-information',
      builder: (context, state) => const VehicleInformationScreen(),
    ),
    GoRoute(
      path: '/document-status',
      builder: (context, state) => const DocumentStatusScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const DriverSettingsScreen(),
    ),
  ],
);
