class EnrolledModule {
  final int moduleId;
  final String moduleName;
  final String moduleCode;
  final int departmentId;
  final int semester;

  EnrolledModule(
      {required this.moduleId,
      required this.moduleName,
      required this.moduleCode,
      required this.departmentId,
      required this.semester});

  factory EnrolledModule.fromJson(Map<String, dynamic> json) {
    return EnrolledModule(
        moduleId: json['moduleId'],
        moduleName: json['moduleName'],
        moduleCode: json['moduleCode'],
        departmentId: json['departmentId'],
        semester: json['semester']);
  }
}
