import 'package:flutter/material.dart';
import 'package:pembejeo/providers/service_management_provider.dart';
import 'package:pembejeo/providers/user_management_provider.dart';
import 'package:pembejeo/views/admin/dashboardcard.dart';
// import 'package:pembejeo/views/other/dashboardcard.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final dash = DashboardController();

  @override
  void initState() {
    super.initState();
    Provider.of<UserManagementProvider>(context, listen: false).fetchAllUsers();
    Provider.of<ServiceManagementProvider>(context, listen: false)
        .fetchAllPermits();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Panel"),
      ),
      body: SafeArea(
        child: GridView.builder(
          padding: EdgeInsets.symmetric(horizontal: 15),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 2 / 1.6,
          ),
          itemCount: dash.dashboardList.length,
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            return StatsCardTile(data: dash, index: index);
          },
        ),
      ),
    );
  }
}
