import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../api_config/api_constants.dart';
import '../widgets/snackbar/custom_snackbar.dart';

class OTPServices{

  static Future<void> generateOTP(BuildContext context, String studentEmail) async {
    final Uri apiUrl = Uri.parse('${ApiConstants.mobileBaseUrl}${ApiConstants.studentGenerateOTP}');

    final Map<String, dynamic> userData = {
      'otpSendEmail': studentEmail,
    };

    try{
      final http.Response response = await http.post(
        apiUrl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(userData),
      );
      if (response.statusCode == 200) {

        CustomSnackBar.showSuccess(context, 'Please check your email.');
      } else {
        CustomSnackBar.showError(context, 'Invalid Request.'); // Use CustomSnackBar
      }


    }catch(e){
      CustomSnackBar.showError(context, 'Invalid Request.');
    }
  }

  static Future<void> verifyOTP(BuildContext context, String studentEmail,String otp,Function function) async {
    final Uri apiUrl = Uri.parse('${ApiConstants.mobileBaseUrl}${ApiConstants.studentVerifyOtp}');

    final Map<String, dynamic> userData = {
      'studentEmail': studentEmail,
      'otp':otp.toString()
    };

    try{
      final http.Response otpVerificationResponse = await http.post(
        apiUrl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(userData),
      );
      if (otpVerificationResponse.statusCode == 200) {
        final bool isOTPVerified = jsonDecode(otpVerificationResponse.body);
        if(isOTPVerified){
          CustomSnackBar.showSuccess(context, 'OTP verified.'); // Use CustomSnackBar
          function();
        }else{
          CustomSnackBar.showError(context, 'You entered Wrong OTP.'); // Use CustomSnackBar
        }
      } else if(otpVerificationResponse.statusCode == 400){
        CustomSnackBar.showError(context, otpVerificationResponse.body.toString()); // Use CustomSnackBar
      }

    }catch(e){
      CustomSnackBar.showError(context, 'Error In OTP Verification.');
    }
  }

}