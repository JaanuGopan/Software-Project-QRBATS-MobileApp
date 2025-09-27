import 'package:flutter/material.dart';
import 'package:skyticker/validations/ValidationError.dart';

import '../widgets/snackbar/custom_snackbar.dart';

class SignUpInputValidations {
  static bool validateInputs(
    String studentName,
    String indexNo,
    String email,
    bool isDepartmentEnabled,
    String? department,
    String? semester,
    String? studentBatch,
    BuildContext context,
  ) {
    if (studentName.isEmpty) {
      CustomSnackBar.showWarning(context, 'Please enter student name.');
      return false;
    }
    if (studentName.length < 3) {
      CustomSnackBar.showWarning(
        context,
        'Student name should be at least 3 characters long.',
      );
      return false;
    }

    RegExp indexNoRegex = RegExp(r'^EG/20\d{2}/\d{4}$');
    if (!indexNoRegex.hasMatch(indexNo)) {
      CustomSnackBar.showWarning(
        context,
        'Please enter a valid index number (e.g., EG/20XX/XXXX).',
      );
      return false;
    }

    if (isDepartmentEnabled) {
      if (department == null) {
        CustomSnackBar.showWarning(context, "Please Select Your Department.");
        return false;
      }

      if (semester == "1" || semester == "2") {
        CustomSnackBar.showWarning(
          context,
          "Semester 1 and 2 are not for departmental students.",
        );
        return false;
      }
    } else {
      if (!(semester == "1" || semester == "2")) {
        CustomSnackBar.showWarning(
          context,
          "Selected semester requires a department.",
        );
        return false;
      }
    }

    if (semester == null) {
      CustomSnackBar.showWarning(context, "Please Select Your Semester.");
      return false;
    }

    if (studentBatch == null) {
      CustomSnackBar.showWarning(context, "Please Select Your Batch.");
      return false;
    }

    RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      CustomSnackBar.showWarning(
        context,
        'Please enter a valid email address.',
      );
      return false;
    }

    return true;
  }

  static ValidationError validateUsername(String username) {
    if (username == "") {
      return ValidationError(true, "Username cannot be empty.");
    } else if (username.length < 6) {
      return ValidationError(
        true,
        "Username should be at least 6 characters long.",
      );
    } else {
      return ValidationError(false, "");
    }
  }

  static ValidationError validatePassword(String password) {
    if (password.isEmpty) {
      return ValidationError(true, "Password cannot be empty.");
    }

    if (password.length < 8) {
      return ValidationError(
        true,
        "Password must be at least 8 characters long.",
      );
    }

    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      return ValidationError(
        true,
        "Password must contain at least one uppercase letter.",
      );
    }

    if (!RegExp(r'[a-z]').hasMatch(password)) {
      return ValidationError(
        true,
        "Password must contain at least one lowercase letter.",
      );
    }

    if (!RegExp(r'\d').hasMatch(password)) {
      return ValidationError(true, "Password must contain at least one digit.");
    } else {
      return ValidationError(false, "");
    }
  }

  static ValidationError validateIndexNumber(String indexNo) {
    if (indexNo.isEmpty) {
      return ValidationError(true, 'Please enter your index number');
    }

    RegExp indexNoRegex = RegExp(r'^EG/20\d{2}/\d{4}$');
    if (!indexNoRegex.hasMatch(indexNo)) {
      return ValidationError(
        true,
        'Please enter a valid index number (e.g., EG/20XX/XXXX).',
      );
    } else {
      return ValidationError(false, '');
    }
  }

  static ValidationError validateEmail(String email) {
    if (email.isEmpty) {
      return ValidationError(true, 'Please enter your email');
    }

    RegExp emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(email)) {
      return ValidationError(true, 'Please enter a valid email');
    } else {
      return ValidationError(false, '');
    }
  }

  static ValidationError validateConfirmPassword(
    String password,
    String confirmPassword,
  ) {
    if (confirmPassword != password) {
      return ValidationError(true, "Passwords do not match.");
    } else {
      return ValidationError(false, "");
    }
  }

  static ValidationError validateStudentName(String studentName) {
    if (studentName.isEmpty) {
      return ValidationError(true, 'Please enter your student name');
    } else {
      return ValidationError(false, '');
    }
  }
}
