import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qrbats_sp/models/AttendanceHistoryData.dart';

class AttendanceHistoryItem extends StatelessWidget {
  final AttendanceData attendanceData;
  final int number;

  const AttendanceHistoryItem({
    Key? key,
    required this.number,
    required this.attendanceData,
  }) : super(key: key);

  double _getFontSize(double screenWidth, {bool isSubtext = false}) {
    if (screenWidth < 360) {
      return isSubtext ? 8 : 10;
    } else if (screenWidth < 720) {
      return isSubtext ? 10 : 12;
    } else {
      return isSubtext ? 12 : 14;
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double titleFontSize = _getFontSize(screenWidth);
    double contentFontSize = _getFontSize(screenWidth, isSubtext: true);

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
          Text(number.toString(), style: TextStyle(fontSize: titleFontSize)),
          SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  attendanceData.lectureName,
                  style: TextStyle(fontSize: titleFontSize, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Text(
                  'Module: ${attendanceData.lectureModuleName}',
                  style: TextStyle(fontSize: contentFontSize, color: Colors.grey),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Date: ${attendanceData.attendedDate}',
                  style: TextStyle(fontSize: contentFontSize, color: Colors.grey),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Time: ${attendanceData.attendedTime}',
                  style: TextStyle(fontSize: contentFontSize, color: Colors.grey),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Status: ${attendanceData.attendanceStatus ? "Present" : "Absent"}',
                  style: TextStyle(
                    fontSize: contentFontSize,
                    color: attendanceData.attendanceStatus ? Colors.green : Colors.red,
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
