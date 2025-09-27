import 'package:flutter/material.dart';
import 'package:skyticker/api/service/ForgotPasswordService.dart';
import 'package:skyticker/components/buttons/button_dark_large.dart';
import 'package:skyticker/pages/login_signup_pages/login_page.dart';
import 'package:skyticker/validations/SignUpInputValidations.dart';
import 'package:skyticker/validations/ValidationError.dart';

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

  bool userNameHasError = false;
  bool passwordHasError = false;
  bool confirmPasswordHasError = false;
  String userNameError = "";
  String passwordError = "";
  String confirmPasswordError = "";

  @override
  void initState() {
    super.initState();
    _usernameController.addListener(_validateUserNameListener);
    _newPasswordController.addListener(_validatePasswordListener);
    _confirmPasswordController.addListener(_validateConfirmPasswordListener);
  }

  void _validateUserNameListener() {
    ValidationError userNameValidationError =
        SignUpInputValidations.validateUsername(_usernameController.text);
    setState(() {
      userNameHasError = userNameValidationError.hasError;
      userNameError = userNameValidationError.message;
    });
  }

  void _validatePasswordListener() {
    ValidationError passwordValidationError =
        SignUpInputValidations.validatePassword(_newPasswordController.text);
    setState(() {
      passwordHasError = passwordValidationError.hasError;
      passwordError = passwordValidationError.message;
    });
  }

  void _validateConfirmPasswordListener() {
    ValidationError confirmPasswordValidationError =
        SignUpInputValidations.validateConfirmPassword(
          _newPasswordController.text,
          _confirmPasswordController.text,
        );
    setState(() {
      confirmPasswordHasError = confirmPasswordValidationError.hasError;
      confirmPasswordError = confirmPasswordValidationError.message;
    });
  }

  Future<void> resetPassword() async {
    String newPassword = _newPasswordController.text;
    String confirmPassword = _confirmPasswordController.text;
    String username = _usernameController.text;

    if (isUsernameToggleEnabled) {
      ValidationError userNameValidationError =
          SignUpInputValidations.validateUsername(username);
      if (userNameValidationError.hasError) {
        CustomSnackBar.showWarning(context, userNameValidationError.message);
        return;
      }
    }
    ValidationError passwordValidationError =
        SignUpInputValidations.validatePassword(newPassword);
    if (passwordValidationError.hasError) {
      CustomSnackBar.showWarning(context, passwordValidationError.message);
      return;
    }
    ValidationError confirmPasswordValidationError =
        SignUpInputValidations.validateConfirmPassword(
          newPassword,
          confirmPassword,
        );
    if (confirmPasswordValidationError.hasError) {
      CustomSnackBar.showWarning(
        context,
        confirmPasswordValidationError.message,
      );
      return;
    }

    try {
      setState(() {
        isLoading = true;
      });
      await ForgotPasswordService.resetPassword(
        context,
        widget.email,
        newPassword,
        isUsernameToggleEnabled,
        username,
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void navigateToLoginPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const Login();
        },
      ),
    );
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
                      child: TextBlue(text: "Reset Password", fontSize: 30),
                    ),
                    const SizedBox(height: 30),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const TextBlue(
                                text: "Change Username",
                                fontSize: 15,
                              ),
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
                              child: TextBlue(text: "Username", fontSize: 15),
                            ),
                            MyTextField(
                              controller: _usernameController,
                              hintText: "Enter new username",
                              width: double.infinity,
                              obscureText: false,
                              icon: const Icon(Icons.person),
                              hasError: userNameHasError,
                              errorText: userNameError,
                            ),
                            const SizedBox(height: 10),
                          ],
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: TextBlue(text: "New Password", fontSize: 15),
                          ),
                          MyTextField(
                            controller: _newPasswordController,
                            hintText: "Enter new password",
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
                            controller: _confirmPasswordController,
                            hintText: "Confirm new password",
                            width: double.infinity,
                            obscureText: true,
                            icon: const Icon(Icons.lock),
                            hasError: confirmPasswordHasError,
                            errorText: confirmPasswordError,
                          ),
                          const SizedBox(height: 40),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
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
          Positioned(
            top: 20,
            left: 20,
            child: RoundButton(
              onTap: navigateToLoginPage,
              icon: Icons.arrow_back,
            ),
          ),
        ],
      ),
    );
  }
}
