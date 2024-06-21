import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:qrbats_sp/components/attendance_history/attendance_history_component.dart';
import '../../../api_services/LectureAttendedHistoryService.dart';
import '../../../models/AttendanceHistoryData.dart';

class AttendanceHistoryPage extends StatefulWidget {
  final String token;

  const AttendanceHistoryPage({Key? key, this.token = ""}) : super(key: key);

  @override
  State<AttendanceHistoryPage> createState() => _AttendanceHistoryPageState();
}

class _AttendanceHistoryPageState extends State<AttendanceHistoryPage> {
  List<AttendanceData> _attendanceList = [];
  bool isLoading = true;
  String errorMessage = '';

  late int studentId;

  @override
  void initState() {
    super.initState();
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
    studentId = jwtDecodedToken["studentId"];
    _fetchAttendanceData(studentId);
  }

  Future<void> _fetchAttendanceData(int studentId) async {
    try {
      final List<AttendanceData> attendanceList =
      await LectureAttendedHistoryService.fetchAttendanceList(studentId);
      attendanceList.sort((a, b) => b.attendedDate.compareTo(a.attendedDate));
      setState(() {
        _attendanceList = attendanceList;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to load attendance history.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : errorMessage.isNotEmpty
            ? Center(child: Text(errorMessage))
            : _buildAttendanceList(),
      ),
    );
  }

  Widget _buildAttendanceList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 10),
        Center(
          child: Text(
            'Attendance History',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 10),
        Expanded(
          child: SingleChildScrollView(
            child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _attendanceList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 10, right: 10),
                  child: AttendanceHistoryItem(
                    attendanceData: _attendanceList[index],
                    number: index + 1,
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: AttendanceHistoryPage(token: "sampleToken"),
  ));
}
