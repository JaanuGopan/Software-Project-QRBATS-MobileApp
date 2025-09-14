import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:skyticker/api/config/api_constants.dart';
import 'package:skyticker/api/config/api_service.dart';
import 'package:skyticker/widgets/snackbar/custom_snackbar.dart';

class LectureAttendanceService {
  static Future<bool> markLectureAttendanceByLectureId(
    int lectureId,
    double latitude,
    double longitude,
    BuildContext context,
  ) async {
    Map<String, dynamic> lectureAttendanceData = {
      "lectureId": lectureId,
      "locationCoordinates": {"latitude": latitude, "longitude": longitude},
    };

    // Use ApiService for the POST request
    final response = await ApiService.post(
      ApiConstants.lectureAttendanceMarkingByLectureId,
      lectureAttendanceData,
      context,
    );

    if (response?.statusCode == HttpStatus.created) {
      CustomSnackBar.showSuccess(context, "Attendance marked successfully.");
      return true;
    }
    return false;
  }
}
