import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qrbats_sp/api_services/config/api_service.dart';

import '../api_config/api_constants.dart';
import '../models/EventAttendanceHistoryData.dart';
import '../models/QRCodeDetails.dart';
import '../widgets/snackbar/custom_snackbar.dart';

class EventService {
  /// 🔹 Fetch Event Details by Event ID
  static Future<EventQRCodeDetails> getEventByEventId(
      BuildContext context, int eventId) async {
    final String endpoint = '${ApiConstants.getEventByEventId}/$eventId';

    try {
      final response = await ApiService.get(endpoint, context);
      if (response == null) {
        throw Exception("Error in getting event.");
      }

      if (response.statusCode == 200) {
        return EventQRCodeDetails.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(response.body.toString());
      }
    } catch (error) {
      CustomSnackBar.showError(context, "Error in getting event.");
      throw Exception("Error in getting event.");
    }
  }

  /// 🔹 Fetch Event Attendance History by Student ID
  static Future<List<EventAttendanceHistory>> getEventAttendanceHistory(
      BuildContext context) async {
    final String endpoint = '${ApiConstants.getEventAttendanceHistoryUrl}';

    try {
      final response = await ApiService.get(endpoint, context);
      if (response == null) {
        throw Exception("Error in getting event history.");
      }

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        return responseData
            .map((data) => EventAttendanceHistory.fromJson(data))
            .toList();
      } else {
        throw Exception(response.body.toString());
      }
    } catch (error) {
      CustomSnackBar.showError(context, "Error in getting event history.");
      throw Exception("Error in getting event history.");
    }
  }
}
