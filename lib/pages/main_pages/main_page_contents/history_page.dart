import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:qrbats_sp/components/texts/TextBlue.dart';
import 'package:qrbats_sp/api_services/LectureAttendedHistoryService.dart';
import 'package:qrbats_sp/models/AttendanceHistoryData.dart';

class HistoryPage extends StatefulWidget {
  final String token;

  const HistoryPage({Key? key, this.token = ""}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late double _fontSizeFactor;
  List<AttendanceData> _attendanceList = [];
  late int studentId;

  @override
  void initState() {
    super.initState();
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
    studentId = jwtDecodedToken["studentId"];
    _fetchAttendanceData();
  }

  Future<void> _fetchAttendanceData() async {
    try {
      final List<AttendanceData> attendanceList =
      await LectureAttendedHistoryService.fetchAttendanceList(studentId);
      //attendanceList.sort((a, b) => b.attendedDateTime.compareTo(a.attendedDateTime)); // Sort by descending date and time
      setState(() {
        _attendanceList = attendanceList;
        print(attendanceList);
      });
    } catch (e) {
      print('Error fetching attendance data: $e');
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: TextBlue(
                text: "Attendance History",
                fontSize: 20,
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  decoration: _buildContainerDecoration(),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columnSpacing: 10.0,
                      columns: [
                        DataColumn(
                          label: Text('No', style: TextStyle(fontSize: 12)),
                        ),
                        DataColumn(
                          label: Text('Event Name', style: TextStyle(fontSize: 12)),
                        ),
                        DataColumn(
                          label: Text('Attended Date', style: TextStyle(fontSize: 12)),
                        ),
                        DataColumn(
                          label: Text('Attended Time', style: TextStyle(fontSize: 12)),
                        ),
                      ],
                      rows: _attendanceList.map((attendance) {
                        return DataRow(cells: [
                          DataCell(
                            Text('${_attendanceList.indexOf(attendance) + 1}',
                                style: TextStyle(fontSize: 12)),
                          ),
                          DataCell(
                            Text(attendance.lectureName,
                                style: TextStyle(fontSize: 12)),
                          ),
                          DataCell(
                            Text('${attendance.attendedDate}',
                                style: TextStyle(fontSize: 12)),
                          ),
                          DataCell(
                            Text('${attendance.attendedTime}',
                                style: TextStyle(fontSize: 12)),
                          ),
                        ]);
                      }).toList(),
                    ),
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
      border: Border(
        top: BorderSide(
          color: Color(0xFF086494),
          width: 6.0,
        ),
        bottom: BorderSide(
          color: Color(0xFF086494),
          width: 1.0,
        ),
        left: BorderSide(
          color: Color(0xFF086494),
          width: 1.0,
        ),
        right: BorderSide(
          color: Color(0xFF086494),
          width: 1.0,
        ),
      ),
    );
  }
}
