import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../configuration/app_resources.dart';

class BottomBar extends ConsumerWidget {
  const BottomBar({Key? key}) : super(key: key);

  static final _page = StateProvider<String?>((ref) => 'Home');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    const items = {
      'Home': "assets/icons/home.svg",
      'Transactions': "assets/icons/transactions.svg",
      'Cards': "assets/icons/card.svg",
      'Settings': "assets/icons/settings.svg",
    };

    final page = ref.watch(_page);

    return Container(
      padding: const EdgeInsets.only(
        bottom: AppPadding.normal,
        top: AppPadding.medium,
      ),
      color: theme.colorScheme.onPrimary,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: items.entries
            .map(
              (item) => _BottomBarItem(
                title: item.key,
                icon: item.value,
                active: page == item.key,
                onClick: () => ref.read(_page.notifier).state = item.key,
              ),
            )
            .toList(),
      ),
    );
  }
}

class _BottomBarItem extends StatelessWidget {
  const _BottomBarItem({
    Key? key,
    required this.title,
    required this.icon,
    required this.active,
    required this.onClick,
  }) : super(key: key);

  final String title;
  final String icon;
  final bool active;
  final VoidCallback onClick;

  @override
  Widget build(BuildContext context) {
    final color = active ? const Color(0xFF007CFF) : const Color(0xFF8E98A8);
    return InkWell(
      onTap: onClick,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            icon,
            width: 24,
            height: 24,
            colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      ),
    );
  }
}
