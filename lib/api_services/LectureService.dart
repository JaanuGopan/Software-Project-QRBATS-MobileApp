import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:qrbats_sp/api_config/api_constants.dart';
import 'package:qrbats_sp/models/Lecture.dart';
import 'package:qrbats_sp/widgets/snackbar/custom_snackbar.dart';

class LectureService {
  static Future<List<Lecture>> getAllLectureByModuleCode(
      BuildContext context, String moduleCode) async {
    final Uri apiUrl = Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.getAllLecturesByModuleCode}?moduleCode=${moduleCode}');
    try {
      final http.Response response =
          await http.get(apiUrl, headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      });
      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        List<Lecture> lecturesList = responseData.map((data) => Lecture.fromJson(data)).toList();
        print("Lecture List: "+ lecturesList.toString());
        return lecturesList;
      } else if (response.statusCode == 400) {
        CustomSnackBar.showError(context, response.body.toString());
        throw Exception(response.body.toString());
      } else {
        throw Exception("Error In Getting Lectures.");
      }
    } catch (error) {
      CustomSnackBar.showError(context, "Error In Getting Lectures.");
      throw Exception("Error In Getting Lectures.");
    }
  }
}
