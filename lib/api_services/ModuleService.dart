import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:qrbats_sp/api_config/api_constants.dart';
import 'package:qrbats_sp/api_services/config/api_service.dart';
import 'package:qrbats_sp/models/EnrolledModule.dart';
import 'package:qrbats_sp/widgets/snackbar/custom_snackbar.dart';

class ModuleService {
  // 🔹 Get Module by Module Code
  static Future<Module> getModuleByModuleCode(
      BuildContext context, String moduleCode) async {
    final endpoint =
        '${ApiConstants.getModuleByModuleCode}?moduleCode=$moduleCode';

    try {
      final response = await ApiService.get(endpoint, context);

      if (response != null && response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        Module returnModule = Module.fromJson(responseData);
        return returnModule;
      } else {
        String errorMessage = response?.body ?? "Unexpected error occurred.";
        CustomSnackBar.showError(context, errorMessage);
        throw Exception(errorMessage);
      }
    } catch (error) {
      CustomSnackBar.showError(context, "Error In Getting Module.");
      throw Exception("Error In Getting Module: ${error.toString()}");
    }
  }

  // 🔹 Get All Modules
  static Future<List<Module>> getAllModule(BuildContext context) async {
    final endpoint = ApiConstants.getAllModuleByStudentId;

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
      CustomSnackBar.showError(context, "Error In Getting Modules.");
      throw Exception("Error In Getting Modules.");
    }
  }

  // 🔹 Enroll in a Module
  static Future<void> moduleEnrollment(
      BuildContext context, int moduleId, String enrollmentKey) async {
    final endpoint =
        '${ApiConstants.moduleEnrollmentUrl}?moduleId=$moduleId&enrollmentKey=$enrollmentKey';

    try {
      final response = await ApiService.post(endpoint, {}, context);

      if (response != null && response.statusCode == 200) {
        CustomSnackBar.showSuccess(context, "Module Successfully Enrolled.");
      } else {
        String errorMessage = response?.body ?? "Unexpected error occurred.";
        CustomSnackBar.showError(context, errorMessage);
        throw Exception(errorMessage);
      }
    } catch (error) {
      CustomSnackBar.showError(context, "Error In Module Enrollment.");
      throw Exception("Error In Module Enrollment.");
    }
  }

  // 🔹 Unenroll from a Module
  static Future<void> moduleUnEnrollment(
      BuildContext context, int moduleId) async {
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
