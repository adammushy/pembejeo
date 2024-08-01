// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:pembejeo/constants/app_constants.dart';
import 'package:pembejeo/providers/user_management_provider.dart';
import 'package:pembejeo/shared-functions/float_snackbar.dart';
import 'package:pembejeo/shared-preference-manager/preference-manager.dart';
import 'package:pembejeo/views/screens/auth/register_user.dart';
import 'package:pembejeo/views/screens/menu/bottom_nav_bar.dart';
import 'package:provider/provider.dart';
// import 'package:hive/hive.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:loginuicolors/home.dart';

class MyLogin extends StatefulWidget {
  const MyLogin({Key? key}) : super(key: key);

  @override
  _MyLoginState createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {
  bool isChecked = false;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, Color.fromARGB(255, 172, 163, 255)],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(),
            Container(
              padding: EdgeInsets.only(left: 35, top: 130),
              child: Text(
                'Welcome \nBack',
                style: TextStyle(color: Colors.black, fontSize: 33),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 35, right: 35),
                      child: Column(
                        children: [
                          TextField(
                            controller: email,
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                                fillColor: Colors.grey.shade100,
                                filled: true,
                                hintText: "Email",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          TextField(
                            controller: password,
                            style: TextStyle(),
                            obscureText: true,
                            decoration: InputDecoration(
                                fillColor: Colors.grey.shade100,
                                filled: true,
                                hintText: "Password",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          // Row(
                          //   crossAxisAlignment: CrossAxisAlignment.center,
                          //   children: [
                          //     Text(
                          //       "Remember Me",
                          //       style: TextStyle(color: Colors.black),
                          //     ),
                          //     Checkbox(
                          //       value: isChecked,
                          //       onChanged: (value) {
                          //         isChecked = !isChecked;
                          //         setState(() {});
                          //       },
                          //     ),
                          //   ],
                          // ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Sign in',
                                style: TextStyle(
                                    fontSize: 27, fontWeight: FontWeight.w700),
                              ),
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: Color(0xff4c505b),
                                child: IconButton(
                                    color: Colors.white,
                                    onPressed: () async {
                                      // login();
                                      var data = {
                                        "email": email.text,
                                        "password": password.text
                                      };
                                      print("data:: ${data}");
                                      Map<String, dynamic> result =
                                          await Provider.of<
                                                      UserManagementProvider>(
                                                  context,
                                                  listen: false)
                                              .userLogin(context, data);
                                      print("RESULT ::${result.toString()}");

                                      if (result['status']) {
                                        ShowMToast(context).successToast(
                                            message: "Login Successful",
                                            alignment: Alignment.bottomCenter);
                                        SharedPreferencesManager().saveBool(
                                            AppConstants.isLogin, true);

                                        if (result['body']['user']
                                                ['usertype'] ==
                                            'NORMAL') {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    BottomNavigationBarMenu()),
                                          );
                                        } else {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AdminBottomNavigationBarMenu()),
                                          );
                                        }
                                      } else {
                                        ShowMToast(context).successToast(
                                            message:
                                                "Login Failed. wrong Login credentials",
                                            alignment: Alignment.bottomCenter);
                                      }
                                    },
                                    icon: Icon(
                                      Icons.arrow_forward,
                                    )),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MyRegister(),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Sign Up',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Color(0xff4c505b),
                                      fontSize: 18),
                                ),
                                style: ButtonStyle(),
                              ),
                              // TextButton(
                              //     onPressed: () {},
                              //     child: Text(
                              //       'Forgot Password',
                              //       style: TextStyle(
                              //         decoration: TextDecoration.underline,
                              //         color: Color(0xff4c505b),
                              //         fontSize: 18,
                              //       ),
                              //     ),),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

//   void login() {
//     if (isChecked) {
//       box1.put('email', email.text);
//       box1.put('password', password.text);
//     }
//   }
}
