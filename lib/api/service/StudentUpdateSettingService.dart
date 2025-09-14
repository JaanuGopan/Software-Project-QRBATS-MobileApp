import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skyticker/api/config/api_constants.dart';
import 'package:skyticker/api/config/api_service.dart';
import 'package:skyticker/models/student_dto.dart';
import 'package:skyticker/pages/login_signup_pages/login_page.dart';
import 'package:skyticker/widgets/snackbar/custom_snackbar.dart';

class StudentUpdateSettingService {
  static Future<StudentDto> getStudent(BuildContext context) async {
    const String endpoint = ApiConstants.getStudentUrl;
    final response = await ApiService.get(endpoint, context);
    final responseData = jsonDecode(response!.body);
    StudentDto studentDto = StudentDto.fromJson(responseData);
    return studentDto;
  }

  static Future<void> updateStudent(
    BuildContext context,
    String studentName,
    String indexNumber,
    String email,
    int? departmentId,
    int semester,
    int studentBatch,
  ) async {
    Map<String, dynamic> userData = {
      'firstName': studentName,
      'indexNumber': indexNumber,
      'email': email,
      'departmentId': departmentId,
      'semester': semester,
      'studentBatch': studentBatch,
    };

    const String endpoint = ApiConstants.updateStudentUrl;

    try {
      final response = await ApiService.put(endpoint, userData, context);

      if (response != null && response.statusCode == 200) {
        CustomSnackBar.showSuccess(
          context,
          "Student Account successfully Updated.",
        );

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.remove("token");

        // Navigate to the starting page (login page)
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        );
      } else if (response != null && response.statusCode == 400) {
        CustomSnackBar.showError(context, response.body);
      } else {
        // Handle error response here
        print('Failed to update student: ${response?.statusCode}');
      }
    } catch (e) {
      // Error handling
      CustomSnackBar.showError(context, "Error In Update Your Profile.");
    }
  }
}
