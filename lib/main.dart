import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:yogayatra/firebase_options.dart';
import 'package:yogayatra/fontsizManager/fontsizeManager.dart';
import 'package:yogayatra/googlemaps.dart';
import 'package:yogayatra/splashScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  // Widget build(BuildContext context) {
  //   return MaterialApp(
  //     title: 'Flutter Demos',
  //     debugShowCheckedModeBanner: false,
  //     theme: ThemeData(
  //       colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
  //       useMaterial3: true,
  //     ),
  //     home: const SplashScreen(),
  //   );
  // }
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double>(
      valueListenable: FontSizeManager.fontSizeNotifier,
      builder: (context, fontSize, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            textTheme: TextTheme(
              bodyMedium: TextStyle(fontSize: fontSize),
              titleLarge: TextStyle(fontSize: fontSize),
            ),
          ),
          home: const SplashScreen(),
        );
      },
    );
  }
}
