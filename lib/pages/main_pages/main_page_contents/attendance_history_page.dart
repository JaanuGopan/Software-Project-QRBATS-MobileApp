import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:qrbats_sp/api_services/EventService.dart';
import 'package:qrbats_sp/components/attendance_history/attendance_history_component.dart';
import 'package:qrbats_sp/models/EventAttendanceHistoryData.dart';
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
  List<EventAttendanceHistory> _eventAttendanceData = [];
  bool isLoading = true;
  bool isEventAttendanceHistoryLoading = true;
  String errorMessage = '';
  String eventHistoryErrorMessage = '';
  bool showLectureHistory = true;

  late int studentId;

  @override
  void initState() {
    super.initState();
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
    studentId = jwtDecodedToken["studentId"];
    _fetchAttendanceData(studentId);
    _fetchEventAttendanceData(studentId);
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

  Future<void> _fetchEventAttendanceData(int studentId) async {
    try {
      final List<EventAttendanceHistory> eventAttendanceList =
      await EventService.getEventAttendanceHistory(context, studentId);
      eventAttendanceList.sort((a, b) => b.attendedDate.compareTo(a.attendedDate));
      setState(() {
        _eventAttendanceData = eventAttendanceList;
        isEventAttendanceHistoryLoading = false;
      });
    } catch (e) {
      setState(() {
        isEventAttendanceHistoryLoading = false;
        eventHistoryErrorMessage = 'Failed to load event attendance history.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: isLoading || isEventAttendanceHistoryLoading
            ? Center(child: CircularProgressIndicator())
            : errorMessage.isNotEmpty
            ? Center(child: Text(errorMessage))
            : eventHistoryErrorMessage.isNotEmpty
            ? Center(child: Text(eventHistoryErrorMessage))
            : _buildAttendanceContent(),
      ),
    );
  }

  Widget _buildAttendanceContent() {
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
        Center(
          child: ToggleButtons(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text('Lecture History'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text('Event History'),
              ),
            ],
            isSelected: [showLectureHistory, !showLectureHistory],
            onPressed: (int index) {
              setState(() {
                showLectureHistory = index == 0;
              });
            },
            color: Colors.black,
            selectedColor: Colors.white,
            fillColor: showLectureHistory ? Color(0xFF086494) : Color(0xFF086494),
            selectedBorderColor: showLectureHistory ? Color(0xFF086494) : Color(0xFF086494),
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        SizedBox(height: 20),
        Expanded(
          child: showLectureHistory ? _buildLectureHistory() : _buildEventHistory(),
        ),
      ],
    );
  }

  Widget _buildLectureHistory() {
    return ListView.builder(
      itemCount: _attendanceList.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 10, right: 10),
          child: LectureAttendanceHistoryItem(
            attendanceData: _attendanceList[index],
            number: index + 1,
          ),
        );
      },
    );
  }

  Widget _buildEventHistory() {
    return ListView.builder(
      itemCount: _eventAttendanceData.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 10, right: 10),
          child: EventAttendanceHistoryItem(
            eventAttendanceHistory: _eventAttendanceData[index],
            number: index + 1,
          ),
        );
      },
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: AttendanceHistoryPage(token: "sampleToken"),
  ));
}
