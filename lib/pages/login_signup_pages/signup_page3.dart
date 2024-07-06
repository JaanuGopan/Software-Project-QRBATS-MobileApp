import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qrbats_sp/api_services/RegistrationHelper.dart'; // Adjust import path as needed
import 'package:qrbats_sp/widgets/snackbar/custom_snackbar.dart';
import '../../components/buttons/button_dark_large.dart';
import '../../components/buttons/round_button.dart';
import '../../components/text_field/text_field.dart';
import '../../components/texts/TextBlue.dart';
import '../main_pages/main_page.dart';

class SignUp3 extends StatefulWidget {
  final String studentName;
  final String indexNumber;
  final String email;
  final String studentRole;
  final int departmentId;
  final int currentSemester;

  const SignUp3({
    Key? key,
    required this.studentName,
    required this.indexNumber,
    required this.email,
    required this.studentRole,
    required this.departmentId,
    required this.currentSemester,
  }) : super(key: key);

  @override
  State<SignUp3> createState() => _SignUp3State();
}

class _SignUp3State extends State<SignUp3> {
  final TextEditingController _userNameTextController = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();

  void previousPage() {
    Navigator.pop(context);
  }

  void nextPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return MainPage();
      }),
    );
  }

  bool _isSignUpLoading = false;

  Future<void> handleSignUp() async {
    try {
      setState(() {
        _isSignUpLoading = true;
      });
      if(_userNameTextController.text == ""){
        CustomSnackBar.showWarning(context, "Please Enter UserName.");
        return;
      }
      if(_password.text == ""){
        CustomSnackBar.showWarning(context, "Please Enter Password.");
        return;
      }
      if(_confirmPassword.text == ""){
        CustomSnackBar.showWarning(context, "Please Enter Confirm Password.");
        return;
      }
      if(_confirmPassword.text != _password.text){
        CustomSnackBar.showWarning(context, "Password And Confirm Password Are Not Match.");
        return;
      }


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
      );
    } finally {
      setState(() {
        _isSignUpLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: screenHeight,
        width: screenWidth,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                      child:
                          Center(child: TextBlue(text: "SignUp", fontSize: 30)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        width: screenWidth * 0.9,
                        decoration: _buildContainerDecoration(),
                        child: Column(
                          children: [
                            const SizedBox(height: 30),
                            const TextBlue(text: "User Name", fontSize: 20),
                            const SizedBox(height: 10),
                            MyTextField(
                              controller: _userNameTextController,
                              hintText: "user name",
                              width: screenWidth * 0.8,
                              obscureText: false,
                              icon: const Icon(Icons.person),
                            ),
                            const SizedBox(height: 40),
                            const TextBlue(text: "Password", fontSize: 20),
                            const SizedBox(height: 10),
                            MyTextField(
                              controller: _password,
                              hintText: "password",
                              width: screenWidth * 0.8,
                              obscureText: true,
                              icon: Icon(Icons.lock),
                            ),
                            SizedBox(height: 40),
                            TextBlue(text: "Confirm Password", fontSize: 20),
                            SizedBox(height: 10),
                            MyTextField(
                              controller: _confirmPassword,
                              hintText: "confirm password",
                              width: screenWidth * 0.8,
                              obscureText: true,
                              icon: Icon(Icons.lock),
                            ),
                            SizedBox(height: 40),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Row(
                  children: [
                    SizedBox(width: 20),
                    RoundButton(onTap: previousPage, icon: Icons.arrow_back),
                    Spacer(),
                    _isSignUpLoading
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : MyButtonDS(
                            onTap: () {
                              handleSignUp();
                            },
                            text: "SignUp",
                            width: 100,
                          ),
                    SizedBox(width: 20),
                  ],
                ),
              ),
            ),
          ],
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
