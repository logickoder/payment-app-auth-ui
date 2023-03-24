import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../common/configuration/app_resources.dart';

class AuthAppBar extends StatelessWidget {
  const AuthAppBar({Key? key, this.onBack}) : super(key: key);

  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: 56,
      child: Stack(
        children: [
          if (onBack != null)
            Align(
              alignment: Alignment.centerLeft,
              child: InkWell(
                onTap: onBack,
                child: Container(
                  padding: const EdgeInsets.all(AppPadding.small / 2),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: theme.textTheme.bodyMedium?.color ?? Colors.black,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.keyboard_arrow_left,
                    color: theme.textTheme.bodyMedium?.color,
                  ),
                ),
              ),
            ),
          Align(
            alignment: Alignment.center,
            child: Text(
              'Create Account',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthTermsAndConditions extends StatelessWidget {
  const AuthTermsAndConditions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return RichText(
      text: TextSpan(
        text: 'By continuing, you agree to the Paytrybe ',
        style: theme.textTheme.bodyMedium?.copyWith(
          color: null,
        ),
        children: [
          TextSpan(
            text: 'Platform Terms & Conditions,',
            recognizer: TapGestureRecognizer()
              ..onTap = () async => await launchUrlString(
                    'https://neofinancial.com/platform-policy',
                  ),
            style: theme.textTheme.bodyMedium?.copyWith(
              decoration: TextDecoration.underline,
              fontWeight: FontWeight.w500,
            ),
          ),
          const TextSpan(text: ' '),
          TextSpan(
            text: 'Rewards Policy',
            recognizer: TapGestureRecognizer()
              ..onTap = () async => await launchUrlString(
                    'https://neofinancial.com/rewards-policy',
                  ),
            style: theme.textTheme.bodyMedium?.copyWith(
              decoration: TextDecoration.underline,
              fontWeight: FontWeight.w500,
            ),
          ),
          TextSpan(
            text: ' and ',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: null,
            ),
          ),
          TextSpan(
            text: 'Privacy Policy.',
            recognizer: TapGestureRecognizer()
              ..onTap = () async => await launchUrlString(
                    'https://neofinancial.com/privacy-policy',
                  ),
            style: theme.textTheme.bodyMedium?.copyWith(
              decoration: TextDecoration.underline,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
