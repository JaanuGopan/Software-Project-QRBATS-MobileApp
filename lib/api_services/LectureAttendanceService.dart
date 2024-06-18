import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:qrbats_sp/api_services/dto/LectureAttendanceResponse.dart';

import '../api_config/api_constants.dart';
import '../widgets/snackbar/custom_snackbar.dart';

class LectureAttendanceService {
  static Future<bool> markLectureAttendance(int studentId, String moduleCode,
      double latitude, double longitude, BuildContext context) async {

    final Uri apiUrl = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.lectureAttendanceMarking}');
    Map<String, dynamic> lectureAttendanceData = {
      "studentId": studentId,
      "moduleCode": moduleCode,
      "attendedDate": DateFormat('yyyy-MM-dd').format(DateTime.now()),
      "attendedTime": DateFormat('HH:mm:ss').format(DateTime.now()),
      "latitude": latitude,
      "longitude": longitude
    };
    print(lectureAttendanceData);

    try{
      final http.Response response = await http.post(
        apiUrl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(lectureAttendanceData),
      );

      if (response.statusCode == 200) {
        // Registration successful
        CustomSnackBar.showSnackBar(context, "Attendance marked successfully.");
        return true;

      } else if(response.statusCode == 400){
        CustomSnackBar.showSnackBar(context, response.body.toString());
        print('Failed to mark attendance: ${response.statusCode}');
        return false;
      }
      else {
        // Registration failed
        CustomSnackBar.showSnackBar(context, "Failed to mark attendance.");
        print('Failed to mark attendance: ${response.statusCode}');
        // Handle error
        return false;
      }
    }catch(error){
      CustomSnackBar.showSnackBar(context, "Error in marking attendance.");
      print('Error in marking attendance: $error');
      return false;
    }
  }


  static Future<bool> markLectureAttendanceByLectureId(int studentId, int lectureId,
      double latitude, double longitude, BuildContext context) async {

    final Uri apiUrl = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.lectureAttendanceMarkingByLectureId}');
    Map<String, dynamic> lectureAttendanceData = {
      "studentId": studentId,
      "lectureId": lectureId,
      "attendedDate": DateFormat('yyyy-MM-dd').format(DateTime.now()),
      "attendedTime": DateFormat('HH:mm:ss').format(DateTime.now()),
      "latitude": latitude,
      "longitude": longitude
    };
    print(lectureAttendanceData);

    try{
      final http.Response response = await http.post(
        apiUrl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(lectureAttendanceData),
      );

      if (response.statusCode == 200) {
        // Registration successful
        CustomSnackBar.showSnackBar(context, "Attendance marked successfully.");
        return true;

      } else if(response.statusCode == 400){
        CustomSnackBar.showSnackBar(context, response.body.toString());
        print('Failed to mark attendance: ${response.statusCode}');
        return false;
      }
      else {
        // Registration failed
        CustomSnackBar.showSnackBar(context, "Failed to mark attendance.");
        print('Failed to mark attendance: ${response.statusCode}');
        // Handle error
        return false;
      }
    }catch(error){
      CustomSnackBar.showSnackBar(context, "Error in marking attendance.");
      print('Error in marking attendance: $error');
      return false;
    }


  }
}
