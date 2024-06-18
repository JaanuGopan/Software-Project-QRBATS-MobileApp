import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:qrbats_sp/api_services/LectureAttendanceService.dart';
import 'package:qrbats_sp/api_services/LectureService.dart';
import 'package:qrbats_sp/components/mark_attendance/MarkAttendancePopup.dart';
import 'package:qrbats_sp/models/EnrolledModule.dart';
import 'package:qrbats_sp/models/Lecture.dart';
import 'package:intl/intl.dart';
import 'package:qrbats_sp/widgets/snackbar/custom_snackbar.dart'; // Add this import for formatting time

class ScannedModule extends StatefulWidget {
  final Module module;
  final int studentId;
  const ScannedModule({
    super.key,
    required this.module, required this.studentId,
  });

  @override
  State<ScannedModule> createState() => _ScannedModuleState();
}

class _ScannedModuleState extends State<ScannedModule> {
  bool showLecturesList = false;
  List<Lecture> lectures = [];
  bool isLecturesLoading = true;
  String errorMessage = "";



  Future<void> _fetchLecturesByModuleCode(BuildContext context, String moduleCode) async {
    setState(() {
      isLecturesLoading = true;
      errorMessage = "";
    });

    try {
      final List<Lecture> lecturesList = await LectureService.getAllLectureByModuleCode(context, moduleCode);
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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    handleShowLecture();
  }

  void handleShowLecture() async {
    if (!showLecturesList && lectures.isEmpty) {
      await _fetchLecturesByModuleCode(context, widget.module.moduleCode);
    }
    if(lectures.isNotEmpty){
      setState(() {
        showLecturesList = !showLecturesList;
      });
    } else{
      CustomSnackBar.showError(context, "There Are No Any Lectures For This Module ${widget.module.moduleCode}");
    }
  }

  double latitude = 0.0;
  double longitude = 0.0;

  Future<void> getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      latitude = position.latitude;
      longitude = position.longitude;
    });
    print('Latitude: ${position.latitude}');
    print('Longitude: ${position.longitude}');
  }

  Future<void> checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Handle case when location permission is denied
        return;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Handle case when location permission is permanently denied
      return;
    }
    getLocation(); // Permission granted, get the location
  }

  /*Future<void> markLectureAttendance(int studentId, String moduleCode,
      double latitude, double longitude, BuildContext context) async {
    bool isCloseDetails = await LectureAttendanceService.markLectureAttendance(
        studentId, moduleCode, latitude, longitude, context);
    if (isCloseDetails) {
      setState(() {

      });
    }
  }*/

  void _handleMarkAttendance(int lectureId) async{
    await checkLocationPermission();
    await markLectureAttendance(widget.studentId, lectureId, latitude, longitude, context);
  }
  Future<void> markLectureAttendance(int studentId, int lectureId,
      double latitude, double longitude, BuildContext context) async {
    bool isCloseDetails = await LectureAttendanceService.markLectureAttendanceByLectureId(
        studentId, lectureId, latitude, longitude, context);
    if (isCloseDetails) {
      setState(() {

      });
    }
  }


  @override
  Widget build(BuildContext context) {
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
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.module.moduleCode,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      widget.module.moduleName,
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Spacer(),
              IconButton(
                onPressed: handleShowLecture,
                icon: Icon(
                  showLecturesList ? CupertinoIcons.multiply_square : Icons.menu_open,
                  color: showLecturesList ? Colors.red : Colors.green,
                ),
              ),
            ],
          ),
          if (showLecturesList) _buildLectureList(),
        ],
      ),
    );
  }

  Widget _buildLectureList() {
    return isLecturesLoading
        ? Center(child: CircularProgressIndicator())
        : errorMessage.isNotEmpty
        ? Center(child: Text(errorMessage))
        : Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: lectures.map((lecture) => _buildLectureRow(context,lecture)).toList(),
    );
  }

  Widget _buildLectureRow(BuildContext context,Lecture lecture) {
    final timeFormat = DateFormat('HH:mm a');

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
              offset: Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.only(left: 0,right: 0,top: 20,bottom: 20),
        child: Row(
          children: [
            const SizedBox(width: 25),
            Text(
              "${lectures.indexOf(lecture) + 1}.",
              style: TextStyle(fontSize: 12, color: Colors.black),
            ),
            const SizedBox(width: 20),
            Flexible(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lecture.lectureName,
                      style: const TextStyle(fontSize: 12, color: Colors.black,fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Day : ${lecture.lectureDay}",
                      style: TextStyle(fontSize: 12, color: Colors.black),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Time : ${timeFormat.format(lecture.lectureStartTime)}",
                      style: TextStyle(fontSize: 12, color: Colors.black),
                    ),

                  ],
                ),
              ),
            ),

            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () =>markAttendancePopup(context, () => _handleMarkAttendance(lecture.lectureId)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.green),
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
            ),
            SizedBox(width: 10),
          ],
        ),
      ),
    );
  }
}
