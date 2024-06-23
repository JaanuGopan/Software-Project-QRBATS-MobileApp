import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:qrbats_sp/api_config/api_constants.dart';
import 'package:qrbats_sp/models/EventAttendanceHistoryData.dart';
import 'package:qrbats_sp/models/QRCodeDetails.dart';
import 'package:qrbats_sp/widgets/snackbar/custom_snackbar.dart';

class EventService{
  static Future<EventQRCodeDetails> getEventByEventId(
      BuildContext context, int eventId) async {
    final Uri apiUrl = Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.getEventByEventId}/$eventId');
    try {
      final http.Response response =
      await http.get(apiUrl, headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      });
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        EventQRCodeDetails scannedEvent = EventQRCodeDetails.fromJson(responseData);
        return scannedEvent;
      } else if (response.statusCode == 400) {
        CustomSnackBar.showError(context, response.body.toString());
        throw Exception(response.body.toString());
      } else {
        throw Exception("Error In Getting Event.");
      }
    } catch (error) {
      CustomSnackBar.showError(context, "Error In Getting Event.");
      throw Exception("Error In Getting Event.");
    }
  }

  static Future<List<EventAttendanceHistory>> getEventAttendanceHistory(
      BuildContext context, int studentId) async {
    final Uri apiUrl = Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.getEventAttendanceHistoryUrl}/$studentId');
    try {
      final http.Response response =
      await http.get(apiUrl, headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      });

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        List<EventAttendanceHistory> history = responseData
            .map((data) => EventAttendanceHistory.fromJson(data))
            .toList();
        return history;
      } else if (response.statusCode == 400) {
        CustomSnackBar.showError(context, response.body.toString());
        throw Exception(response.body.toString());
      } else {
        throw Exception("Error in getting event history.");
      }
    } catch (error) {
      CustomSnackBar.showError(context, "Error in getting event history.");
      throw Exception("Error in getting event history.");
    }
  }


}