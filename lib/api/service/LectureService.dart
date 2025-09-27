import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:skyticker/api/config/api_constants.dart';
import 'package:skyticker/api/config/api_service.dart';
import 'package:skyticker/models/Lecture.dart';
import 'package:skyticker/widgets/snackbar/custom_snackbar.dart';

class LectureService {
  // 🔹 Get all lectures by module code
  static Future<List<Lecture>> getAllLectureByModuleCode(
    BuildContext context,
    int moduleId,
  ) async {
    final String endpoint =
        '${ApiConstants.getAllLecturesByModuleCode}?moduleId=$moduleId';

    try {
      // Use the GET method from ApiService
      final response = await ApiService.get(endpoint, context);

      if (response != null && response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        List<Lecture> lecturesList = responseData
            .map((data) => Lecture.fromJson(data))
            .toList();
        return lecturesList;
      } else {
        throw Exception("Error in getting lectures.");
      }
    } catch (error) {
      CustomSnackBar.showError(context, "Error in getting lectures.");
      rethrow;
    }
  }
}
