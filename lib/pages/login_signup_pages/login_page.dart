import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qrbats_sp/pages/getStart_page.dart';
import 'package:qrbats_sp/pages/login_signup_pages/forgot_password_page.dart';
import 'package:qrbats_sp/pages/login_signup_pages/signup_page1.dart';
import 'package:qrbats_sp/widgets/snackbar/custom_snackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api_services/LoginService.dart';
import '../../components/buttons/button_dark_large.dart';
import '../../components/buttons/round_button.dart';
import '../../components/text_field/text_field.dart';
import '../../components/texts/TextBlue.dart';

class Login extends StatefulWidget {
  const Login({
    super.key,
  });

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late SharedPreferences preferences;

  @override
  void initState() {
    super.initState();
    initSharedPreference();
    _userNameTextController.addListener(_validateUserName);
    _password.addListener(_validatePassword);
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

  void _validateUserName() {
    if (_userNameTextController.text == "") {
      setState(() {
        userNameHasError = true;
        userNameError = "Please Enter UserName.";
      });
    } else if (!RegExp(r'^[a-zA-Z0-9]+$')
        .hasMatch(_userNameTextController.text)) {
      setState(() {
        userNameHasError = true;
        userNameError = "User name should not include special characters.";
      });
    } else if (_userNameTextController.text.length < 6) {
      setState(() {
        userNameHasError = true;
        userNameError = "User name should be at least 6 characters long.";
      });
    } else {
      setState(() {
        userNameHasError = false;
        userNameError = "";
      });
    }
  }

  void _validatePassword() {
    String password = _password.text;

    if (password.isEmpty) {
      setState(() {
        passwordHasError = true;
        passwordError = "Please enter a password.";
      });
      return;
    }

    if (password.length < 8) {
      setState(() {
        passwordHasError = true;
        passwordError = "Password must be at least 8 characters long.";
      });
      return;
    }

    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      setState(() {
        passwordHasError = true;
        passwordError = "Password must contain at least one uppercase letter.";
      });
      return;
    }

    if (!RegExp(r'[a-z]').hasMatch(password)) {
      setState(() {
        passwordHasError = true;
        passwordError = "Password must contain at least one lowercase letter.";
      });
      return;
    }

    if (!RegExp(r'\d').hasMatch(password)) {
      setState(() {
        passwordHasError = true;
        passwordError = "Password must contain at least one number.";
      });
      return;
    }

    // If all conditions pass, the password is valid
    setState(() {
      passwordHasError = false;
      passwordError = "";
    });
  }

  void previousPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return const OpeningPage();
      }),
    );
  }

  void forgotPasswordPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return const ForgotPasswordPage();
      }),
    );
  }

  void signUpPage() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return const Signup1();
    }));
  }

  bool _isLoginLoading = false;

  Future<void> _handelLogin(
      BuildContext context, String userName, String password) async {
    if (userName == "") {
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
    if (password == "") {
      CustomSnackBar.showWarning(context, "Please Enter Password.");
      return;
    }
    if (!RegExp(r'^(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{8,}$')
        .hasMatch(_password.text)) {
      CustomSnackBar.showWarning(context,
          "Password must contain at least 8 characters, one uppercase letter, one lowercase letter, and one number.");
      return;
    }

    if (RegExp(r'^(?=.*[#,?$%]).+$').hasMatch(_password.text)) {
      CustomSnackBar.showWarning(context,
          "Password should not include the characters '#', '%', '?', or '\$'.");
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
                              child: TextBlue(text: "User Name", fontSize: 15)),
                          MyTextField(
                            controller: _userNameTextController,
                            hintText: "user name",
                            width: double.infinity,
                            obscureText: false,
                            icon: const Icon(Icons.person),
                            hasError: userNameHasError,
                            errorText: userNameError,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Align(
                              alignment: Alignment.centerLeft,
                              child: TextBlue(text: "Password", fontSize: 15)),
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
                                  horizontal: 20, vertical: 10),
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
                                          _password.text),
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
                                    fontSize: 15, color: Colors.black),
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
