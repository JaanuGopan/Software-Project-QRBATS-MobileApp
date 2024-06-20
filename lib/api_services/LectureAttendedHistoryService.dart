import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_config/api_constants.dart';
import '../models/AttendanceHistoryData.dart';

class LectureAttendedHistoryService {
  static Future<List<AttendanceData>> fetchAttendanceList(int studentId) async {
    final String apiUrl = '${ApiConstants.baseUrl}${ApiConstants.getAllAttendanceHistoryByStudentIdUrl}/$studentId';

    final response = await http.get(Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'});

    print(response.body);

    if (response.statusCode == 200) {
      final List<dynamic> responseData = jsonDecode(response.body);
      return responseData.map((data) => AttendanceData.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load attendance data');
    }
  }
}
