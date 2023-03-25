import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../common/configuration/app_resources.dart';

class HomeGettingStarted extends StatelessWidget {
  const HomeGettingStarted({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const divider = Padding(
      padding: EdgeInsets.symmetric(
        vertical: AppPadding.medium,
      ),
      child: Divider(),
    );
    return Container(
      padding: const EdgeInsets.all(AppPadding.medium),
      decoration: BoxDecoration(
        color: theme.colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(AppPadding.small),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Getting Started',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: const Color(0xAD011A32),
            ),
          ),
          const SizedBox(height: AppPadding.medium),
          const _GettingStartedItem(
            title: 'Verify Email',
            subtitle:
                'To protect your account we need to verify your e-mail address',
            icon: 'assets/icons/verify_mail.svg',
            isDone: true,
          ),
          divider,
          const _GettingStartedItem(
            title: 'Verify Identity',
            subtitle:
                'To protect your account we need to verify your e-mail address',
            icon: 'assets/icons/verify_identity.svg',
            isDone: true,
          ),
          divider,
          const _GettingStartedItem(
            title: 'Fund Account',
            subtitle:
                'To protect your account we need to verify your e-mail address',
            icon: 'assets/icons/fund_me.svg',
            isDone: false,
          ),
        ],
      ),
    );
  }
}

class _GettingStartedItem extends StatelessWidget {
  const _GettingStartedItem({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isDone,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final String icon;
  final bool isDone;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        SvgPicture.asset(
          icon,
          width: 32,
          height: 32,
        ),
        const SizedBox(width: AppPadding.medium),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: AppPadding.small),
              Text(
                subtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: const Color(0xB2023564),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppPadding.medium),
        Container(
          padding: const EdgeInsets.all(AppPadding.small / 2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isDone ? const Color(0xFF27AE60) : const Color(0xFFD9D9D9),
          ),
          child: Icon(
            Icons.check,
            color: theme.colorScheme.onPrimary,
            size: AppPadding.small + AppPadding.small / 2,
          ),
        ),
      ],
    );
  }
}
