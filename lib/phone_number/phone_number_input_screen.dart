import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../common/configuration/app_resources.dart';
import '../common/widgets/button.dart';
import 'phone_number_codes.dart';

class PhoneNumberInputScreen extends StatelessWidget {
  const PhoneNumberInputScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: AppPadding.large,
            horizontal: AppPadding.medium,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(flex: 1),
              Text(
                'Get Started',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(flex: 2),
              const PhoneNumberCodes(),
              const Spacer(flex: 2),
              RichText(
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
              ),
              const Spacer(flex: 8),
              Button(text: 'Continue', onClick: () {}),
              const SizedBox(height: AppPadding.large),
              SizedBox(
                width: double.infinity,
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: 'Have an account?',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    children: [
                      TextSpan(
                        text: ' Sign in',
                        recognizer: TapGestureRecognizer()..onTap = () {},
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
