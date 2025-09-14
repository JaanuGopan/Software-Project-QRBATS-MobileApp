import 'package:flutter/material.dart';
import 'package:skyticker/api/config/api_constants.dart';
import 'package:skyticker/api/config/api_service.dart';
import 'package:skyticker/components/forgot_password_component/otp_verification_popup.dart';
import 'package:skyticker/pages/login_signup_pages/login_page.dart';
import 'package:skyticker/pages/login_signup_pages/reset_password_page.dart';
import 'package:skyticker/widgets/snackbar/custom_snackbar.dart';

class ForgotPasswordService {
  // 🔹 Send OTP for Forgot Password
  static Future<void> sendOTPForForgotPassword(
    BuildContext context,
    String email,
  ) async {
    final String endpoint =
        '${ApiConstants.sendOTPForForgotPassword}?email=$email';

    try {
      final response = await ApiService.post(endpoint, {}, context);

      if (response != null && response.statusCode == 200) {
        if (response.body == "true") {
          CustomSnackBar.showSuccess(
            context,
            "OTP Sent Successfully To $email",
          );
          showOTPVerificationPopup(context, email);
        } else if (response.body == "false") {
          CustomSnackBar.showError(context, "Error in Sending OTP To $email.");
        }
      }
    } catch (error) {
      CustomSnackBar.showError(context, "Error In Sending OTP.");
    }
  }

  // 🔹 Verify OTP for Forgot Password
  static Future<void> verifyOTPForForgotPassword(
    BuildContext context,
    String email,
    String otp,
  ) async {
    final String endpoint =
        '${ApiConstants.verifyOTPForForgotPassword}?email=$email&otp=$otp';

    try {
      final response = await ApiService.get(endpoint, context);

      if (response != null && response.statusCode == 200) {
        if (response.body == 'true') {
          CustomSnackBar.showSuccess(context, "OTP Verified Successfully.");
          Navigator.of(context).pop();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return ResetPasswordPage(email: email);
              },
            ),
          );
        } else if (response.body == 'false') {
          CustomSnackBar.showError(context, "Incorrect OTP.");
        }
      }
    } catch (error) {
      CustomSnackBar.showError(context, "Error OTP Verification.");
    }
  }

  // 🔹 Reset Password
  static Future<void> resetPassword(
    BuildContext context,
    String email,
    String password,
    bool isEnableUsername,
    String username,
  ) async {
    String endpoint =
        '${ApiConstants.resetPasswordUrl}?email=$email&password=$password';
    if (isEnableUsername) {
      endpoint += '&userName=$username';
    }

    try {
      final response = await ApiService.put(endpoint, {}, context);

      if (response != null && response.statusCode == 200) {
        if (response.body == 'true') {
          CustomSnackBar.showSuccess(context, "Password Successfully Reset.");
          Navigator.of(context).pop();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return Login();
              },
            ),
          );
        } else if (response.body == 'false') {
          CustomSnackBar.showError(context, "Reset Password Failed.");
        }
      }
    } catch (error) {
      CustomSnackBar.showError(context, "Error Reset Password.");
    }
  }
}
