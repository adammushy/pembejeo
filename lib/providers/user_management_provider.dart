import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pembejeo/constants/app_constants.dart';
import 'package:pembejeo/helpers/api/api_client_http.dart';
import 'package:pembejeo/shared-preference-manager/preference-manager.dart';
import 'package:provider/provider.dart';

class UserManagementProvider extends ChangeNotifier {
  var _user;
  var _userAccount;

  get user => _user;
  

  Future<Map<String, dynamic>> userLogin(ctx, data) async {
    try {
      var res = await ApiClientHttp(
              headers: <String, String>{'Content-type': 'application/json'})
          .postRequest(AppConstants.loginUrl, data);

      if (res == null) {
        return {"status": false};
      } else {
        var body = res;
        if (body['login']) {
          print("BODY : $body");
          var sharedPref = SharedPreferencesManager();
          sharedPref.init();
          sharedPref.saveString(AppConstants.user, json.encode(body['user']));
          sharedPref.saveString(AppConstants.token, json.encode(body['token']));
          return {"status": true, "body": body};
        }
        print(body);

        return {"status": false, "body": body['message']};
      }
    } catch (e) {
      return {"status ": false, "body": e.toString()};
    }
  }

  Future<Map<String, dynamic>> registerUser(ctx, data) async {
    try {
      var res = await ApiClientHttp(
              headers: <String, String>{'Content-type': 'application/json'})
          .postRequest(AppConstants.registerUrl, data);
      // print("REg ur;:: ${AppConstants.registerUrl}");

      // print("RES:: ${res}");

      if (res == null) {
        return {"status": false};
      } else {
        var body = res;
        if (body['save']) {
          print("BODY:: ${body}");

          return {"status": true, "body": body};
        }

        return {"status": false, "body": body['message']};
      }
    } catch (e) {
      return {"status": false, "body": e.toString()};
    }
  }

  Future<void> changePassword() async {}
}
