class EventQRCodeDetails {
  int eventId;
  String eventName;
  String? moduleName;
  String eventDate;
  String eventValidDate;
  String eventTime;
  String eventEndTime;
  String eventVenue;
  int eventAssignedUserId;

  EventQRCodeDetails({
    required this.eventId,
    required this.eventName,
    this.moduleName,
    required this.eventDate,
    required this.eventValidDate,
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
      eventValidDate: json['eventValidDate'],
      eventTime: json['eventTime'],
      eventEndTime: json['eventEndTime'],
      eventVenue: json['eventVenue'],
      eventAssignedUserId: json['eventAssignedUserId'],
    );
  }
}


class LectureQRCodeDetails {
  String moduleCode;

  LectureQRCodeDetails({
    required this.moduleCode
  });

  factory LectureQRCodeDetails.fromJson(Map<String, dynamic> json) {
    return LectureQRCodeDetails(
      moduleCode: json['moduleCode'],
    );
  }
}

