import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:skyticker/api/config/api_constants.dart';
import 'package:skyticker/api/config/api_service.dart';
import 'package:skyticker/models/EnrolledModule.dart';
import 'package:skyticker/widgets/snackbar/custom_snackbar.dart';

class ModuleService {
  // 🔹 Get Module by Module Code
  static Future<Module> getModuleByModuleCode(
    BuildContext context,
    int moduleId,
  ) async {
    final endpoint = '${ApiConstants.getModuleByModuleCode}?moduleId=$moduleId';

    final response = await ApiService.get(endpoint, context);

    final responseData = jsonDecode(response!.body);
    Module returnModule = Module.fromJson(responseData);
    return returnModule;
  }

  // 🔹 Get All Modules
  static Future<List<Module>> getAllModule(BuildContext context) async {
    const endpoint = ApiConstants.getAllModuleByStudentId;

    final response = await ApiService.get(endpoint, context);

    if (response != null && response.statusCode == 200) {
      final List<dynamic> responseData = jsonDecode(response.body);
      return responseData.map((data) => Module.fromJson(data)).toList();
    }
    return [];
  }

  // 🔹 Enroll in a Module
  static Future<void> moduleEnrollment(
    BuildContext context,
    int moduleId,
    String enrollmentKey,
  ) async {
    final endpoint =
        '${ApiConstants.moduleEnrollmentUrl}?moduleId=$moduleId&enrollmentKey=$enrollmentKey';

    final response = await ApiService.post(endpoint, {}, context);

    if (response != null && response.statusCode == 200) {
      CustomSnackBar.showSuccess(context, "Module Successfully Enrolled.");
    }
  }

  // 🔹 Unenroll from a Module
  static Future<void> moduleUnEnrollment(
    BuildContext context,
    int moduleId,
  ) async {
    final endpoint = '${ApiConstants.moduleUnEnrollmentUrl}?moduleId=$moduleId';

    try {
      final response = await ApiService.delete(endpoint, context);

      if (response != null && response.statusCode == 200) {
        CustomSnackBar.showSuccess(context, "Module Successfully UnEnrolled.");
      } else {
        String errorMessage = response?.body ?? "Unexpected error occurred.";
        CustomSnackBar.showError(context, errorMessage);
        throw Exception(errorMessage);
      }
    } catch (error) {
      CustomSnackBar.showError(context, "Error In Module UnEnrollment.");
      throw Exception("Error In Module UnEnrollment.");
    }
  }

  // 🔹 Get All Enrolled Modules
  static Future<List<Module>> getAllEnrolledModule(BuildContext context) async {
    final endpoint = ApiConstants.getAllEnrolledModuleByStudentId;

    try {
      final response = await ApiService.get(endpoint, context);

      if (response != null && response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        return responseData.map((data) => Module.fromJson(data)).toList();
      } else {
        String errorMessage = response?.body ?? "Unexpected error occurred.";
        CustomSnackBar.showError(context, errorMessage);
        throw Exception(errorMessage);
      }
    } catch (error) {
      CustomSnackBar.showError(context, "Error In Getting Enrolled Modules.");
      throw Exception("Error In Getting Enrolled Modules.");
    }
  }
}
