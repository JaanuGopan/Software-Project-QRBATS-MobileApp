class ApiConstants {
  static const String facultyHostedNgrokIp =
      'https://redfish-real-directly.ngrok-free.app';
  static const String facultyLocalIp = 'http://10.50.227.44:8080';
  static const String devIp1 = 'http://192.168.43.136:8080';
  static const String devIp2 = 'http://localhost:8080';
  static const String baseUrl = facultyHostedNgrokIp;
  static const String checkStudentEmailEndpoint =
      '/api/v1/auth/check-student-email';
  static const String checkStudentIndexNoEndpoint =
      '/api/v1/auth/check-student-index-number';
  static const String checkStudentUserNameEndpoint =
      '/api/v1/auth/check-student-username';
  static const String studentRegister = '/api/v1/auth/signup';
  static const String updateStudentUrl = '/api/v1/auth/update-student';
  static const String studentlogin = '/api/v1/auth/student-login';
  static const String studentGenerateOTP = '/api/v1/otp/generate-otp';
  static const String studentVerifyOtp = '/api/v1/otp/otp-verification';
  static const String markAttendanceEndpoint =
      '/api/v1/attendance/mark-attendance-for-event';
  static const String getAllAttendanceByStudentIdUrl =
      '/api/v1/lecture-attendance/get-all-attendance-history-by-studentId';
  static const String getAttendanceDistance = '/api/v1/location/get-distance';
  static const String lectureAttendanceMarkingByLectureId =
      '/api/v1/attendance/mark-attendance-for-lecture';
  static const String getAllModuleByStudentId =
      '/api/v1/module/get-all-un-enrolled-module-for-student';
  static const String getModuleByModuleCode =
      '/api/v1/module/get-module-by-moduleId-for-student';
  static const String getAllEnrolledModuleByStudentId =
      '/api/v1/module/get-all-enrolled-modules-for-student';
  static const String moduleEnrollmentUrl = '/api/v1/module/module-enrollment';
  static const String moduleUnEnrollmentUrl =
      '/api/v1/module/module-un-enrollment';
  static const String getAllLecturesByModuleCode =
      '/api/v1/lecture/get-all-lecture-by-moduleId-for-student';
  static const String getModuleAttendanceForStudent =
      '/api/v1/attendance/get-module-attendance-for-student';
  static const String getEventByEventId =
      '/api/v1/lecture/get-lecture-by-lectureId';
  static const String getEventAttendanceHistoryUrl =
      '/api/v1/attendance/get-all-event-attendance-for-student';
  static const String sendOTPForForgotPassword =
      '/api/v1/auth/forgot-password-send-otp-for-student';
  static const String verifyOTPForForgotPassword =
      '/api/v1/auth/forgot-password-verify-otp-for-student';
  static const String resetPasswordUrl =
      '/api/v1/auth/forgot-password-reset-password-for-student';
  static const String getStudentUrl = '/api/v1/auth/user';
}
