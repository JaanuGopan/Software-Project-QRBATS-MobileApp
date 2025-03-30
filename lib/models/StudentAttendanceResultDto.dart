import 'package:intl/intl.dart';

class StudentAttendanceResultDto {
  List<StudentAttendanceLectureDto> studentAttendancesLectureList;
  int attendanceCount;
  int notAttendanceCount;
  int finishedLectureCount;
  String attendanceHours;
  String notAttendanceHours;
  String finishedLectureHours;
  double attendancePercentage;

  StudentAttendanceResultDto({
    required this.studentAttendancesLectureList,
    required this.attendanceCount,
    required this.notAttendanceCount,
    required this.finishedLectureCount,
    required this.attendanceHours,
    required this.notAttendanceHours,
    required this.finishedLectureHours,
    required this.attendancePercentage,
  });

  // Method to convert from JSON
  factory StudentAttendanceResultDto.fromJson(Map<String, dynamic> json) {
    return StudentAttendanceResultDto(
      studentAttendancesLectureList:
          (json['studentAttendancesLectureList'] as List)
              .map((e) => StudentAttendanceLectureDto.fromJson(e))
              .toList(),
      attendanceCount: json['attendanceCount'] ?? 0,
      notAttendanceCount: json['notAttendanceCount'] ?? 0,
      finishedLectureCount: json['finishedLectureCount'] ?? 0,
      attendanceHours: json['attendanceHours'],
      notAttendanceHours: json['notAttendanceHours'],
      finishedLectureHours: json['finishedLectureHours'],
      attendancePercentage:
          (json['attendancePercentage'] as num?)?.toDouble() ?? 0.0,
    );
  }

  // Method to convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'studentAttendancesLectureList':
          studentAttendancesLectureList.map((e) => e.toJson()).toList(),
      'attendanceCount': attendanceCount,
      'notAttendanceCount': notAttendanceCount,
      'finishedLectureCount': finishedLectureCount,
      'attendanceHours': attendanceHours,
      'notAttendanceHours': notAttendanceHours,
      'finishedLectureHours': finishedLectureHours,
      'attendancePercentage': attendancePercentage,
    };
  }

  // **Override toString() for better debugging**
  @override
  String toString() {
    return '''
StudentAttendanceResultDto(
  attendanceCount: $attendanceCount,
  notAttendanceCount: $notAttendanceCount,
  finishedLectureCount: $finishedLectureCount,
  attendanceHours: ${(attendanceHours)},
  notAttendanceHours: ${(notAttendanceHours)},
  finishedLectureHours: ${(finishedLectureHours)},
  attendancePercentage: $attendancePercentage,
  studentAttendancesLectureList: $studentAttendancesLectureList
)''';
  }
}

class StudentAttendanceLectureDto {
  String lectureName;
  DateTime lectureDate;
  String lectureStartTime;
  String lectureEndTime;
  String locationName;
  String? attendedTime;
  DateTime? attendedDate;
  AttendanceStatus attendanceStatus;

  StudentAttendanceLectureDto({
    required this.lectureName,
    required this.lectureDate,
    required this.lectureStartTime,
    required this.lectureEndTime,
    required this.locationName,
    this.attendedTime,
    this.attendedDate,
    required this.attendanceStatus,
  });

  // Method to convert from JSON
  factory StudentAttendanceLectureDto.fromJson(Map<String, dynamic> json) {
    return StudentAttendanceLectureDto(
      lectureName: json['lectureName'],
      lectureDate: DateTime.parse(json['lectureDate']),
      lectureStartTime: json['lectureStartTime'],
      lectureEndTime: json['lectureEndTime'],
      locationName: json['locationName'],
      attendedTime: json['attendedTime'],
      attendedDate: json['attendedDate'] != null
          ? DateTime.tryParse(json['attendedDate'])
          : null,
      attendanceStatus: AttendanceStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['attendanceStatus'],
        orElse: () => AttendanceStatus.ABSENT,
      ),
    );
  }

  // Method to convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'lectureName': lectureName,
      'lectureDate': DateFormat('yyyy-MM-dd').format(lectureDate),
      'lectureStartTime': lectureStartTime,
      'lectureEndTime': lectureEndTime,
      'locationName': locationName,
      'attendedTime': attendedTime,
      'attendedDate': attendedDate != null
          ? DateFormat('yyyy-MM-dd').format(attendedDate!)
          : null,
      'attendanceStatus': attendanceStatus.toString().split('.').last,
    };
  }

  // **Override toString() for better debugging**
  @override
  String toString() {
    return '''
StudentAttendanceLectureDto(
  lectureName: $lectureName,
  lectureDate: ${DateFormat('yyyy-MM-dd').format(lectureDate)},
  lectureStartTime: $lectureStartTime,
  lectureEndTime: $lectureEndTime,
  locationName: $locationName,
  attendedTime: ${attendedTime},
  attendedDate: ${attendedDate != null ? DateFormat('yyyy-MM-dd').format(attendedDate!) : 'null'},
  attendanceStatus: $attendanceStatus
)''';
  }
}

// Enum for Attendance Status
enum AttendanceStatus { PRESENT, ABSENT, LATE }

// **Function to parse ISO 8601 duration format (e.g., "PT2H46M")**
Duration parseISO8601Duration(String? duration) {
  if (duration == null || !duration.startsWith('PT')) return Duration.zero;

  final regex = RegExp(r'PT(?:(\d+)H)?(?:(\d+)M)?(?:(\d+)S)?');
  final match = regex.firstMatch(duration);

  if (match == null) return Duration.zero;

  int hours = int.tryParse(match.group(1) ?? '0') ?? 0;
  int minutes = int.tryParse(match.group(2) ?? '0') ?? 0;
  int seconds = int.tryParse(match.group(3) ?? '0') ?? 0;

  return Duration(hours: hours, minutes: minutes, seconds: seconds);
}

// **Function to convert Duration to ISO 8601 format (e.g., "PT2H46M")**
String formatDurationToISO8601(Duration duration) {
  int hours = duration.inHours;
  int minutes = duration.inMinutes.remainder(60);
  int seconds = duration.inSeconds.remainder(60);

  String result = 'PT';
  if (hours > 0) result += '${hours}H';
  if (minutes > 0) result += '${minutes}M';
  if (seconds > 0) result += '${seconds}S';

  return result == 'PT' ? 'PT0S' : result;
}
