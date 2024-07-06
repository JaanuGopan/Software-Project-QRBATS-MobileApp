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
        return OpeningPage();
      }),
    );
  }

  void forgotPasswordPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return ForgotPasswordPage();
      }),
    );
  }

  void signUpPage() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Signup1();
    }));
  }

  bool _isLoginLoading = false;

  Future<void> _handelLogin(
      BuildContext context, String userName, String password) async {
    if(userName == ""){
      CustomSnackBar.showWarning(context, "Please Enter UserName.");
      return;
    }
    if(password == ""){
      CustomSnackBar.showWarning(context, "Please Enter Password.");
    }
    try {
      setState(() {
        _isLoginLoading = true;
      });
      await LoginService.login(context, userName, password);
    } on Exception catch (e) {
      // TODO
      CustomSnackBar.showError(context, "Error in Login.");
    } finally {
      setState(() {
        _isLoginLoading = false;
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
                    SizedBox(height: 20),
                    Center(child: TextBlue(text: "LogIn", fontSize: 30)),
                    SizedBox(height: 30),
                    Container(
                      padding: EdgeInsets.only(
                          left: 10, right: 10, top: 20, bottom: 30),
                      width: screenWidth * 0.9,
                      decoration: _buildContainerDecoration(),
                      child: Column(
                        children: [
                          Center(
                            child: Padding(
                              padding: EdgeInsets.only(top: 10, bottom: 20),
                              child: Text(
                                "This is very easy to use and You can mark your attendance very Quickly and Easily",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 12, color: Colors.black),
                              ),
                            ),
                          ),
                          TextBlue(text: "User Name", fontSize: 20),
                          SizedBox(height: screenHeight * 0.02),
                          MyTextField(
                            controller: _userNameTextController,
                            hintText: "user name",
                            width: screenWidth * 0.8,
                            obscureText: false,
                            icon: Icon(Icons.person),
                          ),
                          SizedBox(height: screenHeight * 0.05),
                          TextBlue(text: "Password", fontSize: 20),
                          SizedBox(height: 20),
                          MyTextField(
                            controller: _password,
                            hintText: "password",
                            width: screenWidth * 0.8,
                            obscureText: true,
                            icon: Icon(Icons.lock),
                          ),
                          SizedBox(height: 20),
                          Row(
                            children: [
                              Spacer(),
                              TextButton(
                                onPressed: forgotPasswordPage,
                                child: Text(
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
                              SizedBox(width: 10),
                            ],
                          ),
                          Row(
                            children: [
                              Spacer(),
                              Text(
                                "If you don't have an account? ",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 12, color: Colors.black),
                              ),
                              TextButton(
                                onPressed: signUpPage,
                                child: Text(
                                  "SignUp",
                                  style: TextStyle(color: Color(0xFF086494)),
                                ),
                              ),
                              Spacer(),
                            ],
                          ),
                        ],
                      ),
                    ),
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
                    SizedBox(width: 15),
                    RoundButton(onTap: previousPage, icon: Icons.arrow_back),
                    Spacer(),
                    _isLoginLoading
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : MyButtonDS(
                            onTap: () => _handelLogin(context,_userNameTextController.text,_password.text),
                            text: "LogIn",
                            width: screenWidth * 0.35,
                          ),
                    SizedBox(width: 15),
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
      border: Border.all(
        color: Color(0xFF086494),
        width: 1.0,
      ),
    );
  }
}
