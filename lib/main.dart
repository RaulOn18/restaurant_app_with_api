// import 'dart:io';

import 'package:flutter/material.dart';
import 'package:restaurant_app_with_api/config/theme/theme_config.dart';
import 'package:restaurant_app_with_api/pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurant App with API',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xffF55A51),
          primary: const Color(0xffF55A51),
          secondary: const Color(0xffffffff),
          background: const Color(0xfff5f5f5),
        ),
        useMaterial3: true,
        textTheme: ThemeConfig.textTheme,
      ),
      initialRoute: '/',
      routes: {
        HomePage.routeName: (context) => const HomePage(),
      },
    );
  }
}
