import 'package:flutter/material.dart';
import 'package:qrbats_sp/api_services/EventService.dart';
import 'package:qrbats_sp/api_services/LectureAttendedHistoryService.dart';
import 'package:qrbats_sp/api_services/ModuleService.dart';
import 'package:qrbats_sp/components/attendance_history/attendance_history_component.dart';
import 'package:qrbats_sp/components/attendance_history/enrolled_module_attendance.dart';
import 'package:qrbats_sp/models/EnrolledModule.dart';
import 'package:qrbats_sp/models/EventAttendanceHistoryData.dart';
import 'package:qrbats_sp/models/StudentAttendanceResultDto.dart';

class AttendanceHistoryPage extends StatefulWidget {
  const AttendanceHistoryPage({super.key});

  @override
  State<AttendanceHistoryPage> createState() => _AttendanceHistoryPageState();
}

class _AttendanceHistoryPageState extends State<AttendanceHistoryPage> {
  List<EventAttendanceHistory> _eventAttendanceData = [];
  List<Module> _allEnrolledModuleList = [];
  StudentAttendanceResultDto? studentAttendanceResultDto;
  Module? selectedModule;
  bool isLoading = false;
  bool isEventAttendanceHistoryLoading = true;
  bool isAllEnrolledModuleLoading = true;
  bool showLectureHistory = true;
  String errorMessage = '';
  String eventHistoryErrorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchAllEnrolledModuleData();
  }

  Future<void> _fetchAllEnrolledModuleData() async {
    try {
      final modulesList = await ModuleService.getAllEnrolledModule(context);
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

  Future<void> _fetchAttendanceData(int moduleId) async {
    setState(() => isLoading = true);
    try {
      final resultDto =
          await LectureAttendedHistoryService.fetchModuleAttendanceForStudent(
              moduleId, context);
      setState(() {
        studentAttendanceResultDto = resultDto;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to load attendance history.';
      });
    }
  }

  Future<void> _fetchEventAttendanceData() async {
    try {
      final eventAttendanceList =
          await EventService.getEventAttendanceHistory(context);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: isAllEnrolledModuleLoading
            ? const Center(child: CircularProgressIndicator())
            : errorMessage.isNotEmpty
                ? Center(child: Text(errorMessage))
                : _buildAttendanceContent(),
      ),
    );
  }

  Widget _buildAttendanceContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (selectedModule == null)
          Center(
            child: ToggleButtons(
              children: const [
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('Lecture History')),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('Event History')),
              ],
              isSelected: [showLectureHistory, !showLectureHistory],
              onPressed: (index) =>
                  setState(() => showLectureHistory = index == 0),
              color: Colors.black,
              selectedColor: Colors.white,
              fillColor: Color(0xFF086494),
              selectedBorderColor: Color(0xFF086494),
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        if (selectedModule == null) SizedBox(height: 20),
        Expanded(
          child: showLectureHistory
              ? (selectedModule != null
                  ? _buildLectureHistory(selectedModule!)
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
        return EnrolledModuleAttendance(
          enrolledModule: module,
          number: index + 1,
          attendancePercentage: 80.0, // Placeholder
          onTap: (module) {
            _fetchAttendanceData(module.id);
            setState(() => selectedModule = module);
          },
        );
      },
    );
  }

  Widget _buildLectureHistory(Module module) {
    final totalLectureCount =
        (studentAttendanceResultDto?.attendanceCount ?? 0) +
            (studentAttendanceResultDto?.notAttendanceCount ?? 0);
    final attendedLectureCount =
        studentAttendanceResultDto?.attendanceCount ?? 0;
    final attendancePercentage =
        studentAttendanceResultDto?.attendancePercentage ?? 0;
    final missedLectureCount =
        studentAttendanceResultDto?.notAttendanceCount ?? 0;
    final completedLectureHours =
        studentAttendanceResultDto?.finishedLectureHours.inHours ?? 0;
    final attendedLectureHours =
        studentAttendanceResultDto?.attendanceHours.inHours ?? 0;

    return Column(
      children: [
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => setState(() => selectedModule = null),
            ),
            Expanded(
              child: Text(
                '${module.moduleName} (${module.moduleCode})',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.ellipsis,
                ),
                maxLines: 1, // Ensures text remains on a single line
                softWrap: false, // Prevents text from wrapping to a new line
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12, // Soft shadow
                  blurRadius: 6.0,
                  spreadRadius: 2.0,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Attendance Summary',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                SizedBox(height: 12),
                Text('Total Finished Lectures: $totalLectureCount'),
                Text('Attended Lectures: $attendedLectureCount'),
                Text('Missed Lectures: $missedLectureCount'),
                Text('Total Finished Lectures Hours: $completedLectureHours'),
                Text('Attended Lecture Hours: $attendedLectureHours'),
                Text(
                  'Attendance Percentage: ${attendancePercentage.toStringAsFixed(2)}%',
                  style: TextStyle(
                    color:
                        attendancePercentage > 80 ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        const Row(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
              child: Text(
                'Lecture History',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
            ),
          ],
        ),
        isLoading
            ? const Center(child: CircularProgressIndicator())
            : Expanded(
                child: ListView.builder(
                  itemCount: studentAttendanceResultDto
                          ?.studentAttendancesLectureList.length ??
                      0,
                  itemBuilder: (context, index) {
                    final attendanceData = studentAttendanceResultDto!
                        .studentAttendancesLectureList[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 8.0),
                      child: LectureAttendanceHistoryItem(
                        studentAttendanceLectureDto: attendanceData,
                        number: index + 1,
                      ),
                    );
                  },
                ),
              ),
      ],
    );
  }

  Widget _buildEventHistory() {
    return ListView.builder(
      itemCount: _eventAttendanceData.length,
      itemBuilder: (context, index) {
        return EventAttendanceHistoryItem(
          eventAttendanceHistory: _eventAttendanceData[index],
          number: index + 1,
        );
      },
    );
  }
}
