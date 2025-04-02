import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qrbats_sp/api_services/DeviceVerificationService.dart';
import 'package:qrbats_sp/api_services/OTPService.dart';
import 'package:qrbats_sp/components/buttons/round_button.dart';
import 'package:qrbats_sp/components/text_field/otp_text_field.dart';
import 'package:qrbats_sp/pages/login_signup_pages/login_page.dart';
import 'package:qrbats_sp/widgets/snackbar/custom_snackbar.dart';

import '../../components/texts/TextBlue.dart';

class DeviceOtpVerification extends StatefulWidget {
  final String email;

  const DeviceOtpVerification({
    super.key,
    required this.email,
  });

  @override
  _DeviceOtpVerificationState createState() => _DeviceOtpVerificationState();
}

class _DeviceOtpVerificationState extends State<DeviceOtpVerification> {
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
      return const Login();
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

  Future<String?> getDeviceId() async {
    try {
      var deviceInfo = DeviceInfoPlugin();

      if (kIsWeb) {
        print("Running on Web - Device ID not available");
        return "Web_Device"; // Placeholder value for web
      } else if (Platform.isAndroid) {
        var androidInfo = await deviceInfo.androidInfo;
        print("Android ID: " + androidInfo.id);
        return androidInfo.id; // Unique Android ID
      } else if (Platform.isIOS) {
        var iosInfo = await deviceInfo.iosInfo;
        return iosInfo.identifierForVendor; // Unique iOS ID
      }

      return null;
    } on Exception catch (e) {
      print("Error getting device ID: $e");
      return null;
    }
  }

  bool _isVerifyOTPLoading = false;

  Future<void> handleVerifyOTP() async {
    if (_otpController.text.isEmpty) {
      CustomSnackBar.showWarning(context, "Please enter OTP");
      return;
    }
    if (_otpController.text.length != 4) {
      CustomSnackBar.showWarning(context, "Please enter a valid OTP");
      return;
    }
    try {
      setState(() {
        _isVerifyOTPLoading = true;
      });

      String? deviceId = await getDeviceId();

      await DeviceVerificationService.verifyOTPForDeviceVerification(
          context, widget.email, _otpController.text, deviceId);
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
                              Flexible(
                                child: Center(
                                  child: Text(
                                    'The OTP has been sent to ${widget.email}',
                                    style: const TextStyle(
                                        fontSize: 15, color: Colors.black),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: OTPTextField(
                              controller: _otpController,
                              length: 4,
                            ),
                          ),
                          const SizedBox(height: 20),
                          _isVerifyOTPLoading || _isLoadingResendOTP
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: Color(0xFF086494),
                                  ),
                                )
                              : showResendOTPButton
                                  ? Column(
                                      children: [
                                        const Center(
                                          child: Text(
                                              "Click the button below to resend OTP"),
                                        ),
                                        const SizedBox(height: 10),
                                        RoundButton(
                                          onTap: handleResendOTP,
                                          icon: Icons.refresh,
                                        ),
                                      ],
                                    )
                                  : Column(
                                      children: [
                                        RoundButton(
                                          onTap: handleVerifyOTP,
                                          icon: Icons.check,
                                        ),
                                        const SizedBox(height: 10),
                                        Center(
                                          child: Text(
                                              "The OTP will expire in $_formattedTime"),
                                        ),
                                      ],
                                    ),
                          const SizedBox(height: 20),
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
                onTap: () => Navigator.pop(context), icon: Icons.arrow_back),
          ),
        ],
      ),
    );
  }
}
