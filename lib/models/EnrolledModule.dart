class Module {
  final int id;
  final String moduleCode;
  final String moduleName;
  final String moduleEnrolmentKey;
  final int semester;
  final int studentBatch;
  final int departmentId;
  final int createdBy;
  final DateTime statingDate;
  final DateTime endingDate;

  Module({
    required this.id,
    required this.moduleCode,
    required this.moduleName,
    required this.moduleEnrolmentKey,
    required this.semester,
    required this.studentBatch,
    required this.departmentId,
    required this.createdBy,
    required this.statingDate,
    required this.endingDate,
  });

  factory Module.fromJson(Map<String, dynamic> json) {
    return Module(
      id: json['id'],
      moduleCode: json['moduleCode'],
      moduleName: json['moduleName'],
      moduleEnrolmentKey: json['moduleEnrolmentKey'],
      semester: json['semester'],
      studentBatch: json['studentBatch'],
      departmentId: json['departmentId'],
      createdBy: json['createdBy'],
      statingDate: DateTime.parse(json['statingDate']),
      endingDate: DateTime.parse(json['endingDate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'moduleCode': moduleCode,
      'moduleName': moduleName,
      'moduleEnrolmentKey': moduleEnrolmentKey,
      'semester': semester,
      'studentBatch': studentBatch,
      'departmentId': departmentId,
      'createdBy': createdBy,
      'statingDate': statingDate.toIso8601String(),
      'endingDate': endingDate.toIso8601String(),
    };
  }
}
