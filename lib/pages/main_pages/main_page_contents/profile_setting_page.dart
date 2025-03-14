import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
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

  String? selectedDepartment; // Track selected department
  String? selectedSemester; // Track selected semester
  bool _isLoading = true;

  String studentName = "";

  @override
  initState() {
    emailController = TextEditingController();
    semesterController = TextEditingController();
    roleController = TextEditingController();
    nameController = TextEditingController();
    indexController = TextEditingController();

    try {
      setState(() {
        _isLoading = true;
      });
      Future<StudentDto> studentDto =
          StudentUpdateSettingService.getStudent(context);
      studentDto.then((value) => {
            setState(() {
              emailController.text = value.email!;
              semesterController.text = value.semester.toString();
              roleController.text = value.role!;
              nameController.text = value.firstName!;
              indexController.text = value.indexNumber!;
              selectedDepartment = value.departmentId.toString();
              selectedSemester = value.semester.toString();
              studentName = value.firstName!;
            })
          });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10.0),
        child: _isLoading
            ? const CircularProgressIndicator(
                color: Color(0xFF086494),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.account_circle,
                      color: Color(0xFF086494),
                      size: 80,
                    ),
                  ),
                  Text(
                    studentName,
                    style: const TextStyle(
                      color: Color(0xFF086494),
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 20),
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
                              child: TextBlue(text: "Semester", fontSize: 15)),
                        ),
                        _buildDropdownField(
                            "Semester", _getSemesterList(), selectedSemester,
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
                        _buildDropdownField("Department", _getDepartmentList(),
                            selectedDepartment, (newValue) {
                          setState(() {
                            selectedDepartment = newValue;
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
    List<Map<String, dynamic>> items,
    String? value,
    ValueChanged<String?> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ListInputFieldWidget(
        hintText: label,
        width: double.infinity,
        icon: const Icon(Icons.list),
        options: items.map((item) => item['name'].toString()).toList(),
        initialValue: value,
        onChanged: onChanged,
      ),
    );
  }

  List<Map<String, dynamic>> _getDepartmentList() {
    return [
      {"name": "DEIE", "id": "1"},
      {"name": "DCOM", "id": "2"},
      {"name": "DMME", "id": "3"},
      {"name": "DCEE", "id": "4"},
      {"name": "DMENA", "id": "5"},
    ];
  }

  List<Map<String, dynamic>> _getSemesterList() {
    return [
      {"name": "1", "id": "1"},
      {"name": "2", "id": "2"},
      {"name": "3", "id": "3"},
      {"name": "4", "id": "4"},
      {"name": "5", "id": "5"},
      {"name": "6", "id": "6"},
      {"name": "7", "id": "7"},
      {"name": "8", "id": "8"},
    ];
  }

  void _updateDetails() async {
    String updatedName = nameController.text;
    String updatedEmail = emailController.text;
    String updatedIndex = indexController.text;
    String updatedSemester = selectedSemester!;
    String updatedDepartment = selectedDepartment!;

    var logger = Logger();
    logger.i('Updating details...');
    logger.i(
        'Name: $updatedName, Email: $updatedEmail, Index: $updatedIndex, Semester: $updatedSemester, Department: $updatedDepartment');

    /* await StudentUpdateSettingService.updateStudent(
        context,
        "",
        "",
        "",
        "",
        int.parse(updatedDepartment),
        int.parse(updatedSemester)); */
    // Replace with actual update logic using API service
    print('Updating details...');
    print(
        'Name: $updatedName, Email: $updatedEmail, Index: $updatedIndex, Semester: $updatedSemester, Department: $updatedDepartment');
    // Call your update service here with the updated values
  }
}
