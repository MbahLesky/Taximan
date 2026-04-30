import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/models/user.dart';

final userProvider = Provider<User>(
  (ref) => const User(
    id: 'passenger-001',
    fullName: 'Mireille Ngono',
    email: 'mireille.ngono@example.com',
    phone: '+237 6 77 45 22 18',
    homeLocation: 'Mvan Carrefour, Yaounde',
  ),
);
