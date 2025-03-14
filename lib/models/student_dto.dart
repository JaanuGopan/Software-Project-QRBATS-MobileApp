class StudentDto {
  final int? userId;
  final String? userName;
  final String? firstName;
  final String? lastName;
  final String? email;
  final int? departmentId;
  final int? semester;
  final String? indexNumber;
  final String? role;

  StudentDto({
    this.userId,
    this.userName,
    this.firstName,
    this.lastName,
    this.email,
    this.departmentId,
    this.semester,
    this.indexNumber,
    this.role,
  });

  factory StudentDto.fromJson(Map<String, dynamic> json) {
    return StudentDto(
      userId: json['userId'],
      userName: json['userName'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      departmentId: json['departmentId'],
      semester: json['semester'],
      indexNumber: json['indexNumber'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'userName': userName,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'departmentId': departmentId,
      'semester': semester,
      'indexNumber': indexNumber,
      'role': role,
    };
  }
}
