import 'package:flutter/material.dart';

void showEnrollmentDialog(BuildContext context, Function(String) onEnroll) {
  TextEditingController enrollmentKeyController = TextEditingController();
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        title: Text("Enter Enrollment Key"),
        content: TextField(
          controller: enrollmentKeyController,
          decoration: InputDecoration(
            hintText: "Enrollment Key",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              onEnroll(enrollmentKeyController.text);
              Navigator.of(context).pop();
            },
            child: Text("Submit"),
          ),
        ],
      );
    },
  );
}
