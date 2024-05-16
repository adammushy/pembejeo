// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pembejeo/constants/app_constants.dart';
import 'package:pembejeo/providers/service_management_provider.dart';
import 'package:pembejeo/shared-preference-manager/preference-manager.dart';
import 'package:pembejeo/views/permits/request_form.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController searchController = TextEditingController();
  bool _isSearching = false;
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    Provider.of<ServiceManagementProvider>(context, listen: false)
        .getAllPermits();
    getUserId();
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
      print("USERTYPE :: $usertype");

    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.white,
          title: Center(
            child: Text(
              "My Permits",
              textAlign: TextAlign.center,
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                setState(() {
                  _isSearching = !_isSearching;
                  _searchText = '';
                  if (!_isSearching) {
                    // _filteredOrders = _orders;
                  }
                });
              },
            )
          ],
          bottom: TabBar(
            indicatorColor: Color.fromARGB(255, 179, 255, 247),
            tabs: [
              Tab(text: 'Pending'),
              Tab(text: 'Cancel'),
              Tab(text: 'Accepted'),
            ],
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: TabBarView(
                  children: [
                    _buildOrderListView('PENDING'),
                    _buildOrderListView('CANCELED'),
                    _buildOrderListView('PERMITED'),
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: IconButton(
            color: Colors.blueGrey,
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => RequestPermitForm()));
            },
            icon: Icon(Icons.add)),
      ),
    );
  }

  Widget _buildOrderListView(String status) {
    // List<OrderModel> orders = _getOrdersByStatus(status);
    var permits = Provider.of<ServiceManagementProvider>(context, listen: true)
        .allPermits;
    // Filter permits based on status
    var filteredPermits =
        permits.where((permit) => permit['status'] == status).toList();

    return ListView.builder(
      itemCount: filteredPermits.length,
      // itemCount: permits.length,

      itemBuilder: (BuildContext context, int index) {
        // var permit = permits[index];
        var permit = filteredPermits[index];

        return InkWell(
          onTap: () {
            print("order clicked");
          },
          child: Card(
              //  borderOnForeground: true,
              // shape: CircleBorder,
              elevation: 8.0,
              margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Color.fromRGBO(255, 255, 255, 0.898),
                    borderRadius: BorderRadius.circular(1)),
                child: ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    leading: Container(
                      padding: EdgeInsets.only(right: 12.0),
                      decoration: new BoxDecoration(
                          border: new Border(
                              right: new BorderSide(
                                  width: 1.0, color: Colors.white))),
                      // child: Icon(Icons.autorenew, color: Colors.black),

                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "20",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "aug-2020",
                            style: TextStyle(fontSize: 8),
                          )
                        ],
                      ),
                    ),
                    title: Text(
                      "${permit['customer']['firstname']} ${permit['customer']['lastname']}",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                    subtitle: Row(
                      children: <Widget>[
                        // Icon(_getIconForStatus(status), color: statusColor),
                        Text("${permit['status']}",
                            style: TextStyle(color: Colors.black))
                      ],
                    ),
                    trailing: Icon(Icons.keyboard_arrow_right,
                        color: Colors.black, size: 30.0)),
              )),
        );
      },
    );
  }
}
