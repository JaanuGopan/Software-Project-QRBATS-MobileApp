class Lecture {
  final int lectureId;
  final String lectureName;
  final String lectureDay;
  final String lectureVenue;
  final DateTime lectureStartTime;
  final DateTime lectureEndTime;
  final int lectureAssignedUserId;
  final String lectureModuleCode;

  Lecture(
      {required this.lectureId,
      required this.lectureName,
      required this.lectureDay,
      required this.lectureVenue,
      required this.lectureStartTime,
      required this.lectureEndTime,
      required this.lectureAssignedUserId,
      required this.lectureModuleCode});

  factory Lecture.fromJson(Map<String, dynamic> json) {
    return Lecture(
        lectureId: json['lectureId'],
        lectureName: json['lectureName'],
        lectureDay: json['lectureDay'],
        lectureVenue: json['lectureVenue'],
        lectureStartTime: json['lectureStartTime'],
        lectureEndTime: json['lectureEndTime'],
        lectureAssignedUserId: json['lectureAssignedUserId'],
        lectureModuleCode: json['lectureModuleCode']);
  }
}
