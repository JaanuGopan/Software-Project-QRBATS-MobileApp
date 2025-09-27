import 'package:flutter/material.dart';
import 'package:skyticker/api/config/api_constants.dart';
import 'package:skyticker/api/config/api_service.dart';
import 'package:skyticker/pages/login_signup_pages/login_page.dart';
import 'package:skyticker/widgets/snackbar/custom_snackbar.dart';

class RegistrationHelper {
  static const String studentRegisterEndpoint = ApiConstants.studentRegister;

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
    String? deviceId,
  ) async {
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
      'deviceId': deviceId,
    };

    try {
      final registerResponse = await ApiService.post(
        studentRegisterEndpoint,
        userData,
        context,
      );

      if (registerResponse != null && registerResponse.statusCode == 200) {
        CustomSnackBar.showSuccess(
          context,
          "Account Successfully Created, Please Login Your Account.",
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        );
      } else {
        // Registration failed
        CustomSnackBar.showError(context, 'Registration failed.');
      }
    } catch (error) {
      // Catch any errors that occur during the HTTP request
      print('Error registering user: $error');
      CustomSnackBar.showError(
        context,
        'An error occurred during registration.',
      );
    }
  }
}
