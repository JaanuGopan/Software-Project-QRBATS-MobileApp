import 'dart:async';

import 'package:flutter/material.dart';
import 'package:qrbats_sp/api_services/OTPService.dart';
import 'package:qrbats_sp/components/buttons/round_button.dart';
import 'package:qrbats_sp/components/text_field/otp_text_field.dart';
import 'package:qrbats_sp/pages/login_signup_pages/signup_page3.dart';
import 'package:qrbats_sp/widgets/snackbar/custom_snackbar.dart';

import '../../components/texts/TextBlue.dart';

class OtpVerificationPage extends StatefulWidget {
  final String email;
  final String indexNumber;
  final String studentName;
  final String studentRole;
  final int? departmentId;
  final int currentSemester;
  final int studentBatch;

  const OtpVerificationPage({
    Key? key,
    required this.email,
    required this.indexNumber,
    required this.studentName,
    required this.studentRole,
    required this.departmentId,
    required this.currentSemester,
    required this.studentBatch,
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
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
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
      return SignUp3(
        studentName: widget.studentName,
        email: widget.email,
        indexNumber: widget.indexNumber,
        studentRole: widget.studentRole,
        departmentId: widget.departmentId,
        currentSemester: widget.currentSemester,
        studentBatch: widget.studentBatch,
      );
      /* return SignUp3(
        studentName: "John Doe",
        email: "john.doe@example.com",
        indexNumber: "123456",
        studentRole: "Student",
        departmentId: 1,
        currentSemester: 3,
        studentBatch: 2021,
      ); */
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
    if (_otpController.text.isEmpty) {
      CustomSnackBar.showError(context, "Please enter OTP");
      return;
    }
    if (_otpController.text.length != 4) {
      CustomSnackBar.showError(context, "Please enter a valid OTP");
      return;
    }
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: 20,
            left: 20,
            child: RoundButton(
                onTap: () => Navigator.pop(context), icon: Icons.arrow_back),
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
                        child:
                            TextBlue(text: "OTP Verification", fontSize: 30)),
                    const SizedBox(height: 30),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const TextBlue(
                                  text: "Enter the OTP sent to ", fontSize: 15),
                              Text(
                                widget.email,
                                style: const TextStyle(fontSize: 15),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          OTPTextField(
                            controller: _otpController,
                            length: 4,
                          ),
                          const SizedBox(height: 20),
                          _isVerifyOTPLoading
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: Color(0xFF086494),
                                  ),
                                )
                              : RoundButton(
                                  onTap: handleVerifyOTP,
                                  icon: Icons.check,
                                ),
                          const SizedBox(height: 20),
                          showResendOTPButton
                              ? _isLoadingResendOTP
                                  ? const Center(
                                      child: CircularProgressIndicator(
                                        color: Color(0xFF086494),
                                      ),
                                    )
                                  : RoundButton(
                                      onTap: handleResendOTP,
                                      icon: Icons.refresh,
                                    )
                              : Center(
                                  child: Text(
                                      "The OTP will expire in $_formattedTime"),
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
