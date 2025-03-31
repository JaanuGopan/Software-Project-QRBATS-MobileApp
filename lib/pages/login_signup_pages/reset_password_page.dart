import 'package:flutter/material.dart';
import 'package:qrbats_sp/api_services/ForgotPasswordService.dart';
import 'package:qrbats_sp/components/buttons/button_dark_large.dart';
import 'package:qrbats_sp/pages/login_signup_pages/login_page.dart';

import '../../components/buttons/round_button.dart';
import '../../components/text_field/text_field.dart';
import '../../components/texts/TextBlue.dart';
import '../../widgets/snackbar/custom_snackbar.dart';

class ResetPasswordPage extends StatefulWidget {
  final String email;
  const ResetPasswordPage({Key? key, required this.email}) : super(key: key);

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  bool isLoading = false;
  bool isUsernameToggleEnabled = false;

  Future<void> resetPassword() async {
    String newPassword = _newPasswordController.text;
    String confirmPassword = _confirmPasswordController.text;
    String username = _usernameController.text;

    if (isUsernameToggleEnabled) {
      if (username.isEmpty) {
        CustomSnackBar.showWarning(context, 'Please enter username.');
        return;
      }
      if (username.length < 6) {
        CustomSnackBar.showWarning(
            context, "User name should be at least 6 characters long.");
        return;
      }
      if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(username)) {
        CustomSnackBar.showWarning(
            context, "User name should not include special characters.");
        return;
      }
    }
    if (newPassword.isEmpty) {
      CustomSnackBar.showWarning(context, 'Please enter new password.');
      return;
    }
    if (confirmPassword.isEmpty) {
      CustomSnackBar.showWarning(context, 'Please confirm new password.');
      return;
    }

    if (newPassword != confirmPassword) {
      CustomSnackBar.showWarning(context, 'Passwords do not match.');
      return;
    }
    if (!isValidPassword(newPassword)) {
      CustomSnackBar.showWarning(context,
          "Password must contain at least 8 characters, one uppercase letter, one lowercase letter, and one number.");
      return;
    }

    if (RegExp(r'^(?=.*[#,?$%]).+$').hasMatch(newPassword)) {
      CustomSnackBar.showWarning(context,
          "Password should not include the characters '#', '%', '?', or '\$'.");
      return;
    }

    try {
      setState(() {
        isLoading = true;
      });
      await ForgotPasswordService.resetPassword(context, widget.email,
          newPassword, isUsernameToggleEnabled, username);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  bool isValidPassword(String password) {
    // Password must contain at least 8 characters, one uppercase letter,
    // one lowercase letter, and one number
    final regex = RegExp(r'^(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{8,}$');
    return regex.hasMatch(password);
  }

  void navigateToLoginPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return const Login();
      }),
    );
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
                        child: TextBlue(text: "Reset Password", fontSize: 30)),
                    const SizedBox(height: 30),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const TextBlue(
                                  text: "Change Username", fontSize: 15),
                              const SizedBox(width: 10),
                              Switch(
                                value: isUsernameToggleEnabled,
                                focusColor: const Color(0xFF086494),
                                activeColor: const Color(0xFF086494),
                                inactiveThumbColor: Colors.white,
                                inactiveTrackColor: Colors.grey,
                                onChanged: (value) {
                                  setState(() {
                                    isUsernameToggleEnabled = value;
                                  });
                                },
                              ),
                            ],
                          ),
                          if (isUsernameToggleEnabled) ...[
                            const Align(
                                alignment: Alignment.centerLeft,
                                child:
                                    TextBlue(text: "Username", fontSize: 15)),
                            MyTextField(
                              controller: _usernameController,
                              hintText: "Enter new username",
                              width: double.infinity,
                              obscureText: false,
                              icon: const Icon(Icons.person),
                            ),
                            const SizedBox(height: 10),
                          ],
                          const Align(
                              alignment: Alignment.centerLeft,
                              child:
                                  TextBlue(text: "New Password", fontSize: 15)),
                          MyTextField(
                            controller: _newPasswordController,
                            hintText: "Enter new password",
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
                            controller: _confirmPasswordController,
                            hintText: "Confirm new password",
                            width: double.infinity,
                            obscureText: true,
                            icon: const Icon(Icons.lock),
                          ),
                          const SizedBox(height: 40),
                          Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: isLoading
                                  ? const Center(
                                      child: CircularProgressIndicator(
                                        color: Color(0xFF086494),
                                      ),
                                    )
                                  : MyButtonDS(
                                      onTap: resetPassword,
                                      text: "Reset Password",
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
