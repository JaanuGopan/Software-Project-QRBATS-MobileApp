import 'package:flutter/material.dart';
import 'package:qrbats_sp/api_services/OTPService.dart';
import 'package:qrbats_sp/pages/login_signup_pages/signup_page2.dart';
import 'dart:async';
import '../../components/text_field/text_field.dart';
import '../../components/texts/TextBlue.dart';

class OtpVerificationPage extends StatefulWidget {
  final String email;
  final String indexNumber;
  final String studentName;

  const OtpVerificationPage({
    Key? key,
    required this.email,
    required this.indexNumber,
    required this.studentName,
  }) : super(key: key);

  @override
  _OtpVerificationPageState createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final TextEditingController _otpController = TextEditingController();
  bool showResendOTPButton = false;
  late Timer _timer;
  int _remainingTime = 300; // 5 minutes in seconds

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        setState(() {
          showResendOTPButton = true;
          _timer.cancel();
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void nextPage() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return SignUp2(
        studentName: widget.studentName,
        email: widget.email,
        indexNumber: widget.indexNumber,
      );
    }));
  }

  String get _formattedTime {
    final minutes = (_remainingTime ~/ 60).toString().padLeft(2, '0');
    final seconds = (_remainingTime % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  bool _isLoadingResendOTP = false;

  Future<void> handleResendOTP() async {
    try {
      setState(() {
        _isLoadingResendOTP = true;
      });
      await OTPServices.generateOTP(context, widget.email);
    } finally {
      setState(() {
        _isLoadingResendOTP = false;
        showResendOTPButton = false;
        _remainingTime = 300;
        _startTimer();
      });
    }
  }

  bool _isVerifyOTPLoading = false;

  Future<void> handleVerifyOTP() async {
    try {
      setState(() {
        _isVerifyOTPLoading = true;
      });
      OTPServices.verifyOTP(
          context, widget.email, _otpController.text, nextPage);
    } finally {
      setState(() {
        _isVerifyOTPLoading = false;
      });
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
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  color: Colors.white,
                  child: Center(
                      child: TextBlue(text: "OTP Verification", fontSize: 25)),
                ),
              ),
              Expanded(
                flex: 8,
                child: Container(
                  color: Colors.white,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        height: screenHeight * 0.65,
                        width: screenWidth * 0.9,
                        decoration: _buildContainerDecoration(),
                        child: Center(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                SizedBox(height: 30),
                                TextBlue(
                                    text: "Enter the OTP sent to",
                                    fontSize: 20),
                                TextBlue(text: "${widget.email}", fontSize: 20),
                                SizedBox(height: 40),
                                MyTextField(
                                  controller: _otpController,
                                  hintText: "Enter OTP",
                                  width: screenWidth * 0.8,
                                  obscureText: false,
                                  icon: Icon(Icons.lock_outline),
                                ),
                                SizedBox(height: 40),
                                _isVerifyOTPLoading ? Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : OutlinedButton(
                                        onPressed: () => {handleVerifyOTP()},
                                        style: OutlinedButton.styleFrom(
                                          side: const BorderSide(
                                              color: Colors.green),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                        ),
                                        child: const Text(
                                          "Verify OTP",
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.green),
                                        ),
                                      ),
                                SizedBox(
                                  height: 20,
                                ),
                                showResendOTPButton
                                    ? _isLoadingResendOTP
                                        ? Center(
                                            child: CircularProgressIndicator(),
                                          )
                                        : OutlinedButton(
                                            onPressed: () =>
                                                {handleResendOTP()},
                                            style: OutlinedButton.styleFrom(
                                              side: const BorderSide(
                                                  color: Colors.orange),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                            ),
                                            child: const Text(
                                              "Resend OTP",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.orange),
                                            ),
                                          )
                                    : Center(
                                        child: Text(
                                            "The OTP Is Expired In $_formattedTime"),
                                      ) // timer
                              ],
                            ),
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
                        Row(
                          children: [
                            SizedBox(
                              width: 20,
                            ),
                            Spacer(),
                            SizedBox(
                              width: 20,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: screenHeight * 0.007,
                        ),
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
