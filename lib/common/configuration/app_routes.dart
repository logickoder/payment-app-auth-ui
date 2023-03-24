import 'package:flutter/material.dart';

import '../../phone_number/phone_number_input_screen.dart';

class AppRoutes {
  static const phoneNumberInput = '/';

  static Map<String, Widget Function(BuildContext)> get routes => {
        phoneNumberInput: (_) => const PhoneNumberInputScreen(),
      };
}
