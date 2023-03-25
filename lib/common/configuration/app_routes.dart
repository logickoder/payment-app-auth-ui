import 'package:flutter/material.dart';

import '../../auth/login_screen.dart';
import '../../auth/phone_number_input_screen.dart';
import '../../auth/phone_number_verification_screen.dart';
import '../../home/home_screen.dart';

class AppRoutes {
  static const phoneNumberInput = '/';
  static const phoneNumberVerification = '/auth/verify';
  static const login = '/auth';
  static const home = '/home';

  static Map<String, Widget Function(BuildContext)> get routes => {
        phoneNumberInput: (_) => const PhoneNumberInputScreen(),
        phoneNumberVerification: (_) => const PhoneNumberVerificationScreen(),
        login: (_) => const LoginScreen(),
        home: (_) => const HomeScreen(),
      };
}
