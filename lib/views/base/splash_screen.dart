import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:Permit/constants/app_constants.dart';
import 'package:Permit/constants/dimensions.dart';
import 'package:Permit/constants/images.dart';
import 'package:Permit/providers/user_management_provider.dart';
import 'package:Permit/shared-preference-manager/preference-manager.dart';
import 'package:Permit/views/screens/auth/login_user.dart';
import 'package:Permit/views/screens/menu/bottom_nav_bar.dart';
import 'package:Permit/views/screens/onboarding/onboarding-screen.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    getUserId();
    Future.delayed(const Duration(seconds: 3), () async {
      var isLogin =
          await SharedPreferencesManager().getBool(AppConstants.isLogin);

      if (isLogin == true) {
        usertype == "ADMIN"
            ? Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => AdminBottomNavigationBarMenu()),
              )
            : Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => BottomNavigationBarMenu()),
              );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MyLogin()),
        );
      }
      // var isNotFirstLogin = await SharedPreferencesManager()
      //     .getBool(AppConstants.isNotFirstLogin);
      // if (isNotFirstLogin == false) {
      //   Navigator.pop(context);
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(builder: (context) => OnboardingScreen()),
      //   );
      // } else {
      // if (isLogin == true) {
      // bool hasDOB =
      //     await Provider.of<UserManagementProvider>(context, listen: false)
      //         .hasDateOfBirth();
      // if (hasDOB) {
      //   Navigator.pop(context);
      //   Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) => const BottomNavigationBarMenu(),
      //       ));
      // } else {
      //   // var userAccount = await SharedPreferencesManager()
      //   //     .getString(AppConstants.userAccount);
      //   // Navigator.pop(context);
      //   // Navigator.push(
      //   //     context,
      //   //     MaterialPageRoute(
      //   //       builder: (context) => EditAdditionalDetailsScreen(
      //   //           accountId: jsonDecode(userAccount)['id']),
      //   //     ));
      // }
      //   }
      //   else {
      //     Navigator.pop(context);
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(builder: (context) => const LoginScreen()),
      //     );
      //   }
      // }
    });
  }

  var userId;

  var usertype;
  getUserId() async {
    var sharedPref = SharedPreferencesManager();
    var localStorage = await sharedPref.getString(AppConstants.user);
    // print("User :: ${jsonDecode(user!)}");

    var user = jsonDecode(localStorage);
    setState(() {
      userId = user['id'];
      usertype = user['usertype'];
      print("user ID :: $userId");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: Dimensions.quarterScreenHeight(context),
            ),
            Image.asset(
              Images.splashImage,
              height: 200,
            ),
            const Text("Temp App"),
          ],
        ),
      ),
    );
  }
}
