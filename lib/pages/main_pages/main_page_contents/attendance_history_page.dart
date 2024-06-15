import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:qrbats_sp/components/attendance_history/attendance_history_component.dart';
import 'package:qrbats_sp/components/texts/TextBlue.dart';

import '../../../api_services/LectureAttendedHistoryService.dart';
import '../../../models/AttendanceHistoryData.dart';

class AttendanceHistoryPage extends StatefulWidget {
  final String token;
  const AttendanceHistoryPage({Key? key, this.token = ""}) : super(key: key);

  @override
  State<AttendanceHistoryPage> createState() => _AttendanceHistoryPageState();
}

class _AttendanceHistoryPageState extends State<AttendanceHistoryPage> {
  late double _fontSizeFactor;
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
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: screenHeight,
        width: screenWidth,
        child: Column(
          children: [
            SizedBox(height: 10),
            Center(child: Text("Attendance History", style: TextStyle(fontSize: 18),)),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                height: screenHeight * 0.7,
                width: screenWidth * 0.95,
                decoration: _buildContainerDecoration(),
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : errorMessage.isNotEmpty
                    ? Center(child: Text(errorMessage))
                    : Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ListView.builder(
                                        itemCount: _attendanceList.length,
                                        itemBuilder: (context, index) {
                      return Column(
                        children: [
                          if (index == 0) const SizedBox(height: 10),
                          AttendanceHistoryItem(
                            attendanceData: _attendanceList[index],
                            number: index + 1,
                          ),
                        ],
                      );
                                        },
                                      ),
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _buildContainerDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(10.0),
      border: Border.all(
        color: Colors.grey,
        width: 0,
      ),
    );
  }
}
