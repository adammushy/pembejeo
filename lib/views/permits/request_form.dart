// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:Permit/constants/app_constants.dart';
import 'package:Permit/providers/service_management_provider.dart';
import 'package:Permit/shared-preference-manager/preference-manager.dart';
import 'package:provider/provider.dart';

class RequestPermitForm extends StatefulWidget {
  const RequestPermitForm({super.key});

  @override
  State<RequestPermitForm> createState() => _RequestPermitFormState();
}

class _RequestPermitFormState extends State<RequestPermitForm> {
  int _activeStepIndex = 0;
  String? _selectedRegion;
  String? _selectedRegion2;

  String? _selectedPermitType;
  String? _selectedAnimalType;

  TextEditingController name = TextEditingController();
  TextEditingController transport = TextEditingController();

  TextEditingController phone = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController total = TextEditingController();

  var userId;

  var userrid;
  getUserId() async {
    var sharedPref = SharedPreferencesManager();
    var localStorage = await sharedPref.getString(AppConstants.user);
    // print("User :: ${jsonDecode(user!)}");

    var user = jsonDecode(localStorage);
    setState(() {
      userId = user['id'];
      name.text = user['username'];
      email.text = user['email'];
      phone.text = user['phone'];
      print("user ID :: $userId");
    });
  }

  @override
  void initState() {
    super.initState();

    getUserId();
  }

  List<Step> stepList() => [
        Step(
          state: _activeStepIndex <= 0 ? StepState.editing : StepState.complete,
          isActive: _activeStepIndex >= 0,
          title: const Text(
            'Basic Information',
            style: TextStyle(fontFamily: 'Bebas', letterSpacing: 2),
          ),
          content: Container(
            child: Column(
              children: [
                TextField(
                  controller: name,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Full Name',
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                TextField(
                  controller: email,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                TextField(
                  controller: phone,
                  keyboardType: TextInputType.phone,

                  // obscureText: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Phone',
                  ),
                ),
              ],
            ),
          ),
        ),
        Step(
            state:
                _activeStepIndex <= 1 ? StepState.editing : StepState.complete,
            isActive: _activeStepIndex >= 1,
            title: const Text(
              'Permit Information',
              style: TextStyle(
                fontFamily: 'Bebas',
                letterSpacing: 2,
              ),
            ),
            content: Container(
              child: Column(
                children: [
                  // const SizedBox(
                  //   height: 8,
                  // ),
                  // TextField(
                  //   controller: address,
                  //   decoration: const InputDecoration(
                  //     border: OutlineInputBorder(),
                  //     labelText: 'Present Address',
                  //   ),
                  // ),
                  const SizedBox(
                    height: 8,
                  ),
                  DropdownButtonFormField<String>(
                    value: _selectedRegion,
                    icon: const Icon(Icons.arrow_downward),
                    decoration: const InputDecoration(
                      labelText: 'From',
                      labelStyle: TextStyle(
                        // color: Color(0xFFF92306),
                        fontSize: 12,
                      ),
                      border: OutlineInputBorder(),
                    ),
                    items: AppConstants.regions.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedRegion = newValue;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  DropdownButtonFormField<String>(
                    value: _selectedRegion2,
                    icon: const Icon(Icons.arrow_downward),
                    decoration: const InputDecoration(
                      labelText: 'To',
                      labelStyle: TextStyle(
                        // color: Color(0xFFF92306),
                        fontSize: 12,
                      ),
                      border: OutlineInputBorder(),
                    ),
                    items: AppConstants.regions.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedRegion2 = newValue;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  DropdownButtonFormField<String>(
                    value: _selectedPermitType,
                    icon: const Icon(Icons.arrow_downward),
                    decoration: const InputDecoration(
                      labelText: 'Permit type',
                      labelStyle: TextStyle(
                        // color: Color(0xFFF92306),
                        fontSize: 12,
                      ),
                      border: OutlineInputBorder(),
                    ),
                    items: AppConstants.permits.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedPermitType = newValue;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  if (_selectedPermitType == 'TRANSFER')
                    TextField(
                      controller: transport,
                      decoration: const InputDecoration(
                        hintText: "T123 xyz",
                        border: OutlineInputBorder(),
                        labelText: 'Transportation Details',
                      ),
                    ),
                  const SizedBox(
                    height: 8,
                  ),
                  DropdownButtonFormField<String>(
                    value: _selectedAnimalType,
                    icon: const Icon(Icons.arrow_downward),
                    decoration: const InputDecoration(
                      labelText: 'Animal type',
                      labelStyle: TextStyle(
                        // color: Color(0xFFF92306),
                        fontSize: 12,
                      ),
                      border: OutlineInputBorder(),
                    ),
                    items: AppConstants.animals.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedAnimalType = newValue;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextField(
                    controller: total,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Number of Cattles',
                    ),
                  ),
                ],
              ),
            )),
        Step(
            state: StepState.complete,
            isActive: _activeStepIndex >= 2,
            title: const Text(
              'Confirm Details',
              style: TextStyle(
                fontFamily: 'Bebas',
                letterSpacing: 2,
              ),
            ),
            content: Container(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Name: ${name.text}'),
                Text('Email: ${email.text}'),
                Text('Phone : ${phone.text}'),
                Text('From : ${_selectedRegion}'),
                Text('To : ${_selectedRegion2}'),
                Text('Permit type : ${_selectedPermitType}'),
                Text('Transport : ${transport.text}'),
                Text('Animal type : ${_selectedAnimalType}'),
                Text('Total Cattle : ${total.text}'),
              ],
            )))
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Request Permit Form"),
      ),
      body: Stepper(
        type: StepperType.vertical,
        currentStep: _activeStepIndex,
        steps: stepList(),
        onStepContinue: () {
          if (_activeStepIndex < (stepList().length - 1)) {
            setState(() {
              _activeStepIndex += 1;
            });
          } else {
            print('Submited');
            var data = {
              "customer": userId,
              "livestock_number": total.text,
              "permit_typec": _selectedPermitType,
              "transport": transport.text ?? '',
              "issued_at": DateTime.now().toIso8601String()
            };
            print("data:: ${data}");

            var result =
                Provider.of<ServiceManagementProvider>(context, listen: false)
                    .createPermit(data);
            if (result == true) {
              print("Succesfully");
            } else {
              print("Failed");
            }
            Navigator.pop(context);
          }
        },
        onStepCancel: () {
          if (_activeStepIndex == 0) {
            return;
          }

          setState(() {
            _activeStepIndex -= 1;
          });
        },
        onStepTapped: (int index) {
          setState(() {
            _activeStepIndex = index;
          });
        },
        // controlsBuilder: (context, {onStepContinue, onStepCancel}) {
        //   final isLastStep = _activeStepIndex == stepList().length - 1;
        //   return Container(
        //     child: Row(
        //       children: [
        //         Expanded(
        //           child: ElevatedButton(
        //             onPressed: onStepContinue,
        //             child: (isLastStep)
        //                 ? const Text('Submit')
        //                 : const Text('Next'),
        //           ),
        //         ),
        //         const SizedBox(
        //           width: 10,
        //         ),
        //         if (_activeStepIndex > 0)
        //           Expanded(
        //             child: ElevatedButton(
        //               onPressed: onStepCancel,
        //               child: const Text('Back'),
        //             ),
        //           )
        //       ],
        //     ),
        //   );
        // },
      ),
    );
  }
}

















