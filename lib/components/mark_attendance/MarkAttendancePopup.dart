import 'package:flutter/material.dart';

void markAttendancePopup(BuildContext context, Function markAttendance) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        title: const Text("Mark Attendance"),
        content: const Text("Click To Mark Attendance.."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Cancel",style: TextStyle(color: Colors.red),),
          ),
          OutlinedButton(
            onPressed: () {
              markAttendance();
              Navigator.of(context).pop();
            },
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.green),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: const Text(
              "Attend",
              style: TextStyle(fontSize: 12, color: Colors.green),
            ),
          ),

        ],
      );
    },
  );
}
