import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skyticker/api/config/api_constants.dart';
import 'package:skyticker/api/config/api_service.dart';
import 'package:skyticker/pages/main_pages/main_page.dart';
import 'package:skyticker/widgets/snackbar/custom_snackbar.dart';

class LoginService {
  static Future<void> login(
    BuildContext context,
    String userName,
    String password,
    String? deviceId,
  ) async {
    late SharedPreferences preferences;
    preferences = await SharedPreferences.getInstance();

    final String endpoint =
        '${ApiConstants.studentlogin}?userName=$userName&password=$password&deviceId=$deviceId';

    // Use ApiService to make the GET request
    final response = await ApiService.get(endpoint, context);

    if (response != null && response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      var authToken = jsonResponse['token'];
      preferences.setString("token", authToken);
      CustomSnackBar.showSuccess(context, 'Welcome To SkyTicker.');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return MainPage(token: authToken);
          },
        ),
      );
    }
  }
}
