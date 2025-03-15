import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:qrbats_sp/api_config/api_constants.dart';
import 'package:qrbats_sp/widgets/snackbar/custom_snackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MarkAttendanceService {
  static Future<bool> markAttendance(int eventID, double locationGPSLatitude,
      double locationGPSLongitude, BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? authToken = preferences.getString("token");
    final Uri apiUrl = Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.markAttendanceEndpoint}');
    Map<String, dynamic> attendanceData = {
      "eventId": eventID,
      "attendanceDate": DateFormat('yyyy-MM-dd').format(DateTime.now()),
      "attendanceTime": DateFormat('HH:mm:ss').format(DateTime.now()),
      "locationGPSLatitude": locationGPSLatitude,
      "locationGPSLongitude": locationGPSLongitude
    };

    try {
      final http.Response response = await http.post(
        apiUrl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $authToken',
        },
        body: jsonEncode(attendanceData),
      );

      if (response.statusCode == 200) {
        CustomSnackBar.showSuccess(context, "Attendance marked successfully.");
        return true;
      } else {
        CustomSnackBar.showSnackBar(context, "Error In Mark Event Attendance.");
        return false;
      }
    } catch (error) {
      // Catch any errors that occur during the HTTP request
      CustomSnackBar.showSnackBar(context, "Error in marking attendance.");
      print('Error in marking attendance: $error');
      return false;
    }
  }
}
