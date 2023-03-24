import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../common/configuration/app_resources.dart';
import '../common/configuration/app_routes.dart';
import '../common/widgets/button.dart';
import 'common.dart';

class PhoneNumberVerificationScreen extends StatelessWidget {
  const PhoneNumberVerificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AuthAppBar(onBack: () => Navigator.pop(context)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: AppPadding.large,
            horizontal: AppPadding.medium,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Verify Phone Number',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(flex: 1),
              const _VerificationInput(phoneNumber: '+1 709 200 1200'),
              const Spacer(flex: 9),
              Button(
                  text: 'Continue',
                  onClick: () {
                    Navigator.pushNamed(context, AppRoutes.login);
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

class _VerificationInput extends StatefulWidget {
  const _VerificationInput({
    Key? key,
    required this.phoneNumber,
  }) : super(key: key);

  final String phoneNumber;

  @override
  State<_VerificationInput> createState() => _VerificationInputState();
}

class _VerificationInputState extends State<_VerificationInput> {
  final nodes = List.generate(6, (index) => FocusNode());

  static const _retryTimeout = Duration(seconds: 15);

  final _retry = StateProvider((ref) => false);

  late final _retryCountdown = StreamProvider((ref) async* {
    final retry = ref.watch(_retry);
    var duration = _retryTimeout;
    const countdown = Duration(seconds: 1);
    if (retry) {
      while (!duration.isNegative) {
        await Future.delayed(countdown);
        duration -= countdown;
        if (duration == Duration.zero) {
          ref.read(_retry.notifier).state = !retry;
        }
        yield duration;
      }
    } else {
      yield Duration.zero;
    }
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: Text(
            'Enter ${nodes.length} digit OTP code sent to ${widget.phoneNumber}',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: AppPadding.medium),
        Row(
          children: List.generate(
            nodes.length,
            (index) {
              final previous = index == 0 ? null : nodes[index - 1];
              final next = index < (nodes.length - 1) ? nodes[index + 1] : null;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppPadding.small / 2,
                  ),
                  child: _Input(
                    previous: previous,
                    current: nodes[index],
                    next: next,
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: AppPadding.large),
        Consumer(builder: (_, ref, __) {
          final retry = ref.watch(_retry);
          final duration = ref.watch(_retryCountdown);
          if (retry) {
            return duration.when(
              error: (error, stackTrace) => Text('Error $error'),
              loading: () => _duration(_retryTimeout),
              data: (data) => _duration(data),
            );
          } else {
            return TextButton(
              onPressed: () {
                ref.read(_retry.notifier).state = !retry;
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.all(AppPadding.small),
                shape: RoundedRectangleBorder(
                  side: const BorderSide(),
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text(
                'Resend Code',
                style: theme.textTheme.labelMedium,
              ),
            );
          }
        }),
      ],
    );
  }

  @override
  void dispose() {
    for (final node in nodes) {
      node.dispose();
    }
    super.dispose();
  }

  Widget _duration(Duration duration) {
    return Text(
      'Expires in ${duration.inMinutes.toString().padLeft(2, '0')}:${duration.inSeconds.toString().padLeft(2, '0')}',
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
    );
  }
}

class _Input extends StatelessWidget {
  const _Input({
    Key? key,
    this.previous,
    this.current,
    this.next,
  }) : super(key: key);

  final FocusNode? previous, current, next;

  @override
  Widget build(BuildContext context) {
    final focus = FocusScope.of(context);
    return TextField(
      focusNode: current,
      textAlign: TextAlign.center,
      maxLength: 1,
      onChanged: (input) {
        if (input.isNotEmpty) {
          focus.requestFocus(next);
        } else {
          focus.requestFocus(previous);
        }
      },
      decoration: InputDecoration(
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF96A3B1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color:
                Theme.of(context).textTheme.bodyMedium?.color ?? Colors.black,
          ),
        ),
        counterText: '',
      ),
    );
  }
}
