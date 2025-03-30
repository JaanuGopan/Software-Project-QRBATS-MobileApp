import 'package:flutter/material.dart';
import 'package:qrbats_sp/api_services/RegistrationHelper.dart'; // Adjust import path as needed
import 'package:qrbats_sp/widgets/snackbar/custom_snackbar.dart';

import '../../components/buttons/button_dark_large.dart';
import '../../components/buttons/round_button.dart';
import '../../components/text_field/text_field.dart';
import '../../components/texts/TextBlue.dart';
import '../main_pages/main_page.dart';

class SignUp3 extends StatefulWidget {
  final String studentName;
  final String indexNumber;
  final String email;
  final String studentRole;
  final int? departmentId;
  final int currentSemester;
  final int studentBatch;

  const SignUp3({
    Key? key,
    required this.studentName,
    required this.indexNumber,
    required this.email,
    required this.studentRole,
    required this.departmentId,
    required this.currentSemester,
    required this.studentBatch,
  }) : super(key: key);

  @override
  State<SignUp3> createState() => _SignUp3State();
}

class _SignUp3State extends State<SignUp3> {
  final TextEditingController _userNameTextController = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();

  void previousPage() {
    Navigator.pop(context);
  }

  void nextPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return const MainPage();
      }),
    );
  }

  bool _isSignUpLoading = false;

  Future<void> handleSignUp() async {
    try {
      setState(() {
        _isSignUpLoading = true;
      });
      if (_userNameTextController.text == "") {
        CustomSnackBar.showWarning(context, "Please Enter UserName.");
        return;
      }
      if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(_userNameTextController.text)) {
        CustomSnackBar.showWarning(
            context, "User name should not include special characters.");
        return;
      }
      if (_userNameTextController.text.length < 6) {
        CustomSnackBar.showWarning(
            context, "User name should be at least 6 characters long.");
        return;
      }
      if (_password.text == "") {
        CustomSnackBar.showWarning(context, "Please Enter Password.");
        return;
      }
      if (_confirmPassword.text == "") {
        CustomSnackBar.showWarning(context, "Please Enter Confirm Password.");
        return;
      }
      if (_confirmPassword.text != _password.text) {
        CustomSnackBar.showWarning(
            context, "Password And Confirm Password Are Not Match.");
        return;
      }
      if (!isValidPassword(_password.text)) {
        CustomSnackBar.showWarning(context,
            "Password must contain at least 8 characters, one uppercase letter, one lowercase letter, and one number.");
        return;
      }

      await RegistrationHelper.register(
        context,
        _userNameTextController.text,
        _password.text,
        _confirmPassword.text,
        widget.studentName,
        widget.indexNumber,
        widget.email,
        widget.studentRole,
        widget.departmentId,
        widget.currentSemester,
        widget.studentBatch,
      );
    } finally {
      setState(() {
        _isSignUpLoading = false;
      });
    }
  }

  bool isValidPassword(String password) {
    // Password must contain at least 8 characters, one uppercase letter,
    // one lowercase letter, and one number
    final regex = RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)[A-Za-z\d]{8,}$');
    return regex.hasMatch(password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: 20,
            left: 20,
            child: RoundButton(onTap: previousPage, icon: Icons.arrow_back),
          ),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(right: 20.0, left: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    const Center(child: TextBlue(text: "SignUp", fontSize: 30)),
                    const SizedBox(height: 30),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          const Align(
                              alignment: Alignment.centerLeft,
                              child: TextBlue(text: "User Name", fontSize: 15)),
                          MyTextField(
                            controller: _userNameTextController,
                            hintText: "user name",
                            width: double.infinity,
                            obscureText: false,
                            icon: const Icon(Icons.person),
                          ),
                          const SizedBox(height: 10),
                          const Align(
                              alignment: Alignment.centerLeft,
                              child: TextBlue(text: "Password", fontSize: 15)),
                          MyTextField(
                            controller: _password,
                            hintText: "password",
                            width: double.infinity,
                            obscureText: true,
                            icon: const Icon(Icons.lock),
                          ),
                          const SizedBox(height: 10),
                          const Align(
                              alignment: Alignment.centerLeft,
                              child: TextBlue(
                                  text: "Confirm Password", fontSize: 15)),
                          MyTextField(
                            controller: _confirmPassword,
                            hintText: "confirm password",
                            width: double.infinity,
                            obscureText: true,
                            icon: const Icon(Icons.lock),
                          ),
                          const SizedBox(height: 10),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: _isSignUpLoading
                                  ? const Center(
                                      child: CircularProgressIndicator(
                                        color: Color(0xFF086494),
                                      ),
                                    )
                                  : MyButtonDS(
                                      onTap: handleSignUp,
                                      text: "SignUp",
                                      width: double.infinity,
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
