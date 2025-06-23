import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:atomus/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Splashscreen extends StatelessWidget {
  const Splashscreen({super.key});

  get splash => 'lib/animations/loadingAnimation.json';

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Column(
        children: [
          Center(
            child: LottieBuilder.asset(splash),
          ),
        ],
      ),
      backgroundColor: Colors.black,
      splashIconSize: MediaQuery.of(context).size.height * 0.6,
      nextScreen: HomePage(),
      duration: 6200,
      splashTransition: SplashTransition.fadeTransition,
    );
  }
}