// // ignore_for_file: prefer_const_constructors

// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:Permit/constants/app_constants.dart';
// import 'package:Permit/providers/service_management_provider.dart';
// import 'package:Permit/shared-preference-manager/preference-manager.dart';
// import 'package:provider/provider.dart';

// import 'package:flutterwave_standard/flutterwave.dart';
// import 'package:uuid/uuid.dart';

// class RequestPermitForm extends StatefulWidget {
//   const RequestPermitForm({super.key});

//   @override
//   State<RequestPermitForm> createState() => _RequestPermitFormState();
// }

// class _RequestPermitFormState extends State<RequestPermitForm> {
//   int _activeStepIndex = 0;
//   String? _selectedRegion;
//   String? _selectedRegion2;

//   String? _selectedPermitType;
//   String? _selectedAnimalType;
//   bool _isPaymentSuccessful = false;

//   TextEditingController name = TextEditingController();
//   TextEditingController phone = TextEditingController();
//   TextEditingController email = TextEditingController();
//   TextEditingController address = TextEditingController();
//   TextEditingController total = TextEditingController();

//   var userId;

//   var userrid;
//   getUserId() async {
//     var sharedPref = SharedPreferencesManager();
//     var localStorage = await sharedPref.getString(AppConstants.user);
//     // print("User :: ${jsonDecode(user!)}");
    
//     var user = jsonDecode(localStorage);
//     setState(() {
//       userId = user['id'];
//       print("user ID :: $userId");
//     });
//   }

//   @override
//   void initState() {
//     super.initState();

//     getUserId();
//   }

//   List<Step> stepList() => [
//         Step(
//           state: _activeStepIndex <= 0 ? StepState.editing : StepState.complete,
//           isActive: _activeStepIndex >= 0,
//           title: const Text(
//             'Basic Information',
//             style: TextStyle(fontFamily: 'Bebas', letterSpacing: 2),
//           ),
//           content: Container(
//             child: Column(
//               children: [
//                 TextField(
//                   controller: name,
//                   decoration: const InputDecoration(
//                     border: OutlineInputBorder(),
//                     labelText: 'Full Name',
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 8,
//                 ),
//                 TextField(
//                   controller: email,
//                   decoration: const InputDecoration(
//                     border: OutlineInputBorder(),
//                     labelText: 'Email',
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 8,
//                 ),
//                 TextField(
//                   controller: phone,
//                   keyboardType: TextInputType.phone,

