import 'package:flutter/material.dart';

import 'common/configuration/app_resources.dart';
import 'common/configuration/app_routes.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Payment App Auth UI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: AppFonts.defaultFont,
        colorScheme: const ColorScheme.light(
          primary: AppColors.primary,
        ),
        textTheme: Theme.of(context).textTheme.apply(
              displayColor: AppColors.text,
              bodyColor: AppColors.text,
            ),
      ),
      routes: AppRoutes.routes,
    );
  }
}
