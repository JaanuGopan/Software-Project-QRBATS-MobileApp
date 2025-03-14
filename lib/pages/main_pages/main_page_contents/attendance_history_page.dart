import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:qrbats_sp/api_services/EventService.dart';
import 'package:qrbats_sp/api_services/LectureService.dart';
import 'package:qrbats_sp/api_services/ModuleService.dart';
import 'package:qrbats_sp/components/attendance_history/attendance_history_component.dart';
import 'package:qrbats_sp/components/attendance_history/enrolled_module_attendance.dart';
import 'package:qrbats_sp/models/EnrolledModule.dart';
import 'package:qrbats_sp/models/EventAttendanceHistoryData.dart';
import 'package:qrbats_sp/models/StudentAttendanceHistory.dart';

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
  List<Module> _allEnrolledModuleList = [];
  bool isAllEnrolledModuleLoading = true;
  String? selectedModuleCode;
  late StudentAttendanceHistoryDto _selectedModuleStudentAttendanceHistory;

  late int studentId;

  @override
  void initState() {
    super.initState();
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
    studentId = jwtDecodedToken["userId"];
    _fetchAttendanceData(studentId);
    _fetchEventAttendanceData(studentId);
    _fetchAllEnrolledModuleData(context, studentId);
  }

  Future<void> _fetchAllEnrolledModuleData(
      BuildContext context, int studentId) async {
    try {
      final List<Module> modulesList =
          await ModuleService.getAllEnrolledModule(context, studentId);
      setState(() {
        _allEnrolledModuleList = modulesList;
        isAllEnrolledModuleLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load enrolled modules';
        isAllEnrolledModuleLoading = false;
      });
    }
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
      eventAttendanceList
          .sort((a, b) => b.attendedDate.compareTo(a.attendedDate));
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

  Future<StudentAttendanceHistoryDto> _getStudentAttendanceByModuleId(
      int moduleId, int studentId) async {
    final StudentAttendanceHistoryDto studentAttendanceHistoryDto =
        await LectureService.getStudentAttendanceByModuleId(
            context, moduleId, studentId);
    return studentAttendanceHistoryDto;
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
        if (selectedModuleCode != null)
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => setState(() => selectedModuleCode = null),
              ),
              Text(
                'Module: $selectedModuleCode',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        if (selectedModuleCode == null)
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
              fillColor:
                  showLectureHistory ? Color(0xFF086494) : Color(0xFF086494),
              selectedBorderColor:
                  showLectureHistory ? Color(0xFF086494) : Color(0xFF086494),
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        SizedBox(height: 20),
        Expanded(
          child: showLectureHistory
              ? (selectedModuleCode != null
                  ? _buildLectureHistory(selectedModuleCode!,
                      _selectedModuleStudentAttendanceHistory!)
                  : _buildEnrolledModuleAttendance())
              : _buildEventHistory(),
        ),
      ],
    );
  }

  Widget _buildEnrolledModuleAttendance() {
    return ListView.builder(
      itemCount: _allEnrolledModuleList.length,
      itemBuilder: (context, index) {
        final module = _allEnrolledModuleList[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 5),
          child: FutureBuilder<StudentAttendanceHistoryDto>(
            future: _getStudentAttendanceByModuleId(module.moduleId, studentId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error loading attendance data');
              } else if (!snapshot.hasData) {
                return Text('No attendance data available');
              }
              double attendancePercentage = snapshot.data!.attendancePercentage;
              return EnrolledModuleAttendance(
                enrolledModule: module,
                number: index + 1,
                attendancePercentage: attendancePercentage,
                onTap: (moduleCode, moduleId) {
                  setState(() {
                    selectedModuleCode = moduleCode;
                    _selectedModuleStudentAttendanceHistory = snapshot.data!;
                  });
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildLectureHistory(String moduleCode,
      StudentAttendanceHistoryDto studentAttendanceHistoryDto) {
    List<AttendanceData> attendanceDataList = List.empty(growable: true);
    studentAttendanceHistoryDto.studentAttendancesLectureList
        .forEach((element) {
      AttendanceData attendanceData = AttendanceData(
          lectureName: element.lectureName,
          lectureModuleCode: moduleCode,
          lectureModuleName: moduleCode,
          attendedDate: element.attendedDate.toIso8601String().split('T')[0],
          attendedTime:
              StudentAttendanceLectureDto.formatTime(element.attendedTime),
          attendanceStatus:
              element.attendanceStatus == AttendanceStatus.PRESENT);
      attendanceDataList.add(attendanceData);
    });
    return ListView.builder(
      itemCount: attendanceDataList.length,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
        child: LectureAttendanceHistoryItem(
          attendanceData: attendanceDataList[index],
          number: index + 1,
        ),
      ),
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
