import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qrbats_sp/api_config/api_constants.dart';
import 'package:http/http.dart' as http;
import 'package:qrbats_sp/pages/login_signup_pages/login_page.dart';
import 'package:qrbats_sp/widgets/snackbar/custom_snackbar.dart';

import '../components/forgot_password_component/otp_verification_popup.dart';
import '../pages/login_signup_pages/reset_password_page.dart';

class ForgotPasswordService {
  static Future<void> sendOTPForForgotPassword(BuildContext context,String email) async {
    final Uri apiUrl = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.sendOTPForForgotPassword}?email=$email');

    try {
      final http.Response response = await http.post(apiUrl);
      if(response.statusCode == 200){
        if (response.body == "true") {
          CustomSnackBar.showSuccess(context, "OTP Send Successfully To $email");
          showOTPVerificationPopup(context, email);
        }else if(response.body == "false"){
          CustomSnackBar.showError(context, "Error in Sending OTP To $email.");
        }
      }else if(response.statusCode == 400){
        CustomSnackBar.showError(context, response.body.toString());
      }else{
        CustomSnackBar.showError(context, "Error In Sending OTP To $email");
      }
    }catch(error){
      CustomSnackBar.showError(context, "Error In Sending OTP.");
    }

  }

  static Future<void> verifyOTPForForgotPassword(BuildContext context,String email,String otp) async {
    final Uri apiUrl = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.verifyOTPForForgotPassword}?email=$email&otp=$otp');

    try {
      final http.Response response = await http.post(apiUrl);
      if(response.statusCode == 200){
        if (response.body == 'true') {
          CustomSnackBar.showSuccess(context, "OTP Verified Successfully.");
          Navigator.of(context).pop();
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return ResetPasswordPage(email: email,);
          }));
        }else if(response.body == 'false'){
          CustomSnackBar.showError(context, "Incorrect OTP.");
        }
      }else if(response.statusCode == 400){
        CustomSnackBar.showError(context, response.body.toString());
      }else{
        CustomSnackBar.showError(context, "Error OTP Verification.");
      }
    }catch(error){
      CustomSnackBar.showError(context, "Error OTP Verification.");
    }
  }

  static Future<void> resetPassword(BuildContext context,String email,String password) async {
    final Uri apiUrl = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.resetPasswordUrl}?email=$email&password=$password');

    try {
      final http.Response response = await http.post(apiUrl);
      if(response.statusCode == 200){
        if (response.body == 'true') {
          CustomSnackBar.showSuccess(context, "Password Successfully Reset.");
          Navigator.of(context).pop();
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return Login();
          }));
        }else if(response.body == 'false'){
          CustomSnackBar.showError(context, "Reset Password Failed.");
        }
      }else if(response.statusCode == 400){
        CustomSnackBar.showError(context, response.body.toString());
      }else{
        CustomSnackBar.showError(context, "Error Reset Password.");
      }
    }catch(error){
      CustomSnackBar.showError(context, "Error Reset Password.");
    }

  }


}