import 'package:flutter/material.dart';

import '../configuration/app_resources.dart';

class Button extends StatelessWidget {
  const Button({
    Key? key,
    required this.text,
    required this.onClick,
  }) : super(key: key);

  final String text;
  final VoidCallback onClick;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onClick,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(AppPadding.medium),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(41),
          ),
        ),
        child: Text(
          text,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }
}
