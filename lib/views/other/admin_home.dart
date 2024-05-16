// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_string_interpolations

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pembejeo/constants/app_constants.dart';
import 'package:pembejeo/providers/service_management_provider.dart';
import 'package:pembejeo/shared-preference-manager/preference-manager.dart';
import 'package:provider/provider.dart';
import 'package:clean_dialog/clean_dialog.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:open_file/open_file.dart';
// import 'package:downloads_path_provider/downloads_path_provider.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<ServiceManagementProvider>(context, listen: false)
        .fetchAllPermits();
    getUserId();
    getExternalDocumentPath();
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

  Future<void> documentGenerator() async {
    final pdf = pw.Document();
    // final image = pw.MemoryImage(
    //   File('love.png').readAsBytesSync(),
    // );
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          // return pw.Center(
          // child: pw.Text('Hello World!'),
          // );

          return pw.Column(children: [
            pw.Center(
              child: pw.Text("Certificate For Permit"),
            ),
            pw.SizedBox(height: 40),
            pw.Center(
              child: pw.Container(
                alignment: pw.Alignment.center,
                child: pw.Text("image Here"),
              ),
            ),
          ]);
        },
      ),
    );
    //   final String directory = await getExternalDocumentPath();

    //   File file = File(directory);
    //   await file.writeAsBytes(await pdf.save());
    //   print("file path :: $directory");

    //   print('File saved at: $directory');

    // Get the directory where your app can store files
    final directory = await getExternalStorageDirectory();
    if (directory == null) {
      print('Error: Unable to get external storage directory.');
      return;
    }

    final filePath = '${directory.path}/example.pdf';
    final file = File(filePath);

    // Save the PDF document to the file
    await file.writeAsBytes(await pdf.save());

    // Open the PDF file
    OpenFile.open(filePath);
  }

  Future<String> getExternalDocumentPath() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    Directory _directory = Directory("dir");
    if (Platform.isAndroid) {
      _directory = Directory("/storage/emulated/0/Download/Project Orphans");
    } else {
      _directory = await getApplicationDocumentsDirectory();
    }

    final exPath = _directory.path;
    print("Saved Path: $exPath");
    await Directory(exPath).create(recursive: true);
    return exPath;
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
          bottom: TabBar(
            indicatorColor: Color.fromARGB(255, 179, 255, 247),
            tabs: [
              Tab(text: 'Pending'),
              Tab(text: 'Cancel'),
              Tab(text: 'Permited'),
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
      ),
    );
  }

  Widget _buildOrderListView(String status) {
    // List<OrderModel> orders = _getOrdersByStatus(status);
    var permits = Provider.of<ServiceManagementProvider>(context, listen: true)
        .allSysPermits;
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
            // print("order clicked");
            if (status == "PENDING") {
              showDialog(
                context: context,
                builder: (context) => CleanDialog(
                   
                  title: permit['permit_typec'],
                  content:
                      '${permit['customer']['firstname']} ${permit['customer']['lastname']} \n ${permit['customer']['phone']} \n ${permit['customer']['email']} \n no of LiveStock : ${permit['livestock_number']}',
                  backgroundColor: const Color(0XFFbe3a2c),
                  titleTextStyle: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  contentTextStyle:
                      const TextStyle(fontSize: 16, color: Colors.white),
                  actions: [
                    CleanDialogActionButtons(
                      actionTitle: 'Cancel',
                      onPressed: () {
                        // documentGenerator();
                        Navigator.pop(context);

                        
                      },
                    ),
                    CleanDialogActionButtons(
                      actionTitle: 'Accept',
                      textColor: const Color(0XFF27ae61),
                      onPressed: () {
                        var data = {
                          "id": permit['id'],
                          "request_user": userId,
                          "status": "PERMITED"
                        };
                        Provider.of<ServiceManagementProvider>(context,
                                listen: false)
                            .changeStatus(data);

                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              );
            } else {
              print("order clicked");
            }
          },
          child: Card(
              //  borderOnForeground: true,
              // shape: CircleBorder,
              elevation: 8.0,
              margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Color.fromRGBO(255, 255, 255, 0.898),
                    borderRadius: BorderRadius.circular(1)),
                child: ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    leading: Container(
                      padding: EdgeInsets.only(right: 12.0),
                      decoration: BoxDecoration(
                          border: Border(
                              right:
                                  BorderSide(width: 1.0, color: Colors.white))),
                      // child: Icon(Icons.autorenew, color: Colors.black),

                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            // "20",
                            // "${permit['created_at'].day.toString()}",
                            DateTime.parse(permit['created_at']).day.toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            // "aug-2020",
                            // "${AppConstants.getMonthAbbreviation(permit['created_at'].month).toString()}",
                            "${AppConstants.getMonthAbbreviation(DateTime.parse(permit['created_at']).month).toString()}",
                            style: TextStyle(
                              fontSize: 16,
                            ),
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
                        Text(
                          "${permit['status']}",
                          style: TextStyle(color: Colors.black),
                        ),
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
