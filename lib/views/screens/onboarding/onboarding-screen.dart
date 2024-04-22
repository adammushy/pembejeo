// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:pembejeo/constants/images.dart';
import 'package:pembejeo/views/screens/menu/bottom_nav_bar.dart';
import 'package:intro_screen_onboarding_flutter/intro_app.dart';

class OnboardingScreen extends StatelessWidget {
  final List<Introduction> list = [
    Introduction(
      title: 'Delivery',
      subTitle: 'Your order will be immediately collected and',
      imageUrl: Images.onboard_1,
    ),
    Introduction(
      title: 'Receive Money',
      subTitle: 'Pick up delivery at your door and enjoy groceries',
      imageUrl: Images.onboard_2,
    ),
    Introduction(
      title: 'Finish',
      subTitle: 'Browse the menu and order directly from the application',
      imageUrl: Images.onboard_3,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return IntroScreenOnboarding(
      introductionList: list,
      onTapSkipButton: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const BottomNavigationBarMenu()),
        );
      },
    );
  }
}
