import 'package:flutter/material.dart';
import 'package:qrbats_sp/api_services/StudentUpdateSettingService.dart';
import 'package:qrbats_sp/components/buttons/button_dark_large.dart';
import 'package:qrbats_sp/components/profile_update/profile_update_popup.dart';
import 'package:qrbats_sp/components/text_field/list_input_field.dart';
import 'package:qrbats_sp/components/text_field/text_field.dart';
import 'package:qrbats_sp/components/texts/TextBlue.dart';
import 'package:qrbats_sp/models/student_dto.dart';

class ProfileSettingPage extends StatefulWidget {
  const ProfileSettingPage({super.key});

  @override
  State<ProfileSettingPage> createState() => _ProfileSettingPageState();
}

class _ProfileSettingPageState extends State<ProfileSettingPage> {
  late TextEditingController emailController;
  late TextEditingController semesterController;
  late TextEditingController roleController;
  late TextEditingController nameController;
  late TextEditingController indexController;

  String? selectedDepartment;
  String? selectedSemester;
  String? selectedStudentBatch;
  bool _isLoading = true;

  String studentName = "";

  @override
  initState() {
    emailController = TextEditingController();
    semesterController = TextEditingController();
    roleController = TextEditingController();
    nameController = TextEditingController();
    indexController = TextEditingController();
    setState(() {
      _isLoading = true;
    });
    Future<StudentDto> studentDto =
        StudentUpdateSettingService.getStudent(context);
    studentDto
        .then((value) => {
              setState(() {
                emailController.text = value.email!;
                semesterController.text = value.semester.toString();
                roleController.text = value.role!;
                nameController.text = value.firstName!;
                indexController.text = value.indexNumber!;
                selectedDepartment = value.departmentId.toString();
                selectedSemester = value.semester.toString();
                studentName = value.firstName!;
                selectedStudentBatch = value.studentBatch.toString();
              }),
              setState(() {
                _isLoading = false;
              })
            })
        .catchError((onError) {
      setState(() {
        _isLoading = false;
      });
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(10.0),
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF086494),
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10),
                    const Text(
                      "Update Profile",
                      style: TextStyle(
                          color: Color(0xFF086494),
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: TextBlue(text: "Name", fontSize: 15)),
                    ),
                    _buildTextField("Name", nameController),
                    const SizedBox(height: 10),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: TextBlue(text: "Email", fontSize: 15)),
                    ),
                    _buildTextField("Email", emailController),
                    const SizedBox(height: 10),
                    if (selectedSemester != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child:
                                    TextBlue(text: "Semester", fontSize: 15)),
                          ),
                          _buildDropdownField(
                              "Semester", _semesterList, selectedSemester,
                              (newValue) {
                            setState(() {
                              selectedSemester = newValue;
                            });
                          }),
                          const SizedBox(height: 10),
                        ],
                      ),
                    if (selectedDepartment != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child:
                                    TextBlue(text: "Department", fontSize: 15)),
                          ),
                          _buildDropdownField(
                              "Department", _departmentList, selectedDepartment,
                              (newValue) {
                            setState(() {
                              selectedDepartment =
                                  (_departmentList.indexOf(newValue!) + 1)
                                      .toString();
                            });
                          }),
                          const SizedBox(height: 10),
                        ],
                      ),
                    if (selectedStudentBatch != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: TextBlue(
                                    text: "Student Batch", fontSize: 15)),
                          ),
                          _buildDropdownField(
                              "Student Batch",
                              _studentBatchList,
                              (_studentBatchList
                                          .indexOf(selectedStudentBatch!) +
                                      1)
                                  .toString(), (newValue) {
                            setState(() {
                              selectedStudentBatch = newValue;
                            });
                          }),
                          const SizedBox(height: 10),
                        ],
                      ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: TextBlue(text: "Index Number", fontSize: 15)),
                    ),
                    _buildTextField("Index Number", indexController),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: MyButtonDS(
                        onTap: () {
                          showUpdateProfile(context, () => _updateDetails());
                        },
                        text: "Update Profile",
                        width: double.infinity,
                      ),
                    )
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: MyTextField(
        controller: controller,
        hintText: label,
        width: double.infinity,
        obscureText: false,
        icon: const Icon(Icons.text_fields),
      ),
    );
  }

  Widget _buildDropdownField(
    String label,
    List<String> items,
    String? value,
    ValueChanged<String?> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ListInputFieldWidget(
        hintText: label,
        width: double.infinity,
        icon: const Icon(Icons.list),
        options: items,
        initialValue: value,
        onChanged: onChanged,
      ),
    );
  }

  final List<String> _departmentList = [
    'DEIE',
    'DCOM',
    'DMME',
    'DCEE',
    'DMENA',
  ];

  final List<String> _studentBatchList = [
    '20',
    '21',
    '22',
    '23',
    '24',
    '25',
    '26',
    '27',
  ];

  final List<String> _semesterList = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
  ];

  void _updateDetails() async {
    String updatedName = nameController.text;
    String updatedEmail = emailController.text;
    String updatedIndex = indexController.text;
    String updatedSemester = selectedSemester!;
    String updatedDepartment = selectedDepartment!;
    int updatedStudentBatch = int.parse(selectedStudentBatch!);

    await StudentUpdateSettingService.updateStudent(
        context,
        updatedName,
        updatedIndex,
        updatedEmail,
        int.parse(updatedDepartment),
        int.parse(updatedSemester),
        updatedStudentBatch);
  }
}
