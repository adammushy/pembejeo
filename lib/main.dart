import 'package:flutter/material.dart';
import 'package:Permit/providers/default_provider.dart';
import 'package:Permit/providers/service_management_provider.dart';
import 'package:Permit/providers/user_management_provider.dart';
import 'package:Permit/views/base/splash_screen.dart';
import 'package:Permit/views/screens/auth/login_user.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => DefaultProvider()),
        ChangeNotifierProvider(create: (context) => UserManagementProvider()),
        ChangeNotifierProvider(
            create: (context) => ServiceManagementProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SplashScreen(),
      // home: MyLogin(),
    );
  }
}
