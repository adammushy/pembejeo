import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:Permit/constants/app_constants.dart';
import 'package:Permit/helpers/api/api_client_http.dart';
import 'package:Permit/shared-preference-manager/preference-manager.dart';
import 'package:provider/provider.dart';

class UserManagementProvider extends ChangeNotifier {
  var _user;
  var _userAccount;

  List<Map<String, dynamic>> _allUsers = [];
  // var _allPermits;

  List<Map<String, dynamic>> get allUsers => _allUsers;

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

  Future<bool> fetchAllUsers() async {
    try {
      // var user = await SharedPreferencesManager().getString(AppConstants.user);
      // var res = await ApiClientHttp(
      //         headers: <String, String>{'Content-type': 'application/json'})
      //     .getRequest(
      //         '${AppConstants.createPermit}?id=${jsonDecode(user)['id']}');

      var res = await ApiClientHttp(
              headers: <String, String>{'Content-type': 'application/json'})
          .getRequest(AppConstants.fetchUsersUrl);
      print("RES:: ${res}");

      if (res == null) {
        return false;
      } else {
        var body = res;
        print("BODY:: ${body}");

        // print("All Permits :: ${body.length}");
        // _allUsers = body;

        _allUsers = List<Map<String, dynamic>>.from(body);

        print("All Users :: ${_allUsers}");
        print("All Users total :: ${_allUsers.length}");

        notifyListeners();
        return true;
      }
    } catch (e) {
      // debugPrint(e.toString());
      print("Error Exception :: ${e.toString()}");

      return false;
    }
  }

  Future<void> changePassword() async {}
}
