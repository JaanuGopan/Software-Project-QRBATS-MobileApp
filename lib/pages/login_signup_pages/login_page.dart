import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skyticker/api/service/LoginService.dart';
import 'package:skyticker/pages/getStart_page.dart';
import 'package:skyticker/pages/login_signup_pages/forgot_password_page.dart';
import 'package:skyticker/pages/login_signup_pages/signup_page1.dart';
import 'package:skyticker/validations/SignUpInputValidations.dart';
import 'package:skyticker/validations/ValidationError.dart';
import 'package:skyticker/widgets/snackbar/custom_snackbar.dart';

import '../../components/buttons/button_dark_large.dart';
import '../../components/buttons/round_button.dart';
import '../../components/text_field/text_field.dart';
import '../../components/texts/TextBlue.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late SharedPreferences preferences;

  @override
  void initState() {
    super.initState();
    initSharedPreference();
    _userNameTextController.addListener(_validateUserNameListener);
    _password.addListener(_validatePasswordListener);
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

  Future<void> initSharedPreference() async {
    preferences = await SharedPreferences.getInstance();
  }

  final TextEditingController _userNameTextController = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool userNameHasError = false;
  bool passwordHasError = false;
  String userNameError = "";
  String passwordError = "";

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

  void previousPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const OpeningPage();
        },
      ),
    );
  }

  void forgotPasswordPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const ForgotPasswordPage();
        },
      ),
    );
  }

  void signUpPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const Signup1();
        },
      ),
    );
  }

  bool _isLoginLoading = false;

  Future<void> _handelLogin(
    BuildContext context,
    String userName,
    String password,
  ) async {
    ValidationError userNameValidationError =
        SignUpInputValidations.validateUsername(userName);
    ValidationError passwordValidationError =
        SignUpInputValidations.validatePassword(password);
    if (userNameValidationError.hasError) {
      CustomSnackBar.showWarning(context, userNameValidationError.message);
      return;
    }
    if (passwordValidationError.hasError) {
      CustomSnackBar.showWarning(context, passwordValidationError.message);
      return;
    }

    try {
      setState(() {
        _isLoginLoading = true;
      });
      String? deviceId = await getDeviceId();
      await LoginService.login(context, userName, password, deviceId);
    } finally {
      setState(() {
        _isLoginLoading = false;
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
                    const Center(child: TextBlue(text: "LogIn", fontSize: 30)),
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
                          const SizedBox(height: 20),
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
                          Row(
                            children: [
                              const Spacer(),
                              TextButton(
                                onPressed: forgotPasswordPage,
                                child: const Text(
                                  "Forgot Password?",
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
                                horizontal: 20,
                                vertical: 10,
                              ),
                              child: _isLoginLoading
                                  ? const Center(
                                      child: CircularProgressIndicator(
                                        color: Color(0xFF086494),
                                      ),
                                    )
                                  : MyButtonDS(
                                      onTap: () => _handelLogin(
                                        context,
                                        _userNameTextController.text,
                                        _password.text,
                                      ),
                                      text: "LogIn",
                                      width: double.infinity,
                                    ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Spacer(),
                              const Text(
                                "If you don't have an account? ",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                ),
                              ),
                              TextButton(
                                onPressed: signUpPage,
                                child: const Text(
                                  "Create Account",
                                  style: TextStyle(color: Color(0xFF086494)),
                                ),
                              ),
                              const Spacer(),
                            ],
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
