import 'package:flutter/material.dart';

import '../../auth/create_account_screen.dart';
import '../../auth/phone_number_input_screen.dart';
import '../../auth/phone_number_verification_screen.dart';
import '../../home/home_screen.dart';

class AppRoutes {
  static const phoneNumberInput = '/';
  static const phoneNumberVerification = '/auth/verify';
  static const createAccount = '/register';
  static const home = '/home';

  static Map<String, Widget Function(BuildContext)> get routes => {
        phoneNumberInput: (_) => const PhoneNumberInputScreen(),
        phoneNumberVerification: (_) => const PhoneNumberVerificationScreen(),
        createAccount: (_) => const LoginScreen(),
        home: (_) => const HomeScreen(),
      };
}
