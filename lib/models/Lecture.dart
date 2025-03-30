class Lecture {
  final int id;
  final String name;
  final DateTime lectureDate;
  final String locationName;
  final DateTime lectureStartTime;
  final DateTime lectureEndTime;
  final String? moduleCode;
  final int? createdBy;

  Lecture({
    required this.id,
    required this.name,
    required this.lectureDate,
    required this.locationName,
    required this.lectureStartTime,
    required this.lectureEndTime,
    this.moduleCode,
    this.createdBy,
  });

  factory Lecture.fromJson(Map<String, dynamic> json) {
    return Lecture(
      id: json['id'],
      name: json['name'],
      lectureDate: DateTime.parse(json['lectureDate']), // Parsing Date
      locationName: json['locationName'],
      lectureStartTime: _parseTime(json['lectureStartTime']),
      lectureEndTime: _parseTime(json['lectureEndTime']),
      moduleCode: json['moduleCode'], // Nullable field
      createdBy: json['createdBy'], // Nullable field
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
