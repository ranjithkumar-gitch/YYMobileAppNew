import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:yogayatra/onboardingScreens/onboardingScreens.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 5),
        () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const Onboardingscreens(),
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor("#018a3c"),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 220,
            ),
            Center(
              child: CircleAvatar(
                radius: 100,
                backgroundColor: Colors.green,
                backgroundImage: const AssetImage('images/yogayatralogo.png'),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Text(
              "YogaYatra",
              style: GoogleFonts.poppins(
                fontSize: 35,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


            //  Center(
            //   child: Container(
            //    height: 150, width: 140,
            //     decoration: BoxDecoration(
            //       shape: BoxShape.circle,
            //       color: Colors.white,
            //       border: Border.all(
            //         color: Colors.green, 
            //         width: 4
            //       ),
            //     ),
            //     child: const CircleAvatar(
            //       radius: 100,
            //       backgroundColor: Colors.white,
            //       backgroundImage: AssetImage('images/yogayatralogo.png'),
            //     ),
            //   ),
            // ),
