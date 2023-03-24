import 'package:flutter/material.dart';

import '../common/configuration/app_resources.dart';
import '../common/configuration/app_routes.dart';
import '../common/widgets/button.dart';
import '../common/widgets/input.dart';
import 'common.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppPadding.medium,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AuthAppBar(onBack: () => Navigator.pop(context)),
              const SizedBox(height: AppPadding.extraLarge),
              Text(
                'Email and Password',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Text('Enter first and last name as seen on your ID'),
              const SizedBox(height: AppPadding.large),
              const Input(label: 'First & last name'),
              const SizedBox(height: AppPadding.medium),
              const Input(
                label: 'Email Address',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: AppPadding.medium),
              const PasswordInput(label: 'Password'),
              const SizedBox(height: AppPadding.extraLarge),
              const AuthTermsAndConditions(),
              const Spacer(flex: 1),
              Button(
                text: 'Continue',
                onClick: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.phoneNumberVerification,
                  );
                },
              ),
              const SizedBox(height: AppPadding.extraLarge),
            ],
          ),
        ),
      ),
    );
  }
}
