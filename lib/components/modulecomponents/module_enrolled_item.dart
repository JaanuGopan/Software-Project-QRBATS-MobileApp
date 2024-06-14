import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qrbats_sp/api_services/LectureService.dart';
import 'package:qrbats_sp/models/EnrolledModule.dart';
import 'package:qrbats_sp/models/Lecture.dart';

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
  late List<Lecture> lectures = [];
  bool isLecturesLoading = true;
  String errorMessage = "";

  Future<void> _fetchLecturesByModuleCode(BuildContext context, String moduleCode) async {
    try {
      final List<Lecture> lecturesList = await LectureService.getAllLectureByModuleCode(context, moduleCode);
      setState(() {
        lectures = lecturesList;
        isLecturesLoading = false;
      });
      print(lecturesList);
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load lectures';
        isLecturesLoading = false;
      });
    }
  }

  void handleShowLecture() {
    _fetchLecturesByModuleCode(context, widget.module.moduleCode);
    setState(() {
      showLecturesList = !showLecturesList;
    });
    print(showLecturesList.toString());
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
              Text(widget.number.toString(), style: TextStyle(fontSize: 16)),
              SizedBox(width: 40),
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
      children: lectures
          .map((lecture) => Padding(
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
          padding: EdgeInsets.all(8.0),
          child: Row(
            children: [
              SizedBox(width: 25),
              Text(
                "${lectures.indexOf(lecture) + 1}.",
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
              SizedBox(width: 15),
              Text(
                lecture.lectureName,
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
              SizedBox(width: 15),
              Text(
                lecture.lectureDay,
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
              Spacer(),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.green),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text(
                  "Mark Attendance",
                  style: TextStyle(fontSize: 12, color: Colors.green),
                ),
              ),
              SizedBox(width: 10),
            ],
          ),
        ),
      ))
          .toList(),
    );
  }
}

