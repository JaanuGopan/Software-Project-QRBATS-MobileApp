import 'package:flutter/material.dart';
import 'package:qrbats_sp/api_services/config/api_service.dart';
import 'package:qrbats_sp/pages/device_verification/device_otp_verification.dart';
import 'package:qrbats_sp/widgets/snackbar/custom_snackbar.dart';

import '../pages/login_signup_pages/login_page.dart';

class DeviceVerificationService {
  // 🔹 Send OTP for Forgot Password
  static Future<void> sendOTPForDeviceVerification(BuildContext context,
      String email, String username, String password, String? deviceId) async {
    final String endpoint =
        '/api/v1/auth/send-otp-for-device-verification?email=$email&username=$username&password=$password&deviceId=$deviceId';

    try {
      final response = await ApiService.post(endpoint, {}, context);

      if (response != null && response.statusCode == 200) {
        if (response.body == "true") {
          CustomSnackBar.showSuccess(
              context, "OTP Sent Successfully To $email");
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return DeviceOtpVerification(
              email: email,
            );
          }));
        } else if (response.body == "false") {
          CustomSnackBar.showError(context, "Error in Sending OTP To $email.");
        }
      }
    } catch (error) {
      CustomSnackBar.showError(context, "Error In Sending OTP.");
    }
  }

  // 🔹 Verify OTP for Forgot Password
  static Future<void> verifyOTPForDeviceVerification(
      BuildContext context, String email, String otp, String? deviceId) async {
    final String endpoint =
        '/api/v1/auth/change-device-otp-verification?email=$email&otp=$otp&deviceId=$deviceId';

    final response = await ApiService.put(endpoint, {}, context);

    if (response != null && response.statusCode == 200) {
      if (response.body == 'true') {
        CustomSnackBar.showSuccess(
            context, "Device Verified Successfully, Login again.");
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return const Login();
        }));
      } else if (response.body == 'false') {
        CustomSnackBar.showError(context, "Incorrect OTP.");
      }
    }
  }
}
