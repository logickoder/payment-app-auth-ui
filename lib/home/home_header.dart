import 'package:boxy/boxy.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../auth/phone_number_input_screen.dart';
import '../common/configuration/app_resources.dart';
import '../common/widgets/emoji.dart';

final _headerCountry = StateProvider.autoDispose((ref) {
  final countries = ref.watch(countryList);

  return countries.when(
    error: (error, stackTrace) => null,
    loading: () => null,
    data: (items) => items.firstWhere((country) => country.code == 'CA'),
  );
});

class HomeHeader extends StatelessWidget {
  const HomeHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomBoxy(
      delegate: _HomeHeaderLayoutDelegate(),
      children: [
        const BoxyId(
          id: #top,
          child: _HomeHeaderTop(),
        ),
        BoxyId(
          id: #middle,
          child: Container(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const BoxyId(
          id: #bottom,
          child: _HomeHeaderBottom(),
        ),
      ],
    );
  }
}

class _HomeHeaderLayoutDelegate extends BoxyDelegate {
  @override
  Size layout() {
    // get children
    final top = getChild(#top);
    final middle = getChild(#middle);
    final bottom = getChild(#bottom);
    // size and position the top and bottom widgets first to get
    // the right position and size for the middle child
    top.layout(constraints);
    top.position(Offset.zero);
    bottom.layout(constraints);
    // size the middle child to be half the bottom child height
    middle.layout(constraints.copyWith(maxHeight: bottom.size.height / 2));
    middle.position(Offset(0, top.size.height));
    bottom.position(Offset(0, top.size.height));
    return Size(top.size.width, top.size.height + bottom.size.height);
  }
}

class _HomeHeaderTop extends StatelessWidget {
  const _HomeHeaderTop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(AppPadding.medium),
        color: theme.colorScheme.primary,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFF5583FD),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.75),
                    ),
                  ),
                  icon: Container(
                    padding: const EdgeInsets.all(AppPadding.small / 2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: theme.colorScheme.onPrimary,
                    ),
                    child: Text(
                      'P',
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  label: Text(
                    '\$Paytrybe',
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(AppPadding.small),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF5583FD),
                  ),
                  child: Icon(
                    Icons.notifications_outlined,
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppPadding.large),
            RichText(
              text: TextSpan(
                text: '\$',
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onPrimary.withOpacity(0.68),
                ),
                children: [
                  TextSpan(
                    text: '100',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                  const TextSpan(text: '.00'),
                ],
              ),
            ),
            const SizedBox(height: AppPadding.medium),
            Container(
              padding: const EdgeInsets.all(AppPadding.small),
              decoration: BoxDecoration(
                  color: theme.colorScheme.onPrimary.withOpacity(0.45),
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(color: const Color(0xFFEBF0FF))),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Consumer(builder: (_, ref, __) {
                    final country = ref.watch(_headerCountry);
                    if (country != null) {
                      return Emoji(country.emoji);
                    } else {
                      return const SizedBox();
                    }
                  }),
                  const SizedBox(width: AppPadding.medium),
                  Text(
                    'CAD Dollar',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: theme.scaffoldBackgroundColor,
                    ),
                  ),
                  const SizedBox(width: AppPadding.medium),
                  Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFEBF0FF),
                    ),
                    child: Icon(
                      Icons.arrow_drop_down,
                      color: theme.colorScheme.primary,
                      size: AppPadding.medium,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppPadding.large),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.all(AppPadding.medium),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                        side: BorderSide(color: theme.colorScheme.onPrimary),
                      ),
                    ),
                    child: Text(
                      'Add Money',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: theme.scaffoldBackgroundColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppPadding.medium),
                Expanded(
                  child: TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.all(AppPadding.medium),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      backgroundColor: theme.colorScheme.onPrimary,
                    ),
                    child: Text(
                      'Send Money',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _HomeHeaderBottom extends StatelessWidget {
  const _HomeHeaderBottom({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppPadding.medium),
      child: Container(
        padding: const EdgeInsets.all(AppPadding.normal),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppPadding.small),
          color: theme.colorScheme.onPrimary,
        ),
        child: Row(children: const [
          Expanded(
            child: _HomeHeaderBottomItem(
              title: 'Request Money',
              icon: Icons.add,
            ),
          ),
          Expanded(
            child: _HomeHeaderBottomItem(
              title: 'Exchange Currency',
              icon: Icons.currency_exchange,
            ),
          ),
          Expanded(
            child: _HomeHeaderBottomItem(
              title: 'Buy\nAirtime',
              icon: Icons.phone_android_sharp,
            ),
          ),
        ]),
      ),
    );
  }
}

class _HomeHeaderBottomItem extends StatelessWidget {
  const _HomeHeaderBottomItem({
    Key? key,
    required this.title,
    required this.icon,
  }) : super(key: key);

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(AppPadding.small),
          decoration: ShapeDecoration(
            shape: const CircleBorder(),
            color: theme.colorScheme.primary,
          ),
          child: Icon(
            icon,
            size: AppPadding.medium,
            color: theme.colorScheme.onPrimary,
          ),
        ),
        const SizedBox(height: AppPadding.small),
        Text(
          title,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
