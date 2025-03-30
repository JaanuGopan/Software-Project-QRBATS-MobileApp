import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qrbats_sp/api_config/api_constants.dart';
import 'package:qrbats_sp/api_services/config/api_service.dart';

class MarkAttendanceService {
  static Future<bool> markAttendance(int eventID, double locationGPSLatitude,
      double locationGPSLongitude, BuildContext context) async {
    Map<String, dynamic> attendanceData = {
      "eventId": eventID,
      "locationCoordinates": {
        "latitude": locationGPSLatitude,
        "longitude": locationGPSLongitude
      },
    };

    final http.Response? response = await ApiService.post(
      ApiConstants.markAttendanceEndpoint,
      attendanceData,
      context,
    );

    return response!.statusCode == HttpStatus.created ? true : false;
  }
}
