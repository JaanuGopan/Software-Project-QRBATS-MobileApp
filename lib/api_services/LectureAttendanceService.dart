import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:qrbats_sp/api_services/config/api_service.dart';

import '../api_config/api_constants.dart';
import '../widgets/snackbar/custom_snackbar.dart';

class LectureAttendanceService {
  // Method to mark attendance by student ID
  static Future<bool> markLectureAttendance(int studentId, String moduleCode,
      double latitude, double longitude, BuildContext context) async {
    Map<String, dynamic> lectureAttendanceData = {
      "studentId": studentId,
      "moduleCode": moduleCode,
      "attendedDate": DateFormat('yyyy-MM-dd').format(DateTime.now()),
      "attendedTime": DateFormat('HH:mm:ss').format(DateTime.now()),
      "latitude": latitude,
      "longitude": longitude
    };

    // Use ApiService for the POST request
    final response = await ApiService.post(
      ApiConstants.lectureAttendanceMarking,
      lectureAttendanceData,
      context,
    );

    if (response != null && response.statusCode == 200) {
      CustomSnackBar.showSuccess(context, "Attendance marked successfully.");
      return true;
    } else {
      CustomSnackBar.showError(context, "Failed to mark attendance.");
      return false;
    }
  }

  // Method to mark attendance by lecture ID
  static Future<bool> markLectureAttendanceByLectureId(int lectureId,
      double latitude, double longitude, BuildContext context) async {
    Map<String, dynamic> lectureAttendanceData = {
      "lectureId": lectureId,
      "locationCoordinates": {"latitude": latitude, "longitude": longitude}
    };

    // Use ApiService for the POST request
    final response = await ApiService.post(
      ApiConstants.lectureAttendanceMarkingByLectureId,
      lectureAttendanceData,
      context,
    );

    if (response != null && response.statusCode == 200) {
      CustomSnackBar.showSuccess(context, "Attendance marked successfully.");
      return true;
    } else {
      CustomSnackBar.showError(context, "Failed to mark attendance.");
      return false;
    }
  }
}
