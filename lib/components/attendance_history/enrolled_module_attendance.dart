import 'package:flutter/material.dart';
import 'package:qrbats_sp/models/EnrolledModule.dart';

class EnrolledModuleAttendance extends StatelessWidget {
  final Module enrolledModule;
  final int number;
  final double attendancePercentage;
  final Function(String moduleCode, int moduleId) onTap;

  const EnrolledModuleAttendance({
    super.key,
    required this.enrolledModule,
    required this.number,
    required this.attendancePercentage,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(enrolledModule.moduleCode, enrolledModule.moduleId),
      child: Container(
        padding: const EdgeInsets.all(12.0),
        margin: const EdgeInsets.symmetric(vertical: 6.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Text('$number',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    enrolledModule.moduleCode,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    enrolledModule.moduleName,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 40,
              height: 40,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CircularProgressIndicator(
                    value: attendancePercentage / 100,
                    strokeWidth: 5,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(
                        attendancePercentage > 80 ? Colors.green : Colors.red),
                  ),
                  Center(
                    child: Text(
                      '${attendancePercentage.toStringAsFixed(0)}%',
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
