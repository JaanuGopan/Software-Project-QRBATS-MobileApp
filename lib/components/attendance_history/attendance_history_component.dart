import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qrbats_sp/models/AttendanceHistoryData.dart';

class AttendanceHistoryItem extends StatelessWidget {
  final AttendanceData attendanceData;
  final int number;

  const AttendanceHistoryItem({
    super.key,
    required this.number,
    required this.attendanceData,
  });

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.all(8.0),
      margin: EdgeInsets.symmetric(vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(width: 10),
          Text(number.toString(), style: TextStyle(fontSize: 16)),
          SizedBox(width: 40),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  attendanceData.lectureName,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Text(
                  'Module: ${attendanceData.lectureModuleName}',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                Text(
                  'Date: ${attendanceData.attendedDate}',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                Text(
                  'Time: ${attendanceData.attendedTime}',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                Text(
                  'Status: ${attendanceData.attendanceStatus ? "Present" : "Absent"}',
                  style: TextStyle(
                    fontSize: 14,
                    color: attendanceData.attendanceStatus
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
