import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:skyticker/models/Lecture.dart';

void markAttendancePopup(
  BuildContext context,
  Function markAttendance,
  Lecture lecture,
) {
  final timeFormat = DateFormat('HH:mm a');
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: EdgeInsets.zero, // Remove default padding
        content: Container(
          decoration: _alertBoxDecoration, // Use the custom decoration
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const ListTile(
                title: Center(
                  child: Text(
                    "Mark Attendance",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lecture.name,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Date : ${DateFormat('yyyy-MM-dd').format(lecture.lectureDate)}",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Start Time : ${timeFormat.format(lecture.lectureStartTime)}",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "End Time : ${timeFormat.format(lecture.lectureEndTime)}",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Venue : ${lecture.locationName}",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ButtonBar(
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      "Cancel",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      markAttendance();
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text(
                      "Attend",
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

// Define the custom BoxDecoration
final BoxDecoration _alertBoxDecoration = BoxDecoration(
  color: Colors.white, // Background color
  borderRadius: BorderRadius.circular(15.0), // Corner radius
  boxShadow: [
    BoxShadow(
      color: Colors.black.withOpacity(0.5), // Shadow color
      spreadRadius: 1, // Spread radius
      blurRadius: 10, // Blur radius
      offset: const Offset(0, 3), // Shadow position
    ),
  ],
);
