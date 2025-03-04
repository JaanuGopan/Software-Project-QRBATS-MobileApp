import 'package:flutter/material.dart';

class StudentAttendanceHistoryDto {
  final List<StudentAttendanceLectureDto> studentAttendancesLectureList;
  final int attendanceCount;
  final int missedAttendanceCount;
  final double attendancePercentage;

  StudentAttendanceHistoryDto({
    required this.studentAttendancesLectureList,
    required this.attendanceCount,
    required this.missedAttendanceCount,
    required this.attendancePercentage,
  });

  factory StudentAttendanceHistoryDto.fromJson(Map<String, dynamic> json) {
    return StudentAttendanceHistoryDto(
      studentAttendancesLectureList:
          (json['studentAttendancesLectureList'] as List)
              .map((e) => StudentAttendanceLectureDto.fromJson(e))
              .toList(),
      attendanceCount: json['attendanceCount'] ?? 0,
      missedAttendanceCount: json['missedAttendanceCount'] ?? 0,
      attendancePercentage: (json['attendancePercentage'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'studentAttendancesLectureList':
          studentAttendancesLectureList.map((e) => e.toJson()).toList(),
      'attendanceCount': attendanceCount,
      'missedAttendanceCount': missedAttendanceCount,
      'attendancePercentage': attendancePercentage,
    };
  }
}

class StudentAttendanceLectureDto {
  final String lectureName;
  final TimeOfDay attendedTime;
  final DateTime attendedDate;
  final AttendanceStatus attendanceStatus;

  StudentAttendanceLectureDto({
    required this.lectureName,
    required this.attendedTime,
    required this.attendedDate,
    required this.attendanceStatus,
  });

  factory StudentAttendanceLectureDto.fromJson(Map<String, dynamic> json) {
    return StudentAttendanceLectureDto(
      lectureName: json['lectureName'] ?? '',
      attendedTime: _parseTime(json['attendedTime'] ?? '00:00:00'),
      attendedDate: DateTime.parse(json['attendedDate']),
      attendanceStatus:
          AttendanceStatus.values.byName(json['attendanceStatus']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lectureName': lectureName,
      'attendedTime': formatTime(attendedTime),
      'attendedDate': attendedDate.toIso8601String().split('T')[0],
      'attendanceStatus': attendanceStatus.name,
    };
  }

  // Helper method to parse time (e.g., "19:03:37") into TimeOfDay
  static TimeOfDay _parseTime(String time) {
    final parts = time.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    return TimeOfDay(hour: hour, minute: minute);
  }

  // Helper method to format TimeOfDay back to string ("HH:mm:ss")
  static String formatTime(TimeOfDay time) {
    final String hour = time.hour.toString().padLeft(2, '0');
    final String minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute:00';
  }
}

enum AttendanceStatus {
  PRESENT,
  ABSENT,
}
