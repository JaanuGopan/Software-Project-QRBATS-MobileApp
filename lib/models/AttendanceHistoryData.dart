class AttendanceData {
  final String lectureName;
  final String lectureModuleCode;
  final String lectureModuleName;
  final String attendedTime;
  final String attendedDate;
  final bool attendanceStatus;

  AttendanceData({
    required this.lectureName,
    required this.lectureModuleCode,
    required this.lectureModuleName,
    required this.attendedDate,
    required this.attendedTime,
    required this.attendanceStatus,
  });

  factory AttendanceData.fromJson(Map<String, dynamic> json) {
    return AttendanceData(
      lectureName: json['lectureName'],
      lectureModuleCode: json['lectureModuleCode'],
      lectureModuleName: json['lectureModuleName'],
      attendedDate: (json['attendedDate']),
      attendedTime: (json['attendedTime']),
      attendanceStatus: json['attendanceStatus'],
    );
  }

}
