import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qrbats_sp/api_services/config/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api_config/api_constants.dart';
import '../../pages/main_pages/main_page.dart';
import '../widgets/snackbar/custom_snackbar.dart'; // Import CustomSnackBar class

class LoginService {
  static Future<void> login(
      BuildContext context, String userName, String password) async {
    late SharedPreferences preferences;
    preferences = await SharedPreferences.getInstance();

    final String endpoint =
        '${ApiConstants.studentlogin}?userName=$userName&password=$password';

    try {
      // Use ApiService to make the GET request
      final response = await ApiService.get(endpoint, context);

      if (response != null && response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        var authToken = jsonResponse['token'];
        preferences.setString("token", authToken);
        CustomSnackBar.showSuccess(context, 'Welcome To SkyTicker.');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            return MainPage(token: authToken);
          }),
        );
      } else {
        // Handle error response
        CustomSnackBar.showError(context, 'Error In Login Service');
      }
    } catch (error) {
      print('Error logging in: $error');
      CustomSnackBar.showError(context, "Error In Login Service, Try Again.");
    }
  }
}
