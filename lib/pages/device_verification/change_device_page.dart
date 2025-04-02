import 'dart:io';
import 'dart:ui';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qrbats_sp/api_services/DeviceVerificationService.dart';
import 'package:qrbats_sp/components/buttons/button_dark_large.dart';
import 'package:qrbats_sp/components/buttons/round_button.dart';
import 'package:qrbats_sp/pages/login_signup_pages/login_page.dart';

import '../../components/text_field/text_field.dart';
import '../../components/texts/TextBlue.dart';
import '../../widgets/snackbar/custom_snackbar.dart';

class ChangeDevicePage extends StatefulWidget {
  const ChangeDevicePage({Key? key}) : super(key: key);

  @override
  _ChangeDevicePageState createState() => _ChangeDevicePageState();
}

class _ChangeDevicePageState extends State<ChangeDevicePage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _userNameTextController = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool userNameHasError = false;
  bool passwordHasError = false;
  String userNameError = "";
  String passwordError = "";
  bool isEmailHasError = false;
  String emailError = '';

  bool _showWarningPopup = true;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_emailValidationListener);
    _userNameTextController.addListener(_validateUserName);
    _password.addListener(_validatePassword);
  }

  void _emailValidationListener() {
    if (_emailController.text.isEmpty) {
      setState(() {
        isEmailHasError = true;
        emailError = 'Please enter your email';
      });
      return;
    }

    RegExp emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(_emailController.text)) {
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

  void navigateToLoginPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return const Login();
      }),
    );
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

  bool _isOTPSend = true;

  Future<void> sendOTP(BuildContext context, String email) async {
    if (email.isEmpty) {
      CustomSnackBar.showWarning(context, "Please Enter Email Address.");
    }

    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(email)) {
      CustomSnackBar.showWarning(
          context, "Please Enter a Valid Email Address.");
    }

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

    try {
      setState(() {
        _isOTPSend = false;
      });
      String? deviceId = await getDeviceId();
      await DeviceVerificationService.sendOTPForDeviceVerification(context,
          email, _userNameTextController.text, _password.text, deviceId);
    } finally {
      setState(() {
        _isOTPSend = true;
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
                    const Center(
                        child: TextBlue(
                            text: "Device Verification", fontSize: 30)),
                    const SizedBox(height: 30),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Center(
                              child: Text(
                                "Please enter your account email address, username and password. You will receive an OTP to that email, and once verified, your device will be linked to your account.",
                                style:
                                    TextStyle(fontSize: 12, color: Colors.grey),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Align(
                              alignment: Alignment.centerLeft,
                              child: TextBlue(
                                  text: "Email Address", fontSize: 15)),
                          const SizedBox(height: 10),
                          MyTextField(
                            controller: _emailController,
                            hintText: "email",
                            width: double.infinity,
                            obscureText: false,
                            icon: const Icon(Icons.email),
                            hasError: isEmailHasError,
                            errorText: emailError,
                          ),
                          const SizedBox(height: 10),
                          const Align(
                              alignment: Alignment.centerLeft,
                              child: TextBlue(text: "Username", fontSize: 15)),
                          const SizedBox(height: 10),
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
                              child: TextBlue(text: "Password", fontSize: 15)),
                          const SizedBox(height: 10),
                          MyTextField(
                            controller: _password,
                            hintText: "password",
                            width: double.infinity,
                            obscureText: true,
                            icon: const Icon(Icons.lock),
                            hasError: passwordHasError,
                            errorText: passwordError,
                          ),
                          const SizedBox(height: 40),
                          _isOTPSend
                              ? MyButtonDS(
                                  onTap: () =>
                                      sendOTP(context, _emailController.text),
                                  text: "Verify Your Device",
                                  width: double.infinity,
                                )
                              : const Center(
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: Color(0xFF086494),
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
            child:
                RoundButton(onTap: navigateToLoginPage, icon: Icons.arrow_back),
          ),
          if (_showWarningPopup)
            Stack(
              children: [
                ModalBarrier(
                  color: Colors.black.withOpacity(0.5), // Dim background
                  dismissible: false, // Prevent dismiss by tapping outside
                ),
                Center(
                  child: _showDeviceVerificationPopup(context),
                ),
              ],
            ),
        ],
      ),
    );
  }

  BackdropFilter _showDeviceVerificationPopup(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5), // Apply blur
      child: AlertDialog(
        contentPadding: EdgeInsets.zero,
        content: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const ListTile(
                title: Center(
                  child: Text(
                    "Device Verification Warning",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.red),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Your device is not linked to your account. Please verify your device or use your original device to log in. Once verified, this device will be linked to your account. If this is not your original device, please switch to the correct one. If this device is already linked to a different account, you will not be able to use it to log in.",
                      style: TextStyle(fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              ),
              ButtonBar(
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Cancel",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _showWarningPopup = false;
                      });
                    },
                    child: const Text(
                      "Verify",
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
