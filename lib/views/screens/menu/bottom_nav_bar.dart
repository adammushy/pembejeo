import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:bottom_bar/bottom_bar.dart';
import 'package:pembejeo/constants/app_colors.dart';
import 'package:pembejeo/constants/app_constants.dart';
import 'package:pembejeo/shared-preference-manager/preference-manager.dart';
import 'package:pembejeo/views/admin/dashboard.dart';
import 'package:pembejeo/views/other/admin_home.dart';
// import 'package:pembejeo/views/other/components/dashboard.dart';
// import 'package:pembejeo/views/other/dashboard.dart';
import 'package:pembejeo/views/other/home.dart';
import 'package:pembejeo/views/profile/profile.dart';

class BottomNavigationBarMenu extends StatefulWidget {
  const BottomNavigationBarMenu({super.key});

  @override
  State<BottomNavigationBarMenu> createState() =>
      _BottomNavigationBarMenuState();
}

class _BottomNavigationBarMenuState extends State<BottomNavigationBarMenu>
    with TickerProviderStateMixin {
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

  int _currentPage = 0;
  final _pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: const [
          // Center(child: Text("1")),

          HomeScreen(),
          // Center(child: Text("2")),
          // Center(child: Text("3")),
          MyProfile()
        ],
        onPageChanged: (index) {
          setState(() => _currentPage = index);
        },
      ),
      bottomNavigationBar: BottomBar(
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
        selectedIndex: _currentPage,
        onTap: (int index) {
          _pageController.jumpToPage(index);
          setState(() => _currentPage = index);
        },
        items: const <BottomBarItem>[
          BottomBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
            activeColor: AppColors.primaryColor,
          ),
          // BottomBarItem(
          //   icon: Icon(Icons.star),
          //   title: Text('Favourite'),
          //   activeColor: AppColors.primaryColor,
          // ),
          BottomBarItem(
            icon: Icon(Icons.person),
            title: Text('Profile'),
            backgroundColorOpacity: 0.1,
            activeColor: AppColors.primaryColor,
          )
        ],
      ),
    );
  }
}

class AdminBottomNavigationBarMenu extends StatefulWidget {
  const AdminBottomNavigationBarMenu({super.key});

  @override
  State<AdminBottomNavigationBarMenu> createState() =>
      _AdminBottomNavigationBarMenuState();
}

class _AdminBottomNavigationBarMenuState
    extends State<AdminBottomNavigationBarMenu> with TickerProviderStateMixin {
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

  int _currentPage = 0;
  final _pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: const [
          // Center(child: Text("1")),
          DashboardScreen(),
          // AdminHomeScreen(),
          // Center(child: Text("2")),
          // Center(child: Text("3")),
          MyProfile()
        ],
        onPageChanged: (index) {
          setState(() => _currentPage = index);
        },
      ),
      bottomNavigationBar: BottomBar(
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
        selectedIndex: _currentPage,
        onTap: (int index) {
          _pageController.jumpToPage(index);
          setState(() => _currentPage = index);
        },
        items: const <BottomBarItem>[
          BottomBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
            activeColor: AppColors.primaryColor,
          ),
          // BottomBarItem(
          //   icon: Icon(Icons.local_shipping),
          //   title: Text('Home'),
          //   activeColor: AppColors.primaryColor,
          // ),
          // BottomBarItem(
          //   icon: Icon(Icons.star),
          //   title: Text('Favourite'),
          //   activeColor: AppColors.primaryColor,
          // ),
          BottomBarItem(
            icon: Icon(Icons.person),
            title: Text('Profile'),
            backgroundColorOpacity: 0.1,
            activeColor: AppColors.primaryColor,
          )
        ],
      ),
    );
  }
}
