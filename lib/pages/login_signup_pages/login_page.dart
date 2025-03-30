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
    Key? key,
  }) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late SharedPreferences preferences;

  @override
  void initState() {
    super.initState();
    initSharedPreference();
  }

  Future<void> initSharedPreference() async {
    preferences = await SharedPreferences.getInstance();
  }

  final TextEditingController _userNameTextController = TextEditingController();
  final TextEditingController _password = TextEditingController();

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
    if (password == "") {
      CustomSnackBar.showWarning(context, "Please Enter Password.");
    }
    try {
      setState(() {
        _isLoginLoading = true;
      });
      await LoginService.login(context, userName, password);
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
        ],
      ),
    );
  }
}
