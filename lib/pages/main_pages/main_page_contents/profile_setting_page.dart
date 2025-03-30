import 'package:flutter/material.dart';
import 'package:qrbats_sp/api_services/StudentUpdateSettingService.dart';
import 'package:qrbats_sp/components/buttons/button_dark_large.dart';
import 'package:qrbats_sp/components/profile_update/profile_update_popup.dart';
import 'package:qrbats_sp/components/text_field/list_input_field.dart';
import 'package:qrbats_sp/components/text_field/text_field.dart';
import 'package:qrbats_sp/components/texts/TextBlue.dart';
import 'package:qrbats_sp/config/Utils.dart';
import 'package:qrbats_sp/models/student_dto.dart';
import 'package:qrbats_sp/widgets/snackbar/custom_snackbar.dart';

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
  String? selectedSemesterForFirstYear;
  String? selectedStudentBatch;
  bool _isLoading = true;
  bool isDepartmentToggleEnabled = false;

  @override
  void initState() {
    super.initState();

    emailController = TextEditingController();
    semesterController = TextEditingController();
    roleController = TextEditingController();
    nameController = TextEditingController();
    indexController = TextEditingController();

    _loadStudentData();
  }

  Future<void> _loadStudentData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      StudentDto student =
          await StudentUpdateSettingService.getStudent(context);

      setState(() {
        emailController.text = student.email ?? '';
        nameController.text = student.firstName ?? '';
        indexController.text = student.indexNumber ?? '';
        roleController.text = student.role ?? '';
        semesterController.text = student.semester?.toString() ?? '';

        selectedSemester = student.semester?.toString();
        selectedDepartment = student.departmentId != null
            ? departmentList[student.departmentId! - 1]
            : null;
        selectedStudentBatch = student.studentBatch?.toString();

        isDepartmentToggleEnabled = student.departmentId != null;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      debugPrint("Error fetching student data: $error");
    }
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
                    Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: TextBlue(
                                  text: "Select Department", fontSize: 15)),
                        ),
                        const SizedBox(width: 10),
                        Switch(
                          value: isDepartmentToggleEnabled,
                          focusColor: const Color(0xFF086494),
                          activeColor: const Color(0xFF086494),
                          inactiveThumbColor: Colors.white,
                          inactiveTrackColor: Colors.grey,
                          onChanged: (value) {
                            setState(() {
                              isDepartmentToggleEnabled = value;
                            });
                          },
                        ),
                      ],
                    ),
                    if (isDepartmentToggleEnabled) ...[
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
                              "Department", departmentList, selectedDepartment,
                              (newValue) {
                            setState(() {
                              selectedDepartment = newValue;
                            });
                          }),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ],
                    const SizedBox(height: 1),
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
                            "Select Semester",
                            semesterList,
                            selectedSemester,
                            (selectedValue) {
                              setState(() {
                                selectedSemester = selectedValue;
                              });
                            },
                          ),
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
                          _buildDropdownField("Student Batch", studentBatchList,
                              selectedStudentBatch, (newValue) {
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

  final List<String> departmentList = Utils.getDepartmentList();
  final List<String> studentBatchList = Utils.getStudentBatchListList();
  final List<String> semesterList = Utils.getSemesterList();

  void _updateDetails() async {
    String updatedName = nameController.text.trim();
    String updatedEmail = emailController.text.trim();
    String updatedIndex = indexController.text.trim();
    String? updatedSemester = selectedSemester;
    String? updatedDepartment = selectedDepartment;
    String? updatedStudentBatch = selectedStudentBatch;

    // Basic validations
    if (updatedName.isEmpty) {
      CustomSnackBar.showWarning(context, "Name cannot be empty.");
      return;
    }
    if (updatedEmail.isEmpty) {
      CustomSnackBar.showWarning(context, "Email cannot be empty.");
      return;
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(updatedEmail)) {
      CustomSnackBar.showWarning(
          context, "Please enter a valid email address.");
      return;
    }
    if (updatedIndex.isEmpty) {
      CustomSnackBar.showWarning(context, "Index number cannot be empty.");
      return;
    }
    if (updatedSemester == null) {
      CustomSnackBar.showWarning(context, "Please select a semester.");
      return;
    }
    if (updatedStudentBatch == null) {
      CustomSnackBar.showWarning(context, "Please select a student batch.");
      return;
    }

    // Department-specific validations
    if (isDepartmentToggleEnabled) {
      if (updatedDepartment == null || updatedDepartment.isEmpty) {
        CustomSnackBar.showWarning(context, "Please select a department.");
        return;
      }
      if (updatedSemester == "1" || updatedSemester == "2") {
        CustomSnackBar.showWarning(context,
            "Semester 1 and 2 are not available for departmental students.");
        return;
      }
    } else {
      if (!(updatedSemester == "1" || updatedSemester == "2")) {
        CustomSnackBar.showWarning(
            context, "Department is required for your selected semester.");
        return;
      }
    }

    // Additional validations
    RegExp indexNoRegex = RegExp(r'^EG/20\d{2}/\d{4}$');
    if (!indexNoRegex.hasMatch(updatedIndex)) {
      CustomSnackBar.showWarning(
          context, 'Please enter a valid index number (e.g., EG/20XX/XXXX).');
      return;
    }
    if (int.tryParse(updatedStudentBatch) == null) {
      CustomSnackBar.showWarning(context, "Invalid student batch selected.");
      return;
    }

    debugPrint(
        "Updating details: $updatedName, $updatedEmail, $updatedIndex, $updatedSemester, $updatedDepartment, $updatedStudentBatch");

    // Proceed with the update
    await StudentUpdateSettingService.updateStudent(
      context,
      updatedName,
      updatedIndex,
      updatedEmail,
      isDepartmentToggleEnabled
          ? departmentList.indexOf(updatedDepartment!) + 1
          : -1,
      int.parse(updatedSemester),
      int.parse(updatedStudentBatch),
    );
  }
}
