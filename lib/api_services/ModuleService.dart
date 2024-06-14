import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:qrbats_sp/api_config/api_constants.dart';
import 'package:qrbats_sp/models/EnrolledModule.dart';
import 'package:qrbats_sp/widgets/snackbar/custom_snackbar.dart';

class ModuleService {
  static Future<List<Module>> getAllModule(BuildContext context, int studentId) async {

    final Uri apiUrl = Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.getAllModuleByStudentId}/${studentId}');
    try {
      final http.Response response =
          await http.get(apiUrl, headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      });
      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        return responseData
            .map((data) => Module.fromJson(data))
            .toList();
      } else if (response.statusCode == 400) {
        CustomSnackBar.showError(context, response.body.toString());
        throw Exception(response.body.toString());
      } else {
        throw Exception("Error In Getting Modules.");
      }
    } catch (error) {
      CustomSnackBar.showError(
          context, "Error In Getting Modules.");
      throw Exception("Error In Getting Modules.");
    }
  }

  static Future<void> moduleEnrollment(BuildContext context,int moduleId,int studentId,String enrollmentKey) async {
    final Uri apiUrl = Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.moduleEnrollmentUrl}?moduleId=$moduleId&studentId=$studentId&enrollmentKey=$enrollmentKey');
    try {
      final http.Response response = await http.post(
        apiUrl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if(response.statusCode == 200){
        CustomSnackBar.showSuccess(context, "Module Successfully Enrolled.");
      } else if(response.statusCode == 400){
        CustomSnackBar.showError(context, response.body.toString());
        throw Exception(response.body.toString());
      } else{
        throw Exception("Error In Getting Enrolled Modules.");
      }
    }catch(error){
      CustomSnackBar.showError(
          context, "Error In Module Enrollment.");
      throw Exception("Error In Module Enrollment.");
    }

  }

  static Future<void> moduleUnEnrollment(BuildContext context,int moduleId,int studentId) async {
    final Uri apiUrl = Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.moduleUnEnrollmentUrl}?moduleId=$moduleId&studentId=$studentId');
    try {
      final http.Response response = await http.delete(
        apiUrl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if(response.statusCode == 200){
        CustomSnackBar.showSuccess(context, "Module Successfully UnEnrolled.");
      } else if(response.statusCode == 400){
        CustomSnackBar.showError(context, response.body.toString());
        throw Exception(response.body.toString());
      } else{
        throw Exception("Error In Module UnEnrollment.");
      }
    }catch(error){
      CustomSnackBar.showError(
          context, "Error In Module UnEnrollment.");
      throw Exception("Error In Module UnEnrollment.");
    }

  }

  static Future<List<Module>> getAllEnrolledModule(BuildContext context, int studentId) async {

    final Uri apiUrl = Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.getAllEnrolledModuleByStudentId}/${studentId}');
    try {
      final http.Response response =
      await http.get(apiUrl, headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      });
      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        return responseData
            .map((data) => Module.fromJson(data))
            .toList();
      } else if (response.statusCode == 400) {
        CustomSnackBar.showError(context, response.body.toString());
        throw Exception(response.body.toString());
      } else {
        throw Exception("Error In Getting Enrolled Modules.");
      }
    } catch (error) {
      CustomSnackBar.showError(
          context, "Error In Getting Enrolled Modules.");
      throw Exception("Error In Getting Enrolled Modules.");
    }
  }


}
