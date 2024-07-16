class EventAttendanceHistory {
  final String eventName;
  final String attendedTime;
  final String attendedDate;
  final bool attendanceStatus;

  EventAttendanceHistory({
    required this.eventName,
    required this.attendedDate,
    required this.attendedTime,
    required this.attendanceStatus,
  });

  factory EventAttendanceHistory.fromJson(Map<String, dynamic> json) {
    return EventAttendanceHistory(
      eventName: json['eventName'],
      attendedDate: (json['attendedDate']),
      attendedTime: (json['attendedTime']),
      attendanceStatus: json['attendanceStatus'],
    );
  }

}
