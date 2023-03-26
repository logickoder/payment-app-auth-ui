import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../common/configuration/app_resources.dart';
import '../common/configuration/app_routes.dart';
import '../common/widgets/button.dart';
import '../common/widgets/input.dart';
import 'common.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _name = TextEditingController(text: 'Paytrybe User');
  final _email = TextEditingController(text: 'paytrybeuser@gmail.com');
  final _password = TextEditingController(text: 'hgxhgqs71829w72891');

  final _form = GlobalKey<FormState>();

  final _isPasswordVisible = StateProvider((ref) => false);

  final _emailRegex = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: theme.scaffoldBackgroundColor,
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppPadding.medium,
            ),
            child: Form(
              key: _form,
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
                  Input(
                    label: 'First & last name',
                    controller: _name,
                    validator: (value) {
                      final name = value ?? '';
                      if (name.isEmpty) {
                        return 'This name field cannot be empty';
                      } else if (name.split(RegExp(r'\s+')).length < 2) {
                        return 'Your first and last name is required to proceed';
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(height: AppPadding.medium),
                  Input(
                    label: 'Email Address',
                    keyboardType: TextInputType.emailAddress,
                    controller: _email,
                    validator: (value) {
                      final email = value ?? '';
                      if (email.isEmpty) {
                        return 'This email field cannot be empty';
                      } else if (!_emailRegex.hasMatch(email)) {
                        return 'Please input a valid email';
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(height: AppPadding.medium),
                  Consumer(builder: (_, ref, __) {
                    final isVisible = ref.watch(_isPasswordVisible);

                    return Input(
                      label: 'Password',
                      controller: _password,
                      obscureInput: !isVisible,
                      keyboardType:
                          isVisible ? null : TextInputType.visiblePassword,
                      trailing: InkWell(
                        onTap: () => ref
                            .read(_isPasswordVisible.notifier)
                            .state = !isVisible,
                        child: Icon(
                          isVisible ? Icons.visibility_off : Icons.visibility,
                        ),
                      ),
                      validator: (value) {
                        final password = value ?? '';
                        if (password.isEmpty) {
                          return 'This password field cannot be empty';
                        } else {
                          return null;
                        }
                      },
                    );
                  }),
                  const SizedBox(height: AppPadding.extraLarge),
                  const AuthTermsAndConditions(),
                  const Spacer(flex: 1),
                  Button(
                    text: 'Continue',
                    onClick: () {
                      if (_form.currentState?.validate() == true) {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.home,
                        );
                      }
                    },
                  ),
                  const SizedBox(height: AppPadding.extraLarge),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }
}
