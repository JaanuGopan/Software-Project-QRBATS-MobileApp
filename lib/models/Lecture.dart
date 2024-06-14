class Lecture {
  final int lectureId;
  final String lectureName;
  final String lectureDay;
  final String lectureVenue;
  final DateTime lectureStartTime;
  final DateTime lectureEndTime;
  final int lectureAssignedUserId;
  final String lectureModuleCode;

  Lecture({
    required this.lectureId,
    required this.lectureName,
    required this.lectureDay,
    required this.lectureVenue,
    required this.lectureStartTime,
    required this.lectureEndTime,
    required this.lectureAssignedUserId,
    required this.lectureModuleCode,
  });

  factory Lecture.fromJson(Map<String, dynamic> json) {
    return Lecture(
      lectureId: json['lectureId'],
      lectureName: json['lectureName'],
      lectureDay: json['lectureDay'],
      lectureVenue: json['lectureVenue'],
      lectureStartTime: _parseTime(json['lectureStartTime']),
      lectureEndTime: _parseTime(json['lectureEndTime']),
      lectureAssignedUserId: json['lectureAssignedUserId'],
      lectureModuleCode: json['lectureModuleCode'],
    );
  }

  static DateTime _parseTime(String time) {
    final now = DateTime.now();
    final timeParts = time.split(':');
    return DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(timeParts[0]),
      int.parse(timeParts[1]),
      int.parse(timeParts[2]),
    );
  }
}