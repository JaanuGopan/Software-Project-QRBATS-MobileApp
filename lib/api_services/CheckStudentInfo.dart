import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qrbats_sp/api_services/config/api_service.dart';

import '../api_services/OTPService.dart';

class CheckStudentInfo {
  static Future<void> checkStudentInfo(
    String email,
    String indexNumber,
    String? deviceId,
    Function navigateOtpVerificationPage,
    BuildContext context,
  ) async {
    final String endpoint =
        '/api/v1/auth/check-student-signup-details?email=$email&indexNumber=$indexNumber&deviceId=$deviceId';

    http.Response? response = await ApiService.get(endpoint, context);

    if (response != null && response.statusCode == 200) {
      bool isOtpSend = await OTPServices.generateOTP(context, email);
      if (isOtpSend) {
        navigateOtpVerificationPage();
      }
    }
  }
}
