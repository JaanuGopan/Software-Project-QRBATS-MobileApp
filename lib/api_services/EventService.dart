import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qrbats_sp/api_services/config/api_service.dart';

import '../api_config/api_constants.dart';
import '../models/EventAttendanceHistoryData.dart';
import '../models/QRCodeDetails.dart';

class EventService {
  /// 🔹 Fetch Event Details by Event ID
  static Future<EventQRCodeDetails> getEventByEventId(
      BuildContext context, int eventId) async {
    final String endpoint =
        '${ApiConstants.getEventByEventId}?lectureId=$eventId';

    final response = await ApiService.get(endpoint, context);
    return EventQRCodeDetails.fromJson(jsonDecode(response!.body));
  }

  /// 🔹 Fetch Event Attendance History by Student ID
  static Future<List<EventAttendanceHistory>> getEventAttendanceHistory(
      BuildContext context) async {
    final response = await ApiService.get(
        ApiConstants.getEventAttendanceHistoryUrl, context);

    final List<dynamic> responseData = jsonDecode(response!.body);
    return responseData
        .map((data) => EventAttendanceHistory.fromJson(data))
        .toList();
  }
}
