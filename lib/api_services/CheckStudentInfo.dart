import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qrbats_sp/api_services/config/api_service.dart';

import '../api_config/api_constants.dart';
import '../api_services/OTPService.dart';
import '../widgets/snackbar/custom_snackbar.dart';

class CheckStudentInfo {
  static Future<void> checkStudentInfo(
    String email,
    String indexNumber,
    Function navigateOtpVerificationPage,
    BuildContext context,
  ) async {
    final String emailEndpoint =
        '${ApiConstants.checkStudentEmailEndpoint}?email=$email';
    final String indexNoEndpoint =
        '${ApiConstants.checkStudentIndexNoEndpoint}?indexNumber=$indexNumber';

    try {
      // 🔹 Using ApiService to handle requests
      final List<http.Response?> responses = await Future.wait([
        ApiService.post(emailEndpoint, {},
            context), // Empty body since it's a query param request
        ApiService.post(indexNoEndpoint, {}, context),
      ]);

      if (responses[0] == null || responses[1] == null) {
        CustomSnackBar.showError(
            context, "Failed to check student information.");
        return;
      }

      final bool emailExists =
          responses[0]!.statusCode == 200 && responses[0]!.body == "true";
      final bool indexNoExists =
          responses[1]!.statusCode == 200 && responses[1]!.body == "true";

      if (emailExists && indexNoExists) {
        CustomSnackBar.showWarning(
            context, 'The email address and index number already exist.');
      } else if (emailExists) {
        CustomSnackBar.showWarning(
            context, 'The email address already exists.');
      } else if (indexNoExists) {
        CustomSnackBar.showWarning(context, 'The index number already exists.');
      } else {
        bool isOtpSend = await OTPServices.generateOTP(context, email);
        if (isOtpSend) {
          navigateOtpVerificationPage();
        }
      }
    } catch (error) {
      CustomSnackBar.showError(
          context, "An error occurred while checking student info.");
      print('Error: $error');
    }
  }
}
