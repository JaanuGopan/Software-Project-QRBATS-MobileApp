class EventQRCodeDetails {
  int eventId;
  String eventName;
  String? moduleName;
  String eventDate;
  String eventTime;
  String eventEndTime;
  String eventVenue;
  int eventAssignedUserId;

  EventQRCodeDetails({
    required this.eventId,
    required this.eventName,
    this.moduleName,
    required this.eventDate,
    required this.eventTime,
    required this.eventEndTime,
    required this.eventVenue,
    required this.eventAssignedUserId,
  });

  factory EventQRCodeDetails.fromJson(Map<String, dynamic> json) {
    return EventQRCodeDetails(
      eventId: json['eventId'],
      eventName: json['eventName'],
      moduleName: json['moduleName'],
      eventDate: json['eventDate'],
      eventTime: json['eventTime'],
      eventEndTime: json['eventEndTime'],
      eventVenue: json['eventVenue'],
      eventAssignedUserId: json['eventAssignedUserId'],
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
