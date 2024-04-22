import 'package:flutter/material.dart';
import 'package:bottom_bar/bottom_bar.dart';
import 'package:pembejeo/constants/app_colors.dart';

class BottomNavigationBarMenu extends StatefulWidget {
  const BottomNavigationBarMenu({super.key});

  @override
  State<BottomNavigationBarMenu> createState() =>
      _BottomNavigationBarMenuState();
}

class _BottomNavigationBarMenuState extends State<BottomNavigationBarMenu>
    with TickerProviderStateMixin {
  int _currentPage = 0;
  final _pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: const [
          Center(child: Text("1")),
          Center(child: Text("2")),
          Center(child: Text("3")),
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
          BottomBarItem(
            icon: Icon(Icons.star),
            title: Text('Favourite'),
            activeColor: AppColors.primaryColor,
          ),
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
