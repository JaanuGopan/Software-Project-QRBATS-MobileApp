import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:skyticker/api/service/LectureAttendanceService.dart';
import 'package:skyticker/api/service/LectureService.dart';
import 'package:skyticker/components/mark_attendance/MarkAttendancePopup.dart';
import 'package:skyticker/models/EnrolledModule.dart';
import 'package:skyticker/models/Lecture.dart';
import 'package:skyticker/widgets/snackbar/custom_snackbar.dart';

class ModuleEnrolledContent extends StatefulWidget {
  final Module module;
  final int number;

  const ModuleEnrolledContent({
    super.key,
    required this.module,
    required this.number,
  });

  @override
  State<ModuleEnrolledContent> createState() => _ModuleEnrolledContentState();
}

class _ModuleEnrolledContentState extends State<ModuleEnrolledContent> {
  bool showLecturesList = false;
  List<Lecture> lectures = [];
  bool isLecturesLoading = true;
  String errorMessage = "";
  bool isProcessing = false; // Add this state variable
  int processingLectureId = -1;

  Future<void> _fetchLecturesByModuleCode(
    BuildContext context,
    int moduleId,
  ) async {
    setState(() {
      isLecturesLoading = true;
      errorMessage = "";
    });

    try {
      final List<Lecture> lecturesList =
          await LectureService.getAllLectureByModuleCode(context, moduleId);
      setState(() {
        lectures = lecturesList;
        isLecturesLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load lectures';
        isLecturesLoading = false;
      });
    }
  }

  void handleShowLecture() async {
    if (!showLecturesList && lectures.isEmpty) {
      await _fetchLecturesByModuleCode(context, widget.module.id);
    }
    if (lectures.isNotEmpty) {
      setState(() {
        showLecturesList = !showLecturesList;
      });
    } else {
      CustomSnackBar.showError(
        context,
        "There Are No Any Lectures For This Module ${widget.module.moduleCode}",
      );
    }
  }

  double latitude = 0.0;
  double longitude = 0.0;

  Future<void> getLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        CustomSnackBar.showError(context, 'Location services are disabled.');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          CustomSnackBar.showError(context, 'Location permission denied.');
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        CustomSnackBar.showError(
          context,
          'Location permission permanently denied.',
        );
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(
          seconds: 10,
        ), // Add a timeout to avoid waiting indefinitely
      );

      setState(() {
        latitude = position.latitude;
        longitude = position.longitude;
      });

      print('Latitude: ${position.latitude}');
      print('Longitude: ${position.longitude}');
    } catch (e) {
      CustomSnackBar.showError(context, 'Failed to get location: $e');
    }
  }

  Future<void> checkLocationPermission() async {
    await getLocation();
  }

  void _handleMarkAttendance(int lectureId) async {
    setState(() {
      isProcessing = true; // Set isProcessing to true when starting
      processingLectureId = lectureId;
    });
    try {
      await checkLocationPermission();
      await markLectureAttendance(lectureId, latitude, longitude, context);
    } finally {
      setState(() {
        isProcessing = false; // Set isProcessing to false when done
        processingLectureId = -1;
      });
    }
  }

  Future<void> markLectureAttendance(
    int lectureId,
    double latitude,
    double longitude,
    BuildContext context,
  ) async {
    bool isCloseDetails =
        await LectureAttendanceService.markLectureAttendanceByLectureId(
          lectureId,
          latitude,
          longitude,
          context,
        );
    if (isCloseDetails) {
      setState(() {
        // Refresh the state if necessary
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: handleShowLecture,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                const SizedBox(width: 10),
                Text(
                  widget.number.toString(),
                  style: TextStyle(fontSize: _getFontSize(screenWidth)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.module.moduleCode,
                        style: TextStyle(
                          fontSize: _getFontSize(screenWidth),
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        widget.module.moduleName,
                        style: TextStyle(
                          fontSize: _getFontSize(screenWidth, isSubtext: true),
                          color: Colors.grey,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: handleShowLecture,
                  icon: Icon(
                    showLecturesList
                        ? CupertinoIcons.chevron_down_circle
                        : CupertinoIcons.chevron_left_circle,
                    color: showLecturesList ? Colors.red : Colors.green,
                  ),
                ),
              ],
            ),
            if (showLecturesList)
              GestureDetector(onTap: () {}, child: _buildLectureList()),
          ],
        ),
      ),
    );
  }

  Widget _buildLectureList() {
    return isLecturesLoading
        ? const Center(
            child: CircularProgressIndicator(color: Color(0xFF086494)),
          )
        : errorMessage.isNotEmpty
        ? Center(child: Text(errorMessage))
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: lectures
                .map((lecture) => _buildLectureRow(context, lecture))
                .toList(),
          );
  }

  Widget _buildLectureRow(BuildContext context, Lecture lecture) {
    final timeFormat = DateFormat('HH:mm a');
    double screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            const SizedBox(width: 5),
            Column(
              children: [
                Text(
                  "${lectures.indexOf(lecture) + 1}.",
                  style: TextStyle(
                    fontSize: _getFontSize(screenWidth, isSubtext: true),
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 15),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lecture.name,
                    style: TextStyle(
                      fontSize: _getFontSize(screenWidth),
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Date: ${DateFormat('yyyy-MM-dd').format(lecture.lectureDate)}",
                    style: TextStyle(
                      fontSize: _getFontSize(screenWidth, isSubtext: true),
                      color: Colors.black,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Start Time: ${timeFormat.format(lecture.lectureStartTime)}",
                    style: TextStyle(
                      fontSize: _getFontSize(screenWidth, isSubtext: true),
                      color: Colors.black,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "End Time: ${timeFormat.format(lecture.lectureEndTime)}",
                    style: TextStyle(
                      fontSize: _getFontSize(screenWidth, isSubtext: true),
                      color: Colors.black,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Venue: ${lecture.locationName}",
                    style: TextStyle(
                      fontSize: _getFontSize(screenWidth, isSubtext: true),
                      color: Colors.black,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const Spacer(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                isProcessing && processingLectureId == lecture.id
                    ? const CircularProgressIndicator(
                        color: Color(0xFF086494),
                      ) // Show progress indicator when processing
                    : ElevatedButton(
                        onPressed: () => markAttendancePopup(
                          context,
                          () => _handleMarkAttendance(lecture.id),
                          lecture,
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: Text(
                          "Attend",
                          style: TextStyle(
                            fontSize: _getFontSize(screenWidth),
                            color: Colors.white,
                          ),
                        ),
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  double _getFontSize(double screenWidth, {bool isSubtext = false}) {
    if (screenWidth < 360) {
      return isSubtext ? 8 : 10;
    } else if (screenWidth < 720) {
      return isSubtext ? 10 : 12;
    } else {
      return isSubtext ? 12 : 14;
    }
  }
}
