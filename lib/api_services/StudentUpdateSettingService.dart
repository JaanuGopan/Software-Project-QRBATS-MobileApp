import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:qrbats_sp/pages/login_signup_pages/login_page.dart';
import 'package:qrbats_sp/widgets/snackbar/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../api_config/api_constants.dart';

class StudentUpdateSettingService {

  static Future<void> updateStudent(
    BuildContext context,
    int studentId,
    String username,
    String password,
    String confirmPassword,
    String studentName,
    String indexNumber,
    String email,
    String studentRole,
    int departmentId,
    int currentSemester,
  ) async {
    if (password != confirmPassword) {
      // Use CustomSnackBar to show the snackbar
      CustomSnackBar.showWarning(context, 'Passwords do not match.');
      return; // Exit function if passwords don't match
    }
    Map<String, dynamic> userData = {
      'id':studentId,
      'userName': username=="" ? null:username,
      'password': password=="" ? null:password,
      'studentName': studentName,
      'indexNumber': indexNumber,
      'studentEmail': email,
      'studentRole': studentRole=="" ? null:studentRole,
      'departmentId': departmentId,
      'currentSemester': currentSemester,

    };
    final Uri studentUpdateUrl = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.updateStudentUrl}');

    try {
      final http.Response registerResponse = await http.put(
        studentUpdateUrl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(userData),
      );

      if (registerResponse.statusCode == 200) {
        CustomSnackBar.showSuccess(context,"Student Account successfully Updated." );

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.remove("token");
        // Navigate to the starting page (login page)
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        );
      } else if(registerResponse.statusCode == 400){
        CustomSnackBar.showError(context, registerResponse.body);
      }
      else {
        // Registration failed
        print('Failed to register user: ${registerResponse.statusCode}');
        // Handle error
      }
    } on Exception catch (e) {
      // TODO
      CustomSnackBar.showError(context, "Error In Update Your Profile.");
    }
  }
}
