import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:qrbats_sp/api_config/api_constants.dart';
import 'package:qrbats_sp/models/EnrolledModule.dart';
import 'package:qrbats_sp/widgets/snackbar/custom_snackbar.dart';

class ModuleService {
  static Future<List<EnrolledModule>> getAllEnrolledModule(BuildContext context, int studentId) async {
    final Uri apiUrl = Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.getEnrolledModuleUrl}/${studentId}');
    try {
      final http.Response response =
          await http.get(apiUrl, headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      });
      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        return responseData
            .map((data) => EnrolledModule.fromJson(data))
            .toList();
      } else if (response.statusCode == 400) {
        CustomSnackBar.showError(context, response.body.toString());
        throw Exception(response.body.toString());
      } else {
        throw Exception("Error In Getting Enrolled Modules.");
      }
    } catch (error) {
      CustomSnackBar.showSnackBar(
          context, "Error In Getting Enrolled Modules.");
      throw Exception("Error In Getting Enrolled Modules.");
    }
  }
}
