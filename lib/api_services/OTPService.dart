import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qrbats_sp/api_services/config/api_service.dart';

import '../api_config/api_constants.dart';
import '../widgets/snackbar/custom_snackbar.dart';

class OTPServices {
  // 🔹 Generate OTP
  static Future<bool> generateOTP(
    BuildContext context,
    String studentEmail,
  ) async {
    final Map<String, dynamic> userData = {
      'otpSendEmail': studentEmail,
    };

    // Use ApiService to send the POST request
    final response = await ApiService.post(
      ApiConstants.studentGenerateOTP,
      userData,
      context,
    );

    if (response != null && response.statusCode == 200) {
      CustomSnackBar.showSuccess(context, 'Please check your email.');
      return true;
    } else {
      CustomSnackBar.showError(context, 'Invalid Request.');
      return false;
    }
  }

  // 🔹 Verify OTP
  static Future<void> verifyOTP(BuildContext context, String studentEmail,
      String otp, Function function) async {
    final Map<String, dynamic> userData = {
      'studentEmail': studentEmail,
      'otp': otp.toString(),
    };

    // Use ApiService to send the POST request
    final response = await ApiService.post(
      ApiConstants.studentVerifyOtp,
      userData,
      context,
    );

    if (response != null && response.statusCode == 200) {
      final bool isOTPVerified = jsonDecode(response.body);
      if (isOTPVerified) {
        CustomSnackBar.showSuccess(context, 'OTP verified.');
        function(); // Execute the passed function if OTP is verified
      } else {
        CustomSnackBar.showError(context, 'You entered Wrong OTP.');
      }
    } else if (response != null && response.statusCode == 400) {
      CustomSnackBar.showError(context, response.body.toString());
    }
  }
}
