import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qrbats_sp/api_services/config/api_service.dart';

import '../api_config/api_constants.dart';
import '../pages/login_signup_pages/login_page.dart';
import '../widgets/snackbar/custom_snackbar.dart';

class RegistrationHelper {
  static const String studentRegisterEndpoint = ApiConstants.studentRegister;
  static const String checkStudentUserNameEndpoint =
      ApiConstants.checkStudentUserNameEndpoint;

  static Future<void> register(
      BuildContext context,
      String username,
      String password,
      String confirmPassword,
      String studentName,
      String indexNumber,
      String email,
      String studentRole,
      int? departmentId,
      int currentSemester,
      int studentBatch,
      String? deviceId) async {
    if (password != confirmPassword) {
      // Use CustomSnackBar to show the snackbar
      CustomSnackBar.showWarning(context, 'Passwords do not match.');
      return; // Exit function if passwords don't match
    }

    Map<String, dynamic> userData = {
      'userName': username,
      'password': password,
      'firstName': studentName,
      'indexNumber': indexNumber,
      'email': email,
      'role': studentRole,
      'departmentId': departmentId,
      'semester': currentSemester,
      'batch': studentBatch,
      'deviceId': deviceId
    };

    try {
      // Use ApiService for checking username
      final checkUserNameResponse = await ApiService.post(
        '$checkStudentUserNameEndpoint?userName=$username',
        {},
        context,
      );

      if (checkUserNameResponse != null &&
          checkUserNameResponse.statusCode == 200) {
        final bool usernameExists = jsonDecode(checkUserNameResponse.body);
        if (!usernameExists) {
          // Use ApiService for registration
          final registerResponse = await ApiService.post(
            studentRegisterEndpoint,
            userData,
            context,
          );

          if (registerResponse != null && registerResponse.statusCode == 200) {
            CustomSnackBar.showSuccess(context,
                "Account Successfully Created, Please Login Your Account.");
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Login()),
            );
          } else {
            // Registration failed
            CustomSnackBar.showError(context, 'Registration failed.');
          }
        } else {
          // Username already exists, show snackbar
          CustomSnackBar.showWarning(context, 'The User Name already exists.');
        }
      } else {
        // Handle error if failed to check username
        CustomSnackBar.showError(
            context, 'Failed to check username availability.');
      }
    } catch (error) {
      // Catch any errors that occur during the HTTP request
      print('Error registering user: $error');
      CustomSnackBar.showError(
          context, 'An error occurred during registration.');
    }
  }
}
