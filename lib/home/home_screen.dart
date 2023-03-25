import 'package:flutter/material.dart';

import '../common/configuration/app_resources.dart';
import 'home_getting_started.dart';
import 'home_header.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(primaryColor: const Color(0xFF3269FC)),
      child: const Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: HomeHeader()),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppPadding.medium,
                  vertical: AppPadding.large,
                ),
                child: HomeGettingStarted(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
