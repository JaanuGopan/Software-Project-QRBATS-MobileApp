import 'package:flutter/material.dart';

import '../widgets/snackbar/custom_snackbar.dart';

class SignUpInputValidations {
  static bool validateInputs(
      String studentName,
      String indexNo,
      String email,
      String? department,
      String? semester,
      String? studentBatch,
      BuildContext context) {
    if (studentName.isEmpty) {
      CustomSnackBar.showWarning(context, 'Please enter student name.');
      return false;
    }

    RegExp indexNoRegex = RegExp(r'^EG/20\d{2}/\d{4}$');
    if (!indexNoRegex.hasMatch(indexNo)) {
      CustomSnackBar.showWarning(
          context, 'Please enter a valid index number (e.g., EG/20XX/XXXX).');
      return false;
    }

    if (department == null) {
      CustomSnackBar.showWarning(context, "Please Select Your Department.");
      return false;
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
