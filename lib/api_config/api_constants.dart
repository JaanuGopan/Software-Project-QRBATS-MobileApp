class ApiConstants {
  static const String facultyHostedNgrokIp =
      'https://lionfish-wondrous-catfish.ngrok-free.app'; // This is hosted on faculty server backend IP
  static const String facultyLocalIp =
      'http://10.50.227.44:8080'; // For Android App this IP is not working so use ngrok IP
  static const String awsIpAddress = '13.51.170.30';
  static const String devIp = 'http://localhost:8080';
  static const String baseUrl = devIp;
  static const String mobileBaseUrl = devIp;
  static const String baseUrlEmulater = 'http://10.0.2.2:8082';
  static const String checkStudentEmailEndpoint =
      '/api/v1/auth/check-student-email';
  static const String checkStudentIndexNoEndpoint =
      '/api/v1/auth/check-student-index-number';
  static const String checkStudentUserNameEndpoint =
      '/api/v1/auth/check-student-username';
  static const String studentRegister = '/api/v1/auth/signup';
  static const String updateStudentUrl = '/api/v1/auth/update-user';
  static const String studentlogin = '/api/v1/auth/student-login';
  static const String studentGenerateOTP = '/api/v1/otp/generate-otp';
  static const String studentVerifyOtp = '/api/v1/otp/otp-verification';
  static const String markAttendanceEndpoint =
      '/api/v1/attendance/mark-attendance';
  static const String getAllAttendanceByStudentIdUrl =
      '/api/v1/lecture-attendance/get-all-attendance-history-by-studentId';
  static const String getAttendanceDistance = '/api/v1/location/get-distance';
  static const String lectureAttendanceMarking =
      '/api/v1/lecture-attendance/mark-attendance';
  static const String lectureAttendanceMarkingByLectureId =
      '/api/v1/attendance/mark-attendance-for-lecture';
  static const String getAllModuleByStudentId =
      '/api/v1/module/get-all-un-enrolled-module-for-student';
  static const String getModuleByModuleCode =
      '/api/v1/module/get-module-by-module-code';
  static const String getAllEnrolledModuleByStudentId =
      '/api/v1/module/get-all-enrolled-modules-for-student';
  static const String moduleEnrollmentUrl = '/api/v1/module/module-enrollment';
  static const String moduleUnEnrollmentUrl =
      '/api/v1/module/module-un-enrollment';
  static const String getAllLecturesByModuleCode =
      '/api/v1/lecture/get-all-lecture-by-moduleId-for-student';
  static const String getModuleAttendanceForStudent =
      '/api/v1/attendance/get-module-attendance-for-student';
  static const String getEventByEventId = '/api/v1/event/get-event-by-eventId';
  static const String getEventAttendanceHistoryUrl =
      '/api/v1/attendance/get-all-attendance-by-studentId';
  static const String sendOTPForForgotPassword =
      '/api/v1/auth/forgot-password-send-otp-for-student';
  static const String verifyOTPForForgotPassword =
      '/api/v1/auth/forgot-password-verify-otp-for-student';
  static const String resetPasswordUrl =
      '/api/v1/auth/forgot-password-reset-password-for-student';
  static const String getStudentUrl = '/api/v1/auth/user';
}
