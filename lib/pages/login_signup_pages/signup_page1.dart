import 'package:flutter/material.dart';
import 'package:qrbats_sp/api_services/CheckStudentInfo.dart';
import 'package:qrbats_sp/pages/login_signup_pages/signup_page2.dart';
import '../../components/buttons/round_button.dart';
import '../../components/text_field/text_field.dart';
import '../../components/texts/TextBlue.dart';
import '../../validations/SignUpInputValidations.dart';
import '../getStart_page.dart';
import 'login_page.dart';

import 'otp_verification_page.dart';

class Signup1 extends StatefulWidget {
  const Signup1({super.key});

  @override
  State<Signup1> createState() => _Signup1State();
}

class _Signup1State extends State<Signup1> {
  final _studentNameTextController = TextEditingController();
  final _indexNumberTextController = TextEditingController();
  final _emailTextController = TextEditingController();

  void nextPage() {
    if (SignUpInputValidations.validateInputs(_studentNameTextController.text,
        _indexNumberTextController.text, _emailTextController.text, context)) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return SignUp2(
          studentName: _studentNameTextController.text,
          email: _emailTextController.text,
          indexNumber: _indexNumberTextController.text,
        );
      }));
    } else {}
  }

  void otpVerificationPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return OtpVerificationPage(
          studentName: _studentNameTextController.text,
          email: _emailTextController.text,
          indexNumber: _indexNumberTextController.text,
        );
      }),
    );
  }

  void previousPage() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return OpeningPage();
    }));
  }

  void loginPage() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Login();
    }));
  }

  bool _isLoadingForOTPVerificationPage = false;

  Future<void> handleVerifySignupStep1() async {
    bool _isValidInputs = SignUpInputValidations.validateInputs(
      _studentNameTextController.text,
      _indexNumberTextController.text,
      _emailTextController.text,
      context,
    );

    if (_isValidInputs) {
      try {
        setState(() {
          _isLoadingForOTPVerificationPage = true;
        });
        await CheckStudentInfo.checkStudentInfo(
          _emailTextController.text,
          _indexNumberTextController.text,
          otpVerificationPage,
          context,
        );
      } finally {
        // TODO
        setState(() {
          _isLoadingForOTPVerificationPage = false;
        });
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _indexNumberTextController.text = "EG/20XX/XXXX";
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: screenHeight,
        width: screenWidth,
        color: Colors.white,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 20),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(child: TextBlue(text: "SignUp", fontSize: 25)),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      width: screenWidth * 0.9,
                      decoration: _buildContainerDecoration(),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(height: 30),
                            TextBlue(text: "Student Name", fontSize: 20),
                            SizedBox(height: 10),
                            MyTextField(
                              controller: _studentNameTextController,
                              hintText: "student name",
                              width: screenWidth * 0.8,
                              obscureText: false,
                              icon: Icon(Icons.drive_file_rename_outline),
                            ),
                            SizedBox(height: 40),
                            TextBlue(text: "Index Number", fontSize: 20),
                            SizedBox(height: 10),
                            MyTextField(
                              controller: _indexNumberTextController,
                              hintText: "index number",
                              width: screenWidth * 0.8,
                              obscureText: false,
                              icon: Icon(Icons.numbers),
                            ),
                            SizedBox(height: 40),
                            TextBlue(text: "Email Address", fontSize: 20),
                            SizedBox(height: 10),
                            MyTextField(
                              controller: _emailTextController,
                              hintText: "email",
                              width: screenWidth * 0.8,
                              obscureText: false,
                              icon: Icon(Icons.email),
                            ),
                            SizedBox(height: 40),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Row(
                    children: [
                      Spacer(),
                      Text(
                        "If you already have an account? ",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 10, color: Colors.black),
                      ),
                      TextButton(
                          onPressed: loginPage,
                          child: Text(
                            "SignIn",
                            style: TextStyle(color: Color(0xFF086494)),
                          )),
                      Spacer(),
                    ],
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.11,
                ),
                Center(
                  child: Row(
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      RoundButton(
                        onTap: previousPage,
                        icon: Icons.arrow_back,
                      ),
                      Spacer(),
                      _isLoadingForOTPVerificationPage
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : RoundButton(
                              onTap: () {
                                handleVerifySignupStep1();
                              },
                              icon: Icons.arrow_forward,
                            ),
                      SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
