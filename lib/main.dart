import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'common/configuration/app_resources.dart';
import 'common/configuration/app_routes.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: 'Payment App Auth UI',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: AppFonts.defaultFont,
          colorScheme: const ColorScheme.light(
            primary: AppColors.primary,
          ),
          scaffoldBackgroundColor: const Color(0xFFF7F9FD),
          textTheme: Theme.of(context).textTheme.apply(
                displayColor: AppColors.text,
                bodyColor: AppColors.text,
              ),
        ),
        routes: AppRoutes.routes,
      ),
    );
  }
}
