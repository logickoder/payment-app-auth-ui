import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../common/configuration/app_resources.dart';
import '../common/data/models/country.dart';

class PhoneNumberCodes extends StatefulWidget {
  const PhoneNumberCodes({Key? key}) : super(key: key);

  @override
  State<PhoneNumberCodes> createState() => _PhoneNumberCodesState();
}

class _PhoneNumberCodesState extends State<PhoneNumberCodes> {
  // holds the currently selected country
  final _country = StateProvider.autoDispose<Country?>((ref) => null);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Phone Number',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        TextFormField(
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: theme.colorScheme.primary),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: theme.textTheme.bodyMedium?.color ?? Colors.black,
              ),
            ),
            prefixIcon: Consumer(builder: (_, ref, __) {
              final country = ref.watch(_country);
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppPadding.small,
                ),
                child: TextButton.icon(
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
                        ref.read(_country.notifier).state = value;
                        Navigator.pop(ctx);
                      },
                    ),
                  ),
                  icon:
                      country != null ? Text(country.emoji) : const SizedBox(),
                  label: Icon(
                    Icons.keyboard_arrow_down_outlined,
                    color: theme.textTheme.bodyMedium?.color ?? Colors.black,
                  ),
                ),
              );
            }),
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
  // load the countries from the json asset
  static final _countries = FutureProvider.autoDispose((ref) async {
    final json = await rootBundle.loadString('assets/data/countries.json');
    final countries = jsonDecode(json) as List<dynamic>;
    return countries.map((e) => Country.fromJson(e)).toList();
  });

  final _queryKey = GlobalKey<FormState>();

  late final _query = StateProvider.autoDispose((ref) => '');

  late final _countriesQuery = StateProvider.autoDispose<List<Country>>((ref) {
    final query = ref.watch(_query);
    final countries = ref.watch(_countries);

    return countries.when(
      error: (error, stackTrace) => [],
      loading: () => [],
      data: (countriesList) {
        if (query.isEmpty) {
          return countriesList;
        } else {
          final searchQuery = query.toLowerCase().trim();
          return countriesList.where(
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
                            Text(country.emoji),
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
