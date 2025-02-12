import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../api_config/api_constants.dart';
import '../models/AttendanceHistoryData.dart';

class LectureAttendedHistoryService {
  static Future<List<AttendanceData>> fetchAttendanceList(int studentId) async {

    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? authToken = preferences.getString("token");

    final String apiUrl = '${ApiConstants.baseUrl}${ApiConstants.getAllAttendanceHistoryByStudentIdUrl}/$studentId';

    final response = await http.get(Uri.parse(apiUrl),
        headers: {
      'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
    });

    print(response.body);

    if (response.statusCode == 200) {
      final List<dynamic> responseData = jsonDecode(response.body);
      return responseData.map((data) => AttendanceData.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load attendance data');
    }
  }
}
