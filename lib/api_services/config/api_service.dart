import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:qrbats_sp/api_config/api_constants.dart';
import 'package:qrbats_sp/widgets/snackbar/custom_snackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = ApiConstants.baseUrl;

  // 🔹 Get authentication headers
  static Future<Map<String, String>> _getHeaders() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    String? authToken = preferences.getString("token");

    return {
      'Content-Type': 'application/json; charset=UTF-8',
      if (authToken != null) 'Authorization': 'Bearer $authToken',
    };
  }

  // 🔹 Generic HTTP request handler with Global Error Handling
  static Future<http.Response?> _request(
    String method,
    String endpoint,
    BuildContext? context, {
    Map<String, dynamic>? body,
  }) async {
    final headers = await _getHeaders();
    final Uri url = Uri.parse('$baseUrl$endpoint');

    try {
      http.Response response;
      switch (method) {
        case 'GET':
          response = await http.get(url, headers: headers);
          break;
        case 'POST':
          response =
              await http.post(url, headers: headers, body: jsonEncode(body));
          break;
        case 'PUT':
          response =
              await http.put(url, headers: headers, body: jsonEncode(body));
          break;
        case 'DELETE':
          response = await http.delete(url, headers: headers);
          break;
        default:
          throw Exception("Invalid HTTP method");
      }

      // 🔹 Handle common response errors
      return _handleResponse(response, context);
    } catch (error) {
      if (context != null) {
        CustomSnackBar.showError(
            context, "An error occurred. Please try again.");
      }
      return null;
    }
  }

  // 🔹 Error Handling for all requests
  static http.Response? _handleResponse(
      http.Response response, BuildContext? context) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response;
    }

    if (context != null) {
      if (response.statusCode == 400) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        final String errorMessage = responseBody['message'] ?? "Bad request";
        CustomSnackBar.showError(context, errorMessage);
      } else {
        CustomSnackBar.showError(
            context, "Request failed with status ${response.statusCode}");
      }
    }

    return null;
  }

  // 🔹 GET request
  static Future<http.Response?> get(
      String endpoint, BuildContext? context) async {
    return await _request('GET', endpoint, context);
  }

  // 🔹 POST request
  static Future<http.Response?> post(
      String endpoint, Map<String, dynamic> body, BuildContext? context) async {
    return await _request('POST', endpoint, context, body: body);
  }

  // 🔹 PUT request
  static Future<http.Response?> put(
      String endpoint, Map<String, dynamic> body, BuildContext? context) async {
    return await _request('PUT', endpoint, context, body: body);
  }

  // 🔹 DELETE request
  static Future<http.Response?> delete(
      String endpoint, BuildContext? context) async {
    return await _request('DELETE', endpoint, context);
  }
}
