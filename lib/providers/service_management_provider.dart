// ignore_for_file: unused_field

import 'dart:convert';
// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:pembejeo/constants/app_constants.dart';
import 'package:pembejeo/helpers/api/api_client_http.dart';
import 'package:pembejeo/shared-preference-manager/preference-manager.dart';

class ServiceManagementProvider extends ChangeNotifier {
  var _permit;
  List<Map<String, dynamic>> _allPermits = [];
  // var _allPermits;

  List<Map<String, dynamic>> get allPermits => _allPermits;

  List<Map<String, dynamic>> _allSysPermits = [];
  // var _allPermits;

  List<Map<String, dynamic>> get allSysPermits => _allSysPermits;
  // get allPermits => _allPermits;
  get permit => _permit;

  Future<bool> createPermit(data) async {
    try {
      var res = await ApiClientHttp(
              headers: <String, String>{'Content-type': 'application/json'})
          .postRequest(AppConstants.createPermit, data);

      if (res == null) {
        print("RES :: $res");
        return false;
      } else {
        var body = res;
        if (body['save']) {
          getAllPermits();
          print("Permits :: $body");

          notifyListeners();
          return true;
        } else {
          print("BODY :: $body");

          return false;
        }
      }
    } catch (e) {
      print("Error Exception :: ${e.toString()}");
      return false;
    }
  }

  Future<bool> getAllPermits() async {
    try {
      var user = await SharedPreferencesManager().getString(AppConstants.user);
      var res = await ApiClientHttp(
              headers: <String, String>{'Content-type': 'application/json'})
          .getRequest(
              '${AppConstants.createPermit}?id=${jsonDecode(user)['id']}');
      if (res == null) {
        return false;
      } else {
        var body = res;

        if (!body['error']) {
          // print("All Permits :: ${body.length}");
          // _allPermits = body;

          _allPermits = List<Map<String, dynamic>>.from(body['data']);

          print("All Permits :: ${_allPermits}");
          print("All Permits :: ${_allPermits.length}");

          notifyListeners();
          return true;
        }
      }
      return false;
    } catch (e) {
      // debugPrint(e.toString());
      print("Error Exception :: ${e.toString()}");

      return false;
    }
  }

  Future<bool> fetchAllPermits() async {
    try {
      var res = await ApiClientHttp(
              headers: <String, String>{'Content-type': 'application/json'})
          .getRequest(AppConstants.fetchPermits);
      // print("RES :: ${res}");

      if (res == null) {
        return false;
      } else {
        var body = res;

        // print("All Permits :: ${body.length}");
        // _allPermits = body;
        // print("Body :: ${body}");

        _allSysPermits = List<Map<String, dynamic>>.from(body);

        print("All Permits :: ${_allSysPermits}");
        print("All Permits :: ${_allSysPermits.length}");
        notifyListeners();
        return true;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> changeStatus(data) async {
    try {
      var res = await ApiClientHttp(
              headers: <String, String>{'Content-type': 'application/json'})
          .postRequest(AppConstants.changeStatus, data);
      // print("RES :: ${res}");

      if (res == null) {
        return false;
      } else {
        var body = res;
        if (body['change']) {
          // getAllPermits();
          print("Body :: ${body}");
          fetchAllPermits();

          notifyListeners();
          return true;
        } else {
          return false;
        }
      }
    } catch (e) {
      return false;
    }
  }
}
