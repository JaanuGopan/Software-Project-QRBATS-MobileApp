class EventAttendanceHistory {
  final String eventName;
  final String eventModuleName;
  final String eventModuleCode;
  final String attendedTime;
  final String attendedDate;
  final bool attendanceStatus;

  EventAttendanceHistory({
    required this.eventName,
    required this.eventModuleName,
    required this.eventModuleCode,
    required this.attendedDate,
    required this.attendedTime,
    required this.attendanceStatus,
  });

  factory EventAttendanceHistory.fromJson(Map<String, dynamic> json) {
    return EventAttendanceHistory(
      eventName: json['eventName'],
      eventModuleCode: json['eventModuleCode'],
      eventModuleName: json['eventModuleName'],
      attendedDate: (json['attendedDate']),
      attendedTime: (json['attendedTime']),
      attendanceStatus: json['attendanceStatus'],
    );
  }

}
