class EventQRCodeDetails {
  int eventId;
  String eventName;
  String eventDate;
  String eventTime;
  String eventEndTime;
  String eventVenue;

  EventQRCodeDetails({
    required this.eventId,
    required this.eventName,
    required this.eventDate,
    required this.eventTime,
    required this.eventEndTime,
    required this.eventVenue,
  });

  factory EventQRCodeDetails.fromJson(Map<String, dynamic> json) {
    return EventQRCodeDetails(
      eventId: json['id'],
      eventName: json['name'],
      eventDate: json['lectureDate'],
      eventTime: json['lectureStartTime'],
      eventEndTime: json['lectureEndTime'],
      eventVenue: json['locationName'],
    );
  }
}

class LectureQRCodeDetails {
  String moduleCode;
  int moduleId;

  LectureQRCodeDetails({required this.moduleCode, required this.moduleId});

  factory LectureQRCodeDetails.fromJson(Map<String, dynamic> json) {
    return LectureQRCodeDetails(
        moduleCode: json['moduleCode'], moduleId: json['moduleId']);
  }
}
