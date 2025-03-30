import 'package:flutter/material.dart';

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
      BuildContext context) {
    if (studentName.isEmpty) {
      CustomSnackBar.showWarning(context, 'Please enter student name.');
      return false;
    }
    if (studentName.length < 3) {
      CustomSnackBar.showWarning(
          context, 'Student name should be at least 3 characters long.');
      return false;
    }

    RegExp indexNoRegex = RegExp(r'^EG/20\d{2}/\d{4}$');
    if (!indexNoRegex.hasMatch(indexNo)) {
      CustomSnackBar.showWarning(
          context, 'Please enter a valid index number (e.g., EG/20XX/XXXX).');
      return false;
    }

    if (isDepartmentEnabled) {
      if (department == null) {
        CustomSnackBar.showWarning(context, "Please Select Your Department.");
        return false;
      }

      if (semester == "1" || semester == "2") {
        CustomSnackBar.showWarning(
            context, "Semester 1 and 2 are not for departmental students.");
        return false;
      }
    } else {
      if (!(semester == "1" || semester == "2")) {
        CustomSnackBar.showWarning(
            context, "Selected semester requires a department.");
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
          context, 'Please enter a valid email address.');
      return false;
    }

    return true;
  }
}
