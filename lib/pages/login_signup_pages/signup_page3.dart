import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:skyticker/api/service/RegistrationHelper.dart';
import 'package:skyticker/components/buttons/round_button.dart';
import 'package:skyticker/validations/SignUpInputValidations.dart';
import 'package:skyticker/validations/ValidationError.dart';
import 'package:skyticker/widgets/snackbar/custom_snackbar.dart';

import '../../components/buttons/button_dark_large.dart';
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
    super.key,
    required this.studentName,
    required this.indexNumber,
    required this.email,
    required this.studentRole,
    required this.departmentId,
    required this.currentSemester,
    required this.studentBatch,
  });

  @override
  State<SignUp3> createState() => _SignUp3State();
}

class _SignUp3State extends State<SignUp3> {
  final TextEditingController _userNameTextController = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  bool userNameHasError = false;
  bool passwordHasError = false;
  bool confirmPasswordHasError = false;
  String userNameError = "";
  String passwordError = "";
  String confirmPasswordError = "";

  @override
  void initState() {
    super.initState();
    _userNameTextController.addListener(_validateUserNameListener);
    _password.addListener(_validatePasswordListener);
    _confirmPassword.addListener(_validateConfirmPasswordListener);
  }

  Future<String?> getDeviceId() async {
    try {
      var deviceInfo = DeviceInfoPlugin();

      if (kIsWeb) {
        print("Running on Web - Device ID not available");
        return "Web_Device"; // Placeholder value for web
      } else if (Platform.isAndroid) {
        var androidInfo = await deviceInfo.androidInfo;
        print("Android ID: " + androidInfo.id);
        return androidInfo.id; // Unique Android ID
      } else if (Platform.isIOS) {
        var iosInfo = await deviceInfo.iosInfo;
        return iosInfo.identifierForVendor; // Unique iOS ID
      }

      return null;
    } on Exception catch (e) {
      print("Error getting device ID: $e");
      return null;
    }
  }

  void _validateUserNameListener() {
    ValidationError userNameValidationError =
        SignUpInputValidations.validateUsername(_userNameTextController.text);

    setState(() {
      userNameHasError = userNameValidationError.hasError;
      userNameError = userNameValidationError.message;
    });
  }

  void _validatePasswordListener() {
    ValidationError passwordValidationError =
        SignUpInputValidations.validatePassword(_password.text);

    setState(() {
      passwordHasError = passwordValidationError.hasError;
      passwordError = passwordValidationError.message;
    });
  }

  void _validateConfirmPasswordListener() {
    ValidationError confirmPasswordValidationError =
        SignUpInputValidations.validateConfirmPassword(
          _password.text,
          _confirmPassword.text,
        );

    setState(() {
      confirmPasswordHasError = confirmPasswordValidationError.hasError;
      confirmPasswordError = confirmPasswordValidationError.message;
    });
  }

  void previousPage() {
    Navigator.pop(context);
  }

  void nextPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const MainPage();
        },
      ),
    );
  }

  bool _isSignUpLoading = false;

  Future<void> handleSignUp() async {
    try {
      setState(() {
        _isSignUpLoading = true;
      });

      ValidationError userNameValidationError =
          SignUpInputValidations.validateUsername(_userNameTextController.text);
      ValidationError passwordValidationError =
          SignUpInputValidations.validatePassword(_password.text);
      ValidationError confirmPasswordValidationError =
          SignUpInputValidations.validateConfirmPassword(
            _password.text,
            _confirmPassword.text,
          );
      ValidationError emailValidationError =
          SignUpInputValidations.validateEmail(widget.email);
      if (userNameValidationError.hasError) {
        CustomSnackBar.showWarning(context, userNameValidationError.message);
        return;
      }
      if (passwordValidationError.hasError) {
        CustomSnackBar.showWarning(context, passwordValidationError.message);
        return;
      }
      if (confirmPasswordValidationError.hasError) {
        CustomSnackBar.showWarning(
          context,
          confirmPasswordValidationError.message,
        );
        return;
      }
      if (emailValidationError.hasError) {
        CustomSnackBar.showWarning(context, emailValidationError.message);
        return;
      }

      String? deviceId = await getDeviceId();

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
        deviceId,
      );
    } finally {
      setState(() {
        _isSignUpLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
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
                            child: TextBlue(text: "User Name", fontSize: 15),
                          ),
                          MyTextField(
                            controller: _userNameTextController,
                            hintText: "user name",
                            width: double.infinity,
                            obscureText: false,
                            icon: const Icon(Icons.person),
                            hasError: userNameHasError,
                            errorText: userNameError,
                          ),
                          const SizedBox(height: 10),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: TextBlue(text: "Password", fontSize: 15),
                          ),
                          MyTextField(
                            controller: _password,
                            hintText: "password",
                            width: double.infinity,
                            obscureText: true,
                            icon: const Icon(Icons.lock),
                            hasError: passwordHasError,
                            errorText: passwordError,
                          ),
                          const SizedBox(height: 10),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: TextBlue(
                              text: "Confirm Password",
                              fontSize: 15,
                            ),
                          ),
                          MyTextField(
                            controller: _confirmPassword,
                            hintText: "confirm password",
                            width: double.infinity,
                            obscureText: true,
                            icon: const Icon(Icons.lock),
                            hasError: confirmPasswordHasError,
                            errorText: confirmPasswordError,
                          ),
                          const SizedBox(height: 10),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
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
          Positioned(
            top: 20,
            left: 20,
            child: RoundButton(onTap: previousPage, icon: Icons.arrow_back),
          ),
        ],
      ),
    );
  }
}
