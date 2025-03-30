import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qrbats_sp/models/EventAttendanceHistoryData.dart';
import 'package:qrbats_sp/models/StudentAttendanceResultDto.dart';

class LectureAttendanceHistoryItem extends StatelessWidget {
  final StudentAttendanceLectureDto studentAttendanceLectureDto;
  final int number;

  const LectureAttendanceHistoryItem({
    super.key,
    required this.number,
    required this.studentAttendanceLectureDto,
  });

  double _getFontSize(double screenWidth, {bool isSubtext = false}) {
    if (screenWidth < 360) {
      return isSubtext ? 8 : 10;
    } else if (screenWidth < 720) {
      return isSubtext ? 10 : 12;
    } else {
      return isSubtext ? 12 : 14;
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double titleFontSize = _getFontSize(screenWidth);
    double contentFontSize = _getFontSize(screenWidth, isSubtext: true);

    Icon attendanceIcon;
    Color attendanceColor;
    String attendanceText;

    switch (studentAttendanceLectureDto.attendanceStatus) {
      case AttendanceStatus.PRESENT:
        attendanceIcon = const Icon(
          Icons.check_circle,
          color: Colors.green,
          size: 50,
        );
        attendanceColor = Colors.green;
        attendanceText = "Present";
        break;
      case AttendanceStatus.LATE:
        attendanceIcon = const Icon(
          Icons.error,
          color: Colors.orange,
          size: 50,
        );
        attendanceColor = Colors.orange;
        attendanceText = "Late";
        break;
      default:
        attendanceIcon = const Icon(
          Icons.cancel,
          color: Colors.red,
          size: 50,
        );
        attendanceColor = Colors.red;
        attendanceText = "Absent";
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SizedBox(width: 10),
              Text(number.toString(),
                  style: TextStyle(fontSize: titleFontSize)),
              SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    studentAttendanceLectureDto.lectureName,
                    style: TextStyle(
                        fontSize: titleFontSize, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Lecture Date: ${DateFormat('yyyy-MM-dd').format(studentAttendanceLectureDto.lectureDate)}',
                    style: TextStyle(
                        fontSize: contentFontSize, color: Colors.grey),
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (studentAttendanceLectureDto.attendanceStatus !=
                      AttendanceStatus.ABSENT)
                    Text(
                      'Attended Time: ${studentAttendanceLectureDto.attendedTime?.substring(0, 8)}',
                      style: TextStyle(
                          fontSize: contentFontSize, color: Colors.grey),
                      overflow: TextOverflow.ellipsis,
                    ),
                  Text(
                    'Lecture Start Time: ${studentAttendanceLectureDto.lectureStartTime}',
                    style: TextStyle(
                        fontSize: contentFontSize, color: Colors.grey),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'Lecture End Time: ${studentAttendanceLectureDto.lectureEndTime}',
                    style: TextStyle(
                        fontSize: contentFontSize, color: Colors.grey),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'Lecture Venue: ${studentAttendanceLectureDto.locationName}',
                    style: TextStyle(
                        fontSize: contentFontSize, color: Colors.grey),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'Attendance Status: $attendanceText',
                    style: TextStyle(
                        fontSize: contentFontSize, color: attendanceColor),
                  ),
                ],
              ),
            ],
          ),
          attendanceIcon,
        ],
      ),
    );
  }
}

class EventAttendanceHistoryItem extends StatelessWidget {
  final EventAttendanceHistory eventAttendanceHistory;
  final int number;

  const EventAttendanceHistoryItem({
    super.key,
    required this.number,
    required this.eventAttendanceHistory,
  });

  double _getFontSize(double screenWidth, {bool isSubtext = false}) {
    if (screenWidth < 360) {
      return isSubtext ? 8 : 10;
    } else if (screenWidth < 720) {
      return isSubtext ? 10 : 12;
    } else {
      return isSubtext ? 12 : 14;
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double titleFontSize = _getFontSize(screenWidth);
    double contentFontSize = _getFontSize(screenWidth, isSubtext: true);

    return Container(
      padding: EdgeInsets.all(8.0),
      margin: EdgeInsets.symmetric(vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(width: 10),
          Text(number.toString(), style: TextStyle(fontSize: titleFontSize)),
          SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Event Name: ${eventAttendanceHistory.eventName}",
                  style: TextStyle(
                      fontSize: titleFontSize, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Text(
                  'Date: ${eventAttendanceHistory.attendedDate}',
                  style:
                      TextStyle(fontSize: contentFontSize, color: Colors.grey),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Time: ${eventAttendanceHistory.attendedTime}',
                  style:
                      TextStyle(fontSize: contentFontSize, color: Colors.grey),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Status: ${eventAttendanceHistory.attendanceStatus == "PRESENT" ? "Present" : eventAttendanceHistory.attendanceStatus == "LATE" ? "Late" : "Absent"}',
                  style: TextStyle(
                    fontSize: contentFontSize,
                    color: eventAttendanceHistory.attendanceStatus == "PRESENT"
                        ? Colors.green
                        : eventAttendanceHistory.attendanceStatus == "ABSENT"
                            ? Colors.orange
                            : Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
