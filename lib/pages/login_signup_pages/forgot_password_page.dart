import 'package:flutter/material.dart';
import 'package:qrbats_sp/api_services/ForgotPasswordService.dart';
import 'package:qrbats_sp/components/buttons/button_dark_large.dart';
import 'package:qrbats_sp/pages/login_signup_pages/login_page.dart';

import '../../components/buttons/round_button.dart';
import '../../components/text_field/text_field.dart';
import '../../components/texts/TextBlue.dart';
import '../../widgets/snackbar/custom_snackbar.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();

  bool isEmailHasError = false;
  String emailError = '';

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_emailValidationListener);
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

  void navigateToLoginPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return const Login();
      }),
    );
  }

  bool showOTPVerifyWindow = false;

  void _handleOpenAndCloseVerifyOTP() {
    setState(() {
      showOTPVerifyWindow = !showOTPVerifyWindow;
    });
  }

  bool _isOTPSend = true;

  Future<void> sendOTP(BuildContext context, String email) async {
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

    if (email.isNotEmpty && emailRegex.hasMatch(email)) {
      try {
        setState(() {
          _isOTPSend = false;
        });
        await ForgotPasswordService.sendOTPForForgotPassword(context, email);
      } finally {
        setState(() {
          _isOTPSend = true;
        });
      }
    } else {
      CustomSnackBar.showWarning(context, "Please Enter a Valid Email.");
    }
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
            child:
                RoundButton(onTap: navigateToLoginPage, icon: Icons.arrow_back),
          ),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(right: 20.0, left: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    const Center(
                        child: TextBlue(text: "Forgot Password", fontSize: 30)),
                    const SizedBox(height: 30),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            child: Center(
                              child: Text(
                                "You need to enter the email address, and then you will receive an OTP sent to that email.",
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
                                  text: "Email Address", fontSize: 20)),
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
                          const SizedBox(height: 20),
                          _isOTPSend
                              ? MyButtonDS(
                                  onTap: () =>
                                      sendOTP(context, _emailController.text),
                                  text: "Send OTP",
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
        ],
      ),
    );
  }
}
