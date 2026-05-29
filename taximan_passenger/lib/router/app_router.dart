import 'package:go_router/go_router.dart';

import '../features/account/presentation/screens/passenger_profile_screen.dart';
import '../features/account/presentation/screens/passenger_drivers_screen.dart';
import '../features/account/presentation/screens/passenger_tracking_screen.dart';
import '../features/account/presentation/screens/trip_details_screen.dart';
import '../features/account/presentation/screens/trip_history_screen.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/notifications/presentation/screens/notification_center_screen.dart';
import '../features/auth/presentation/screens/forgot_password_screen.dart';
import '../features/auth/presentation/screens/onboarding_screen.dart';
import '../features/auth/presentation/screens/register_screen.dart';
import '../features/auth/presentation/screens/splash_screen.dart';
import '../features/booking/presentation/screens/driver_preference_screen.dart';
import '../features/booking/presentation/screens/passenger_home_screen.dart';
import '../features/booking/presentation/screens/ride_details_screen.dart';
import '../features/booking/presentation/screens/ride_summary_screen.dart';
import '../features/booking/presentation/screens/route_time_screen.dart';
import '../features/matching/presentation/screens/driver_assigned_screen.dart';
import '../features/matching/presentation/screens/fare_proposal_screen.dart';
import '../features/matching/presentation/screens/searching_driver_screen.dart';
import '../features/payments/presentation/screens/payment_confirmation_screen.dart';
import '../features/payments/presentation/screens/payment_screen.dart';
import '../features/ratings/presentation/screens/feedback_screen.dart';
import '../features/ratings/presentation/screens/rating_screen.dart';
import '../features/trip/presentation/screens/driver_arrived_screen.dart';
import '../features/trip/presentation/screens/driver_en_route_screen.dart';
import '../features/trip/presentation/screens/trip_in_progress_screen.dart';

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
      path: '/forgot-password',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const PassengerHomeScreen(),
    ),
    GoRoute(
      path: '/pickup',
      builder: (context, state) => const RouteTimeScreen(),
    ),
    GoRoute(
      path: '/destination',
      redirect: (context, state) => '/ride-details',
    ),
    GoRoute(
      path: '/ride-details',
      builder: (context, state) => const RideDetailsScreen(),
    ),
    GoRoute(
      path: '/pickup-time',
      redirect: (context, state) => '/drivers',
    ),
    GoRoute(
      path: '/drivers',
      builder: (context, state) => const DriverPreferenceScreen(),
    ),
    GoRoute(
      path: '/ride-summary',
      builder: (context, state) => const RideSummaryScreen(),
    ),
    GoRoute(
      path: '/searching-driver',
      builder: (context, state) => const SearchingDriverScreen(),
    ),
    GoRoute(
      path: '/fare-proposal',
      builder: (context, state) => const FareProposalScreen(),
    ),
    GoRoute(
      path: '/driver-assigned',
      builder: (context, state) => const DriverAssignedScreen(),
    ),
    GoRoute(
      path: '/driver-en-route',
      builder: (context, state) => const DriverEnRouteScreen(),
    ),
    GoRoute(
      path: '/driver-arrived',
      builder: (context, state) => const DriverArrivedScreen(),
    ),
    GoRoute(
      path: '/trip-in-progress',
      builder: (context, state) => const TripInProgressScreen(),
    ),
    GoRoute(
      path: '/payment',
      builder: (context, state) => const PaymentScreen(),
    ),
    GoRoute(
      path: '/payment-confirmation',
      builder: (context, state) => const PaymentConfirmationScreen(),
    ),
    GoRoute(path: '/rating', builder: (context, state) => const RatingScreen()),
    GoRoute(
      path: '/feedback',
      builder: (context, state) => const FeedbackScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const PassengerProfileScreen(),
    ),
    GoRoute(
      path: '/trips',
      builder: (context, state) => const TripHistoryScreen(),
    ),
    GoRoute(
      path: '/trip-history',
      builder: (context, state) => const TripHistoryScreen(),
    ),
    GoRoute(
      path: '/saved-drivers',
      builder: (context, state) => const PassengerDriversScreen(),
    ),
    GoRoute(
      path: '/tracking',
      builder: (context, state) => const PassengerTrackingScreen(),
    ),
    GoRoute(
      path: '/trip-details',
      builder: (context, state) => const TripDetailsScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const PassengerProfileScreen(),
    ),
    GoRoute(
      path: '/notifications',
      builder: (context, state) => const NotificationCenterScreen(),
    ),
  ],
);