//                   // obscureText: true,
//                   decoration: const InputDecoration(
//                     border: OutlineInputBorder(),
//                     labelText: 'Phone',
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         Step(
//             state:
//                 _activeStepIndex <= 1 ? StepState.editing : StepState.complete,
//             isActive: _activeStepIndex >= 1,
//             title: const Text(
//               'Permit Information',
//               style: TextStyle(
//                 fontFamily: 'Bebas',
//                 letterSpacing: 2,
//               ),
//             ),
//             content: Container(
//               child: Column(
//                 children: [
//                   // const SizedBox(
//                   //   height: 8,
//                   // ),
//                   // TextField(
//                   //   controller: address,
//                   //   decoration: const InputDecoration(
//                   //     border: OutlineInputBorder(),
//                   //     labelText: 'Present Address',
//                   //   ),
//                   // ),
//                   const SizedBox(
//                     height: 8,
//                   ),
//                   DropdownButtonFormField<String>(
//                     value: _selectedRegion,
//                     icon: const Icon(Icons.arrow_downward),
//                     decoration: const InputDecoration(
//                       labelText: 'From',
//                       labelStyle: TextStyle(
//                         // color: Color(0xFFF92306),
//                         fontSize: 12,
//                       ),
//                       border: OutlineInputBorder(),
//                     ),
//                     items: AppConstants.regions.map((String value) {
//                       return DropdownMenuItem<String>(
//                         value: value,
//                         child: Text(value),
//                       );
//                     }).toList(),
//                     onChanged: (String? newValue) {
//                       setState(() {
//                         _selectedRegion = newValue;
//                       });
//                     },
//                   ),
//                   const SizedBox(
//                     height: 8,
//                   ),
//                   DropdownButtonFormField<String>(
//                     value: _selectedRegion2,
//                     icon: const Icon(Icons.arrow_downward),
//                     decoration: const InputDecoration(
//                       labelText: 'To',
//                       labelStyle: TextStyle(
//                         // color: Color(0xFFF92306),
//                         fontSize: 12,
//                       ),
//                       border: OutlineInputBorder(),
//                     ),
//                     items: AppConstants.regions.map((String value) {
//                       return DropdownMenuItem<String>(
//                         value: value,
//                         child: Text(value),
//                       );
//                     }).toList(),
//                     onChanged: (String? newValue) {
//                       setState(() {
//                         _selectedRegion2 = newValue;
//                       });
//                     },
//                   ),
//                   const SizedBox(
//                     height: 8,
//                   ),
//                   DropdownButtonFormField<String>(
//                     value: _selectedPermitType,
//                     icon: const Icon(Icons.arrow_downward),
//                     decoration: const InputDecoration(
//                       labelText: 'Permit type',
//                       labelStyle: TextStyle(
//                         // color: Color(0xFFF92306),
//                         fontSize: 12,
//                       ),
//                       border: OutlineInputBorder(),
//                     ),
//                     items: AppConstants.permits.map((String value) {
//                       return DropdownMenuItem<String>(
//                         value: value,
//                         child: Text(value),
//                       );
//                     }).toList(),
//                     onChanged: (String? newValue) {
//                       setState(() {
//                         _selectedPermitType = newValue;
//                       });
//                     },
//                   ),
//                   const SizedBox(
//                     height: 8,
//                   ),
//                   DropdownButtonFormField<String>(
//                     value: _selectedAnimalType,
//                     icon: const Icon(Icons.arrow_downward),
//                     decoration: const InputDecoration(
//                       labelText: 'Animal type',
//                       labelStyle: TextStyle(
//                         // color: Color(0xFFF92306),
//                         fontSize: 12,
//                       ),
//                       border: OutlineInputBorder(),
//                     ),
//                     items: AppConstants.animals.map((String value) {
//                       return DropdownMenuItem<String>(
//                         value: value,
//                         child: Text(value),
//                       );
//                     }).toList(),
//                     onChanged: (String? newValue) {
//                       setState(() {
//                         _selectedAnimalType = newValue;
//                       });
//                     },
//                   ),
//                   const SizedBox(
//                     height: 8,
//                   ),
//                   TextField(
//                     controller: total,
//                     keyboardType: TextInputType.number,
//                     decoration: const InputDecoration(
//                       border: OutlineInputBorder(),
//                       labelText: 'Number of Cattles',
//                     ),
//                   ),
//                 ],
//               ),
//             )),
//         Step(
//           state: StepState.complete,
//           isActive: _activeStepIndex >= 2,
//           title: const Text(
//             'Confirm Details',
//             style: TextStyle(
//               fontFamily: 'Bebas',
//               letterSpacing: 2,
//             ),
//           ),
//           content: Container(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 Text('Name: ${name.text}'),
//                 Text('Email: ${email.text}'),
//                 Text('Phone : ${phone.text}'),
//                 Text('From : ${_selectedRegion}'),
//                 Text('To : ${_selectedRegion2}'),
//                 Text('Permit type : ${_selectedPermitType}'),
//                 Text('Animal type : ${_selectedAnimalType}'),
//                 Text('Total Cattle : ${total.text}'),
//                 ElevatedButton(
//                   onPressed: () async {
//                     final response =
//                         await _handlePaymentInitialization(email.text);
//                     if (response.status == 'successful') {
//                       setState(() {
//                         _isPaymentSuccessful = true;
//                       });
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(content: Text('Payment successful')),
//                       );
//                     } else {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(content: Text('Payment failed')),
//                       );
//                     }
//                   },
//                   child: const Text('Make Payment'),
//                 ),
//                 const SizedBox(height: 8),
//                 if (_isPaymentSuccessful)
//                   ElevatedButton(
//                     onPressed: () {
//                       _handleSubmit();
//                     },
//                     child: const Text('Submit'),
//                   ),
//               ],
//             ),
//           ),
//         )
//       ];
//   bool isTestMode = true;

//   _handlePaymentInitialization(email) async {
//     final Customer customer = Customer(email: email);

//     final Flutterwave flutterwave = Flutterwave(
//       // meta: ,
//         context: context,
//         publicKey: 'FLWPUBK_TEST-ad169f46c21db341e24cbde5816d72bf-X',
//         currency: "TZS",
//         redirectUrl: 'https://www.google.com/',
//         // redirectUrl: url,
//         txRef: Uuid().v1(),
//         // amount: _depositAmountController.text.toString().trim(),
//         amount: "10000",
//         customer: customer,
//         paymentOptions: "card, payattitude, barter, bank transfer, ussd",
//         customization: Customization(title: "Loan Payment"),
//         isTestMode: this.isTestMode);
//     final ChargeResponse response = await flutterwave.charge();
//     if (mounted) {
//       showLoading(response.toString());
//     }
//     print("RESPONSE :: ${response.toJson()}");

//     return response; // Return the ChargeResponse object
//   }

//   Future<void> showLoading(String message) {
//     if (!mounted) return Future.value(); // Ensure the widget is still mounted
//     return showDialog(
//       context: this.context,
//       barrierDismissible: true,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           content: Container(
//             margin: EdgeInsets.fromLTRB(30, 20, 30, 20),
//             width: double.infinity,
//             height: 50,
//             child: Text(message),
//           ),
//         );
//       },
//     );
//   }

//   void _handleSubmit() {
//     var data = {
//       "customer": userId,
//       "livestock_number": total.text,
//       "permit_typec": _selectedPermitType,
//       "issued_at": DateTime.now().toIso8601String()
//     };
//     print("data:: ${data}");

//     var result = Provider.of<ServiceManagementProvider>(context, listen: false)
//         .createPermit(data);
//     if (result == true) {
//       print("Succesfully");
//     } else {
//       print("Failed");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Request Permit Form"),
//       ),
//       body: Stepper(
//         type: StepperType.vertical,
//         currentStep: _activeStepIndex,
//         steps: stepList(),
//         onStepContinue: () {
//           if (_activeStepIndex < (stepList().length - 1)) {
//             setState(() {
//               _activeStepIndex += 1;
//             });
//           } else {
//             print('Submited');

//             Navigator.pop(context);
//           }
//         },
//         onStepCancel: () {
//           if (_activeStepIndex == 0) {
//             return;
//           }

//           setState(() {
//             _activeStepIndex -= 1;
//           });
//         },
//         onStepTapped: (int index) {
//           setState(() {
//             _activeStepIndex = index;
//           });
//         },
//       ),
//     );
//   }
// }

//   // controlsBuilder: (context, {onStepContinue, onStepCancel}) {
//         //   final isLastStep = _activeStepIndex == stepList().length - 1;
//         //   return Container(
//         //     child: Row(
//         //       children: [
//         //         Expanded(
//         //           child: ElevatedButton(
//         //             onPressed: onStepContinue,
//         //             child: (isLastStep)
//         //                 ? const Text('Submit')
//         //                 : const Text('Next'),
//         //           ),
//         //         ),
//         //         const SizedBox(
//         //           width: 10,
//         //         ),
//         //         if (_activeStepIndex > 0)
//         //           Expanded(
//         //             child: ElevatedButton(
//         //               onPressed: onStepCancel,
//         //               child: const Text('Back'),
//         //             ),
//         //           )
//         //       ],
//         //     ),
//         //   );
//         // },