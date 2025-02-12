import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../api_config/api_constants.dart';
import '../../pages/main_pages/main_page.dart';
import '../widgets/snackbar/custom_snackbar.dart'; // Import CustomSnackBar class

class LoginService {
  static Future<void> login(BuildContext context, String userName, String password) async {
    late SharedPreferences preferences;
    preferences = await SharedPreferences.getInstance();

    final Uri apiUrl = Uri.parse('${ApiConstants.mobileBaseUrl}${ApiConstants.studentlogin}?userName=$userName&password=$password');

    try {
      final http.Response response = await http.get(
        apiUrl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        }
      );

      if (response.statusCode == 200) {
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
        if(response.statusCode == 400) {
          CustomSnackBar.showError(context, response.body.toString());
        } 
        CustomSnackBar.showError(context, 'Error In Login Service');
      }
    } catch (error) {
      print('Error registering user: $error');
      CustomSnackBar.showError(context, "Error In Login Service, Try Again.");
    }
  }
}
