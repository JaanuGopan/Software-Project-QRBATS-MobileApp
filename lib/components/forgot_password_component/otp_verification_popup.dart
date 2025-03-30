import 'dart:async';

import 'package:flutter/material.dart';
import 'package:qrbats_sp/api_services/ForgotPasswordService.dart';

void showOTPVerificationPopup(BuildContext context, String email) {
  TextEditingController OTPTextEditingController = TextEditingController();

  Future<void> handleVerifyOTP(
      BuildContext context, String email, String otp) async {
    try {
      await ForgotPasswordService.verifyOTPForForgotPassword(
          context, email, otp);
    } on Exception catch (e) {
      // TODO
    }
  }

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: EdgeInsets.zero,
        content: Container(
          decoration: _alertBoxDecoration,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const ListTile(
                title: Center(
                  child: Text(
                    "OTP Verification",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "The OTP is send to the email",
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      email,
                      style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    TextField(
                      controller: OTPTextEditingController,
                      decoration: const InputDecoration(
                        hintText: "Enter OTP",
                      ),
                    ),
                  ],
                ),
              ),
              ButtonBar(
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      "Cancel",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      handleVerifyOTP(
                          context, email, OTPTextEditingController.text);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text(
                      "Verify",
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

// Define the custom BoxDecoration
final BoxDecoration _alertBoxDecoration = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(15.0),
  boxShadow: [
    BoxShadow(
      color: Colors.black.withOpacity(0.5),
      spreadRadius: 1,
      blurRadius: 10,
      offset: const Offset(0, 3),
    ),
  ],
);
