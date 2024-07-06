import 'package:flutter/material.dart';
import 'package:qrbats_sp/api_services/ForgotPasswordService.dart';
import 'package:qrbats_sp/components/forgot_password_component/otp_verification_popup.dart';
import 'package:qrbats_sp/pages/login_signup_pages/login_page.dart';
import 'package:qrbats_sp/pages/login_signup_pages/reset_password_page.dart';
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



  void navigateToLoginPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return Login();
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
        showOTPVerificationPopup(context, email);
      } finally {
        setState(() {
          _isOTPSend = true;
        });
      }
    } else {
      CustomSnackBar.showError(context, "Please Enter a Valid Email.");
    }
  }




  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: screenHeight,
          width: screenWidth,
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  color: Colors.white,
                  child: Center(
                    child: TextBlue(
                      text: "Forgot Password",
                      fontSize: 25,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Container(
                  color: Colors.white,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        height: screenHeight * 0.5,
                        width: screenWidth * 0.9,
                        decoration: _buildContainerDecoration(),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [

                              Padding(
                                padding: const EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 20),
                                child: Center(
                                  child: Text(
                                    "You need to enter the email address, and then you will receive an OTP sent to that email.",
                                    style: TextStyle(fontSize: 12, color: Colors.grey),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              SizedBox(height: 40,),
                              TextBlue(
                                text: "Email Address",
                                fontSize: 20,
                              ),
                              SizedBox(height: 10),
                              MyTextField(
                                controller: _emailController,
                                hintText: "email",
                                width: screenWidth * 0.8,
                                obscureText: false,
                                icon: Icon(Icons.email),
                              ),
                              SizedBox(height: 20),
                              _isOTPSend ? OutlinedButton(
                                  onPressed: () {
                                    sendOTP(context, _emailController.text);
                                  },
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(color: Color(0xFF086494)),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                  child: Text(
                                    "Send OTP",
                                    style: TextStyle(color: Color(0xFF086494)),
                                  ))
                                  : Center(child: CircularProgressIndicator(),),

                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  color: Colors.white,
                  child: Center(
                    child: Column(
                      children: [
                        Spacer(),
                        Row(
                          children: [
                            SizedBox(width: 20),
                            RoundButton(
                              onTap: () => navigateToLoginPage(),
                              icon: Icons.arrow_back,
                            ),
                            Spacer(),

                            SizedBox(width: 20),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.05),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildContainerDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(10.0),
      border: Border(
        top: BorderSide(
          color: Color(0xFF086494),
          width: 6.0,
        ),
        bottom: BorderSide(
          color: Color(0xFF086494),
          width: 1.0,
        ),
        left: BorderSide(
          color: Color(0xFF086494),
          width: 1.0,
        ),
        right: BorderSide(
          color: Color(0xFF086494),
          width: 1.0,
        ),
      ),
    );
  }
}
