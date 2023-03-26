import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'
    show SystemChrome, SystemUiOverlayStyle, rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payment_app_auth_ui/auth/common.dart';

import '../common/configuration/app_resources.dart';
import '../common/configuration/app_routes.dart';
import '../common/data/models/country.dart';
import '../common/widgets/button.dart';
import '../common/widgets/emoji.dart';
import '../common/widgets/input.dart';

// load the countries from the json asset
final countryList = FutureProvider.autoDispose((ref) async {
  final json = await rootBundle.loadString('assets/data/countries.json');
  final countries = jsonDecode(json) as List<dynamic>;
  return countries.map((e) => Country.fromJson(e)).toList();
});

class PhoneNumberInputScreen extends ConsumerStatefulWidget {
  const PhoneNumberInputScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<PhoneNumberInputScreen> createState() =>
      _PhoneNumberInputScreenState();
}

class _PhoneNumberInputScreenState
    extends ConsumerState<PhoneNumberInputScreen> {
  // holds the currently selected country
  final _country = StateProvider<Country?>((ref) => null);

  final _form = GlobalKey<FormState>();
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: theme.scaffoldBackgroundColor,
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: theme.scaffoldBackgroundColor,
          elevation: 0,
        ),
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
                  'Get Started',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(flex: 1),
                Form(
                  key: _form,
                  child: _NumberInput(
                    controller: _controller,
                    country: _country,
                  ),
                ),
                const Spacer(flex: 1),
                const AuthTermsAndConditions(),
                const Spacer(flex: 8),
                Button(
                  text: 'Continue',
                  onClick: () {
                    if (_form.currentState?.validate() == true) {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.phoneNumberVerification,
                        arguments:
                            '${ref.read(_country)?.dialCode} ${_controller.text}',
                      );
                    }
                  },
                ),
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
      ),
    );
  }
}

class _NumberInput extends ConsumerStatefulWidget {
  const _NumberInput({
    Key? key,
    required this.controller,
    required this.country,
  }) : super(key: key);

  final TextEditingController controller;
  final StateProvider<Country?> country;

  @override
  ConsumerState<_NumberInput> createState() => _NumberInputState();
}

class _NumberInputState extends ConsumerState<_NumberInput> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final country = ref.watch(widget.country);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Phone Number',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: AppPadding.small / 2),
        Input(
          padding: const EdgeInsets.all(AppPadding.small),
          controller: widget.controller,
          keyboardType: TextInputType.number,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w500,
          ),
          maxLength: 10,
          validator: (value) {
            final number = value ?? '';
            if (country == null) {
              return 'Please select a dialing code from the modal';
            } else if (number.isEmpty) {
              return 'A phone number is required';
            } else if (int.tryParse(number) == null) {
              return 'Only numbers are allowed in this field';
            } else {
              return null;
            }
          },
          leading: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton.icon(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                    side: const BorderSide(),
                  ),
                ),
                onPressed: () => showModalBottomSheet(
                  context: context,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  builder: (ctx) => _CountryDialCodeSelector(
                    onCountryClicked: (value) {
                      ref.read(widget.country.notifier).state = value;
                      Navigator.pop(ctx);
                    },
                  ),
                ),
                icon: country != null ? Emoji(country.emoji) : const SizedBox(),
                label: Icon(
                  Icons.keyboard_arrow_down_outlined,
                  color: theme.textTheme.bodyMedium?.color ?? Colors.black,
                ),
              ),
              if (country?.dialCode != null) ...{
                const SizedBox(width: AppPadding.normal),
                Text(
                  country!.dialCode,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              },
              const SizedBox(width: AppPadding.small),
            ],
          ),
        ),
      ],
    );
  }
}

class _CountryDialCodeSelector extends StatefulWidget {
  const _CountryDialCodeSelector({
    Key? key,
    required this.onCountryClicked,
  }) : super(key: key);

  final Function(Country) onCountryClicked;

  @override
  State createState() => _CountryDialCodeSelectorState();
}

class _CountryDialCodeSelectorState extends State<_CountryDialCodeSelector> {
  final _queryKey = GlobalKey<FormState>();

  late final _query = StateProvider.autoDispose((ref) => '');

  late final _countriesQuery = StateProvider.autoDispose<List<Country>>((ref) {
    final query = ref.watch(_query);
    final countries = ref.watch(countryList);

    return countries.when(
      error: (error, stackTrace) => [],
      loading: () => [],
      data: (countryItems) {
        if (query.isEmpty) {
          return countryItems;
        } else {
          final searchQuery = query.toLowerCase().trim();
          return countryItems.where(
            (country) {
              return country.name.toLowerCase().contains(searchQuery);
            },
          ).toList();
        }
      },
    );
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppPadding.normal,
        horizontal: AppPadding.large,
      ),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SizedBox(
              width: double.infinity,
              child: Text(
                'Select your country',
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppPadding.medium),
              child: Consumer(builder: (_, ref, __) {
                return Form(
                  key: _queryKey,
                  child: TextFormField(
                    onChanged: (value) {
                      ref.read(_query.notifier).state = value;
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: theme.colorScheme.onPrimary,
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: const Icon(Icons.search),
                      hintText: 'Search country',
                    ),
                  ),
                );
              }),
            ),
          ),
          Consumer(
            builder: (_, ref, __) {
              final countries = ref.watch(_countriesQuery);
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, index) {
                    final country = countries[index];
                    return InkWell(
                      onTap: () => widget.onCountryClicked(country),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppPadding.small,
                        ),
                        child: Row(
                          children: [
                            Emoji(country.emoji),
                            const SizedBox(width: AppPadding.small),
                            Expanded(
                              child: Text(
                                country.name,
                                maxLines: 1,
                                style: theme.textTheme.bodyLarge,
                              ),
                            ),
                            Text(
                              country.dialCode,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  childCount: countries.length,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
