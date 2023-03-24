import 'package:flutter/material.dart';

import '../../auth/phone_number_input_screen.dart';
import '../../auth/phone_number_verification_screen.dart';

class AppRoutes {
  static const phoneNumberInput = '/';
  static const phoneNumberVerification = '/phone-number/verify';

  static Map<String, Widget Function(BuildContext)> get routes => {
        phoneNumberInput: (_) => const PhoneNumberInputScreen(),
        phoneNumberVerification: (_) => const PhoneNumberVerificationScreen(),
      };
}
