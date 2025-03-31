import 'package:flutter/material.dart';
import 'package:qrbats_sp/api_services/CheckStudentInfo.dart';
import 'package:qrbats_sp/components/buttons/round_button.dart';
import 'package:qrbats_sp/components/text_field/list_input_field.dart';
import 'package:qrbats_sp/config/Utils.dart';

import '../../components/text_field/text_field.dart';
import '../../components/texts/TextBlue.dart';
import '../../validations/SignUpInputValidations.dart';
import '../getStart_page.dart';
import 'login_page.dart';
import 'otp_verification_page.dart';

class Signup1 extends StatefulWidget {
  const Signup1({super.key});

  @override
  State<Signup1> createState() => _Signup1State();
}

final List<String> departmentList = Utils.getDepartmentList();
final List<String> semesterList = Utils.getSemesterList();
final List<String> studentBatchList = Utils.getStudentBatchListList();

class _Signup1State extends State<Signup1> {
  final _studentNameTextController = TextEditingController();
  final _indexNumberTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  bool isStudentNameHasError = false;
  bool isIndexNumberHasError = false;
  bool isEmailHasError = false;
  String studentNameError = '';
  String indexNumberError = '';
  String emailError = '';

  String? selectedDepartment;
  String? selectedCurrentSemester;
  String? selectedStudentRole;
  String? selectedStudentBatch;
  bool isDepartmentToggleEnabled = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _studentNameTextController.addListener(_studentNameValidationListener);
    _indexNumberTextController.addListener(_indexNumberValidationListener);
    _emailTextController.addListener(_emailValidationListener);
  }

  void _studentNameValidationListener() {
    if (_studentNameTextController.text.isEmpty) {
      setState(() {
        isStudentNameHasError = true;
        studentNameError = 'Please enter your name';
      });
      return;
    }

    setState(() {
      isStudentNameHasError = false;
      studentNameError = '';
    });
  }

  void _indexNumberValidationListener() {
    if (_indexNumberTextController.text.isEmpty) {
      setState(() {
        isIndexNumberHasError = true;
        indexNumberError = 'Please enter your index number';
      });
      return;
    }

    RegExp indexNoRegex = RegExp(r'^EG/20\d{2}/\d{4}$');
    if (!indexNoRegex.hasMatch(_indexNumberTextController.text)) {
      setState(() {
        isIndexNumberHasError = true;
        indexNumberError =
            'Please enter a valid index number (e.g., EG/20XX/XXXX).';
      });
      return;
    }

    setState(() {
      isIndexNumberHasError = false;
      indexNumberError = '';
    });
  }

  void _emailValidationListener() {
    if (_emailTextController.text.isEmpty) {
      setState(() {
        isEmailHasError = true;
        emailError = 'Please enter your email';
      });
      return;
    }

    RegExp emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(_emailTextController.text)) {
      setState(() {
        isEmailHasError = true;
        emailError = 'Please enter a valid email';
      });
      return;
    }

    setState(() {
      isEmailHasError = false;
      emailError = '';
    });
  }

  void otpVerificationPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return OtpVerificationPage(
          studentName: _studentNameTextController.text,
          email: _emailTextController.text,
          indexNumber: _indexNumberTextController.text,
          studentRole: "STUDENT",
          departmentId: isDepartmentToggleEnabled
              ? departmentList.indexOf(selectedDepartment!) + 1
              : -1,
          currentSemester: int.parse(selectedCurrentSemester!),
          studentBatch: int.parse(selectedStudentBatch!),
        );
      }),
    );
  }

  void previousPage() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return const OpeningPage();
    }));
  }

  void loginPage() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return const Login();
    }));
  }

  bool _isLoadingForOTPVerificationPage = false;

  Future<void> handleVerifySignupStep1() async {
    bool isValidInputs = SignUpInputValidations.validateInputs(
      _studentNameTextController.text,
      _indexNumberTextController.text,
      _emailTextController.text,
      isDepartmentToggleEnabled,
      selectedDepartment,
      selectedCurrentSemester,
      selectedStudentBatch,
      context,
    );

    if (isValidInputs) {
      try {
        setState(() {
          _isLoadingForOTPVerificationPage = true;
        });
        await CheckStudentInfo.checkStudentInfo(
          _emailTextController.text,
          _indexNumberTextController.text,
          otpVerificationPage,
          context,
        );
      } finally {
        setState(() {
          _isLoadingForOTPVerificationPage = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          /*  Positioned(
            top: 20,
            left: 20,
            child: RoundButton(onTap: previousPage, icon: Icons.arrow_back),
          ), */
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(right: 20.0, left: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    const Center(
                        child: TextBlue(text: "Create Account", fontSize: 30)),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          const Align(
                              alignment: Alignment.centerLeft,
                              child:
                                  TextBlue(text: "Student Name", fontSize: 15)),
                          MyTextField(
                            controller: _studentNameTextController,
                            hintText: "Perera A.B.C.D",
                            width: double.infinity,
                            obscureText: false,
                            icon: const Icon(Icons.drive_file_rename_outline),
                            hasError: isStudentNameHasError,
                            errorText: studentNameError,
                          ),
                          const SizedBox(height: 10),
                          const Align(
                              alignment: Alignment.centerLeft,
                              child:
                                  TextBlue(text: "Index Number", fontSize: 15)),
                          MyTextField(
                            controller: _indexNumberTextController,
                            hintText: "EG/20XX/XXXX",
                            width: double.infinity,
                            obscureText: false,
                            icon: const Icon(Icons.numbers),
                            hasError: isIndexNumberHasError,
                            errorText: indexNumberError,
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const TextBlue(
                                  text: "Select Department", fontSize: 15),
                              const SizedBox(width: 10),
                              Switch(
                                value: isDepartmentToggleEnabled,
                                focusColor: const Color(0xFF086494),
                                activeColor: const Color(0xFF086494),
                                inactiveThumbColor: Colors.white,
                                inactiveTrackColor: Colors.grey,
                                onChanged: (value) {
                                  setState(() {
                                    selectedDepartment = null;
                                    selectedCurrentSemester == null;
                                    isDepartmentToggleEnabled = value;
                                  });
                                },
                              ),
                            ],
                          ),
                          if (isDepartmentToggleEnabled) ...[
                            const Align(
                                alignment: Alignment.centerLeft,
                                child:
                                    TextBlue(text: "Department", fontSize: 15)),
                            _buildListInputField(
                              hintText: "Select Department",
                              width: double.infinity,
                              icon: Icons.list_sharp,
                              options: departmentList,
                              onChanged: (selectedValue) {
                                selectedDepartment = selectedValue;
                              },
                            ),
                          ],
                          const SizedBox(height: 10),
                          const Align(
                              alignment: Alignment.centerLeft,
                              child: TextBlue(text: "Semester", fontSize: 15)),
                          _buildListInputField(
                            hintText: "Select Semester",
                            width: double.infinity,
                            icon: Icons.list_sharp,
                            options: semesterList,
                            onChanged: (selectedValue) {
                              selectedCurrentSemester = selectedValue;
                            },
                          ),
                          const SizedBox(height: 10),
                          const Align(
                              alignment: Alignment.centerLeft,
                              child: TextBlue(
                                  text: "Student Batch", fontSize: 15)),
                          _buildListInputField(
                            hintText: "Select Batch",
                            width: double.infinity,
                            icon: Icons.list_sharp,
                            options: studentBatchList,
                            onChanged: (selectedValue) {
                              selectedStudentBatch = selectedValue;
                            },
                          ),
                          const SizedBox(height: 10),
                          const Align(
                              alignment: Alignment.centerLeft,
                              child: TextBlue(
                                  text: "Email Address", fontSize: 15)),
                          MyTextField(
                            controller: _emailTextController,
                            hintText: "email",
                            width: double.infinity,
                            obscureText: false,
                            icon: const Icon(Icons.email),
                            hasError: isEmailHasError,
                            errorText: emailError,
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Spacer(),
                              const Text("Already have an account? "),
                              TextButton(
                                onPressed: loginPage,
                                child: const Text(
                                  "LogIn",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Color(0xFF086494),
                                    decoration: TextDecoration.underline,
                                    decorationColor: Color(0xFF086494),
                                    decorationStyle: TextDecorationStyle.solid,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: _isLoadingForOTPVerificationPage
                                  ? const Center(
                                      child: CircularProgressIndicator(
                                        color: Color(0xFF086494),
                                      ),
                                    )
                                  : RoundButton(
                                      onTap: handleVerifySignupStep1,
                                      icon: Icons.arrow_forward,
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildListInputField({
  required String hintText,
  required double width,
  required IconData icon,
  required List<String> options,
  required Function(String?) onChanged,
}) {
  return ListInputFieldWidget(
    hintText: hintText,
    width: width,
    icon: Icon(icon),
    options: options,
    onChanged: onChanged,
  );
}
