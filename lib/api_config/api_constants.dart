class ApiConstants {
  static const String ipAddress = '192.168.1.11';
  static const String baseUrl = 'http://$ipAddress:8080';
  static const String mobileBaseUrl = 'http://$ipAddress:8080';
  static const String baseUrlEmulater = 'http://10.0.2.2:8080';
  static const String checkStudentEmailEndpoint = '/api/v1/mobile/checkstudentemail';
  static const String checkStudentIndexNoEndpoint = '/api/v1/mobile/checkstudentindexno';
  static const String checkStudentUserNameEndpoint = '/api/v1/mobile/checkstudentusername';
  static const String studentRegister = '/api/v1/mobile/signup';
  static const String updateStudentUrl = '/api/v1/mobile/updatestudent';
  static const String studentlogin = '/api/v1/mobile/signin';
  static const String studentGenerateOTP = '/api/v1/otp/generateotp';
  static const String studentVerifyOtp = '/api/v1/otp/otpverification';
  static const String markAttendanceEndpoint = '/api/v1/attendance/markattendance';
  static const String getAllAttendanceByStudentIdUrl = '/api/v1/lectureattendance/getallattendancehistorybystudentid';
  static const String getAttendanceDistance = '/api/v1/location/getdistance';
  static const String lectureAttendanceMarking = '/api/v1/lectureattendance/markattendance';
  static const String lectureAttendanceMarkingByLectureId = '/api/v1/lectureattendance/markattendancebylectureid';
  static const String getAllModuleByStudentId = '/api/v1/module/getallmodulesbystudentid';
  static const String getModuleByModuleCode = '/api/v1/module/getmodulebymodulecode';
  static const String getAllEnrolledModuleByStudentId = '/api/v1/module/getallenrolledmodules';
  static const String moduleEnrollmentUrl = '/api/v1/module/moduleenrollment';
  static const String moduleUnEnrollmentUrl = '/api/v1/module/moduleunenrollment';
  static const String getAllLecturesByModuleCode = '/api/v1/lecture/getalllecturebymodulecode';
  static const String getAllAttendanceHistoryByStudentIdUrl = '/api/v1/lectureattendance/getallattendancehistorybystudentid';
  static const String getEventByEventId = '/api/v1/event/geteventbyeventid';
  static const String getEventAttendanceHistoryUrl = '/api/v1/attendance/getallattendancebystudentid';
}
