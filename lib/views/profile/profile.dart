// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:clean_dialog/clean_dialog.dart';
import 'package:flutter/material.dart';
import 'package:Permit/constants/app_constants.dart';
import 'package:Permit/constants/images.dart';
import 'package:Permit/shared-preference-manager/preference-manager.dart';
import 'package:Permit/views/profile/widgets.dart';
import 'package:Permit/views/screens/auth/login_user.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  var userId;

  var usertype;
  var user;

  @override
  void initState() {
    super.initState();
    getUserId();
  }

  getUserId() async {
    var sharedPref = SharedPreferencesManager();
    var localStorage = await sharedPref.getString(AppConstants.user);
    // print("User :: ${jsonDecode(user!)}");

    user = jsonDecode(localStorage);
    setState(() {
      userId = user['id'];
      usertype = user['usertype'];
      print("user ID :: $user");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => CleanDialog(
                    title: 'Confirm Logout',
                    content: 'Do you want Log out??',
                    backgroundColor: const Color(0XFFbe3a2c),
                    titleTextStyle: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                    contentTextStyle:
                        const TextStyle(fontSize: 16, color: Colors.white),
                    actions: [
                      CleanDialogActionButtons(
                        actionTitle: 'No',
                        onPressed: () {
                          // documentGenerator();
                          Navigator.pop(context);
                        },
                      ),
                      CleanDialogActionButtons(
                        actionTitle: 'Yes',
                        textColor: const Color(0XFF27ae61),
                        onPressed: () {
                          Navigator.pop(context);
                          SharedPreferencesManager()
                              .clearPreferenceByKey(AppConstants.isLogin);
                          SharedPreferencesManager()
                              .clearPreferenceByKey(AppConstants.user);

                          // ZegoUIKitPrebuiltCallInvitationService().uninit();

                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MyLogin(),
                              ));
                        },
                      ),
                    ],
                  ),
                );
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: user == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              physics: BouncingScrollPhysics(),
              children: [
                ProfileWidget(
                  imagePath: "assets/images/user.jpg",
                  onClicked: () {
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(builder: (context) => EditProfilePage()),
                    // );
                  },
                ),
                const SizedBox(height: 24),
                buildName(),
                const SizedBox(height: 24),
                // Center(child: buildUpgradeButton()),
                // const SizedBox(height: 24),
                // NumbersWidget(),
                const SizedBox(height: 48),
                buildAbout(),
              ],
            ),
    );
  }

  Widget buildName() => Column(
        children: [
          Text(
            // "Username",
            user['username'],
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(height: 4),
          Text(
            // "user email",
            user['email'],
            style: TextStyle(color: Colors.grey),
          )
        ],
      );

  // Widget buildUpgradeButton() => ButtonWidget(
  //       text: 'hehehe',
  //       onClicked: () {
  //         SharedPreferencesManager().clearPreferenceByKey(AppConstants.isLogin);
  //         SharedPreferencesManager().clearPreferenceByKey(AppConstants.user);
  //         // ZegoUIKitPrebuiltCallInvitationService().uninit();

  //         Navigator.pushReplacement(
  //             context,
  //             MaterialPageRoute(
  //               builder: (context) => const MyLogin(),
  //             ));
  //       },
  //     );

  Widget buildAbout() => Container(
        padding: EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'About',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              " I am  ${user['usertype']}",
              style: TextStyle(fontSize: 16, height: 1.4),
            ),
          ],
        ),
      );
}
