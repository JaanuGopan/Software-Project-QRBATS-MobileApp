import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:skyticker/api/config/api_constants.dart';
import 'package:skyticker/api/config/api_service.dart';
import 'package:skyticker/models/StudentAttendanceResultDto.dart';
import 'package:skyticker/widgets/snackbar/custom_snackbar.dart';

class LectureAttendedHistoryService {
  static Future<StudentAttendanceResultDto> fetchModuleAttendanceForStudent(
    int moduleId,
    BuildContext context,
  ) async {
    final String apiUrl =
        '${ApiConstants.getModuleAttendanceForStudent}?moduleId=$moduleId';

    final response = await ApiService.get(apiUrl, context);

    if (response != null && response.statusCode == 200) {
      print("Before parsing :" + response.body.toString());
      StudentAttendanceResultDto studentAttendanceResultDto =
          StudentAttendanceResultDto.fromJson(jsonDecode(response.body));
      print("After parsing :" + studentAttendanceResultDto.toString());
      return studentAttendanceResultDto;
    } else {
      CustomSnackBar.showError(context, "Failed to load attendance data");
      throw Exception('Failed to load attendance data');
    }
  }
}
