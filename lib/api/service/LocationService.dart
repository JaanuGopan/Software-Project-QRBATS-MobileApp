import 'package:flutter/cupertino.dart';
import 'package:skyticker/api/config/api_constants.dart';
import 'package:skyticker/api/config/api_service.dart';

class LocationService {
  static Future<double> findLocationDistance(
    String locationName,
    double latitude,
    double longitude,
    BuildContext context,
  ) async {
    final requestBody = {
      'locationName': locationName,
      'latitude': latitude,
      'longitude': longitude,
    };

    try {
      final response = await ApiService.post(
        ApiConstants.getAttendanceDistance, // Endpoint
        requestBody,
        context,
      );

      if (response != null && response.statusCode == 200) {
        return double.parse(response.body);
      } else {
        throw Exception('Failed to load attendance data');
      }
    } catch (e) {
      rethrow;
    }
  }
}
