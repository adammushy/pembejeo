// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:flutter/rendering.dart';
// import 'dart:io';
import 'package:flutterwave_standard/flutterwave.dart';
import 'package:intl/intl.dart';
import 'package:Permit/constants/app_constants.dart';
import 'package:Permit/providers/service_management_provider.dart';
import 'package:Permit/shared-functions/float_snackbar.dart';
import 'package:Permit/shared-preference-manager/preference-manager.dart';
import 'package:Permit/views/other/qrdoc.dart';
import 'package:Permit/views/permits/request_form.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:document_file_save_plus/document_file_save_plus.dart';

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
    requestStoragePermission();
  }

  var userId;
  var userEmail;

  var usertype;
  getUserId() async {
    var sharedPref = SharedPreferencesManager();
    var localStorage = await sharedPref.getString(AppConstants.user);
    // print("User :: ${jsonDecode(user!)}");

    var user = jsonDecode(localStorage);
    setState(() {
      userId = user['id'];
      usertype = user['usertype'];
      userEmail = user['email'];

      print("user ID :: $userId");
      print("USERTYPE :: $usertype");
    });
  }

  String dateTimeFormat() {
    // Parse the original datetime string to a DateTime object
    DateTime originalDatetime = DateTime.now();

    // Format the DateTime object to show only date, hour, and minute
    String formattedDatetimeStr =
        DateFormat('yyyy-MM-dd HH:mm').format(originalDatetime);

    // print(formattedDatetimeStr);
    return formattedDatetimeStr; // Output: 2024-06-10 01:45
  }

  Future<bool> requestStoragePermission() async {
    PermissionStatus status = await Permission.manageExternalStorage.status;
    if (!status.isGranted) {
      // status = await Permission.accessMediaLocation.request();
      // status = await Permission.storage.request();
      // st = await Permission.storage.request();
      status = await Permission.manageExternalStorage.request();
    }
    return status.isGranted;
  }

  bool isTestMode = true;
  TextEditingController _amountController = TextEditingController();

  _handlePaymentInitialization(String email, String amount) async {
    final Customer customer = Customer(email: email);

    final Flutterwave flutterwave = Flutterwave(
      context: context,
      publicKey: 'FLWPUBK_TEST-ad169f46c21db341e24cbde5816d72bf-X',
      currency: "TZS",
      redirectUrl: 'https://www.google.com/',
      txRef: Uuid().v1(),
      amount: amount,
      customer: customer,
      paymentOptions: "card, payattitude, barter, bank transfer, ussd",
      customization: Customization(title: "Certificate Payment"),
      isTestMode: this.isTestMode,
    );

    final ChargeResponse response = await flutterwave.charge();
    if (mounted) {
      showLoading(response.toString());
    }
    print("RESPONSE :: ${response.toJson()}");

    return response;
  }

  Future<void> showLoading(String message) {
    if (!mounted) return Future.value(); // Ensure the widget is still mounted
    return showDialog(
      context: this.context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            margin: EdgeInsets.fromLTRB(30, 20, 30, 20),
            width: double.infinity,
            height: 50,
            child: Text(message),
          ),
        );
      },
    );
  }

  Future<void> _showAmountDialog(
      BuildContext context, String email, String permit) async {
    _amountController.clear();
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Amount'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                  "You are required to pay 10,000 Tshs. to get the Certificate"),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(hintText: "Enter amount"),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Proceed'),
              onPressed: () async {
                var data = {"id": permit, "payment": "PAID"};
                // Provider.of<ServiceManagementProvider>(context, listen: false)
                //     .changeStatus(data);

                // _handlePaymentInitialization(email, _amountController.text);

                var res = await _handlePaymentInitialization(
                    email, _amountController.text);

                res = res.toJson();
                if (res['success']) {
                  var result = Provider.of<ServiceManagementProvider>(context,
                          listen: false)
                      .changePaymentStatus(data);
                  if (res) {
                    ShowMToast(context).successToast(
                        message: "Payment Success",
                        alignment: Alignment.center);
                    Navigator.of(context).pop();
                  }
                  {
                    ShowMToast(context).errorToast(
                        message: "Payment Failed", alignment: Alignment.center);
                    Navigator.of(context).pop();
                  }
                  // Navigator.of(context).pop();
                } else {
                  ShowMToast(context).errorToast(
                      message: "Payment Failed", alignment: Alignment.center);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
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

        String day =
            DateFormat.d().format(DateTime.parse(permit['created_at']));
        String formattedDate =
            DateFormat('MMM-yyyy').format(DateTime.parse(permit['created_at']));

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
                            // "20",
                            day,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            // "aug-2020",
                            formattedDate,
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        // Icon(_getIconForStatus(status), color: statusColor),
                        Text("${permit['status']}",
                            style: TextStyle(color: Colors.black)),
                        // Text("${permit['payment']}",
                        //     style: TextStyle(color: Colors.black))
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4), // Add padding to the container
                          decoration: BoxDecoration(
                            color: permit['payment'] == "PAID"
                                ? Colors.green
                                : Colors.red,
                            borderRadius: BorderRadius.circular(
                                4), // Optional: Add border radius
                          ),
                          child: Text(
                            "${permit['payment']}",
                            style: TextStyle(
                                color: Colors
                                    .white), // Set text color to white for better contrast
                          ),
                        ),
                      ],
                    ),
                    trailing: permit['status'] == 'PERMITED'
                        ? (permit['payment'] == 'PAID'
                            ? InkWell(
                                onTap: () async {
                                  var res = await generatePDF(
                                    permit['issued_by']['username'],
                                    permit['issued_by']['phone'],
                                    permit['permit_typec'],
                                    permit['livestock_number'].toString(),
                                    permit['customer']['username'],
                                    permit['permit_number'],
                                    permit,
                                    permit['issued_at'],
                                  );
                                  print("response ${res}");
                                },
                                child: Icon(Icons.download,
                                    color: Colors.black, size: 30.0),
                              )
                            : InkWell(
                                onTap: () {
                                  _showAmountDialog(
                                      context, userEmail, permit['id']);
                                },
                                child: Icon(Icons.keyboard_arrow_right,
                                    color: Colors.black, size: 30.0),
                              ))
                        : Icon(Icons.keyboard_arrow_right,
                            color: Colors.black, size: 30.0)),
              )),
        );
      },
    );
  }

  Future<pw.Document> generatePDF(
    String officerName,
    String officerPhone,
    String permitType,
    String numbers,
    String customer,
    String permitNo,
    Map<String, dynamic> data,
    // String animalType,
    String issuedDate,

    // String paymentDate
  ) async {
    final pdf = pw.Document();
    final image = await rootBundle
        .load('assets/images/permit.png'); // Load your logo image
    // final imageQrCode =
    //     await rootBundle.load('assets/qrcode.png'); // Load your QR code image
    final Uint8List logo = image.buffer.asUint8List();
    // final imageQrCode = PrettyQrView.data(
    //   data: jsonEncode(data),
    //   decoration: PrettyQrDecoration(
    //     image: PrettyQrDecorationImage(
    //       image: AssetImage("assets/images/Koba.png"),
    //     ),
    //   ),
    // );
    // final Uint8List qrCode = imageQrCode.buffer.asUint8List();
    var dateIssue = DateTime.parse(issuedDate);
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Align(
                alignment: pw.Alignment.center,
                child: pw.Image(pw.MemoryImage(logo),
                    height: 100), // Adjust the height
              ),
              pw.SizedBox(height: 5),
              pw.Center(
                child: pw.Text(
                  'THE UNITED REPUBLIC OF TANZANIA\n  LICENSE',
                  style: pw.TextStyle(
                      fontSize: 14, fontWeight: pw.FontWeight.bold),
                  textAlign: pw.TextAlign.center,
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Center(
                child: pw.Text(
                  'CERT NO: ${permitNo.toString() ?? "3353343545676"}\n'
                  '',
                  style: pw.TextStyle(fontSize: 12),
                  textAlign: pw.TextAlign.center,
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Text(
                'Issuing Office:\n${officerName.toUpperCase()}\nTel: ${officerPhone}',
                style: pw.TextStyle(fontSize: 12),
              ),
              pw.SizedBox(height: 10),
              pw.Text(
                'License Issued To:\n${customer.toUpperCase()}',
                style: pw.TextStyle(fontSize: 12),
              ),
              pw.SizedBox(height: 10),
              pw.Text(
                'for the ${permitType} of:\n ${numbers}  animals',
                style: pw.TextStyle(fontSize: 12),
              ),
              pw.SizedBox(height: 10),
              pw.Text(
                'From: Mkeya\nTo: Bosari\n',
                style: pw.TextStyle(fontSize: 12),
              ),
              pw.SizedBox(height: 10),
              pw.Text(
                'Issued On: ${DateFormat('yyyy-MM-dd HH:mm').format(dateIssue)}\n',
                style: pw.TextStyle(fontSize: 12),
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                'NOTE: This is a Digital Copy does not require a signature of authority.\n'
                'NOTE: This Permit is not Transferable. It is not a congestion authorized to the place of\n'
                'business. It is for the business described above and in the event of any changes of place\n'
                'or business should notify the Issuing Authority.',
                style: pw.TextStyle(fontSize: 10),
                textAlign: pw.TextAlign.center,
              ),
              pw.SizedBox(height: 20),
              // pw.Align(
              //   alignment: pw.Alignment.center,
              //   child: pw.Image(pw.MemoryImage(logo), height: 100),
              // ),
            ],
          );
        },
      ),
    );
    final directory = Directory('/storage/emulated/0/Vibali');
    if (!(await directory.exists())) {
      await directory.create(recursive: true);
    }

    // Define the file path
    final filePath = "${directory.path}/kilbali.pdf";

    // Save the PDF bytes
    final pdfBytes = await pdf.save();
    final file = File(filePath);
    await file.writeAsBytes(pdfBytes.toList());
    var save = DocumentFileSavePlus().saveFile(pdfBytes,
        "Kibali${DateTime.now().toIso8601String()}.pdf", "Kibali/pdf");

    ShowMToast(context).successToast(
        message: "PDF saved successfully at ${save}",
        alignment: Alignment.bottomCenter);

    return pdf;
  }
}
