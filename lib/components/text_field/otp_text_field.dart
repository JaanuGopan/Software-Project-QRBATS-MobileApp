import 'package:flutter/material.dart';

class OTPTextField extends StatefulWidget {
  final TextEditingController controller;
  final int length;

  const OTPTextField({
    Key? key,
    required this.controller,
    required this.length,
  }) : super(key: key);

  @override
  _OTPTextFieldState createState() => _OTPTextFieldState();
}

class _OTPTextFieldState extends State<OTPTextField> {
  List<TextEditingController> controllers = [];
  List<FocusNode> focusNodes = [];
  String otp = "";

  @override
  void initState() {
    super.initState();
    // Initialize controllers and focus nodes
    for (int i = 0; i < widget.length; i++) {
      controllers.add(TextEditingController());
      focusNodes.add(FocusNode());
    }
  }

  @override
  void dispose() {
    for (int i = 0; i < widget.length; i++) {
      controllers[i].dispose();
      focusNodes[i].dispose();
    }
    super.dispose();
  }

  void onOTPChanged(int index) {
    otp = controllers.map((controller) => controller.text).join();
    setState(() {
      widget.controller.text = otp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.length, (index) {
        return Container(
          width: 60.0,
          height: 60.0,
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            border: const Border(
              top: BorderSide(
                color: Color(0xFF086494), // Set top border color
                width: 0.5, // Set top border thickness
              ),
              right: BorderSide(
                color: Color(0xFF086494), // Set right border color
                width: 0.25, // Set right border thickness
              ),
              left: BorderSide(
                color: Color(0xFF086494), // Set left border color
                width: 0.25, // Set left border thickness
              ),
              bottom: BorderSide(
                color: Color(0xFF086494), // Set bottom border color
                width: 3, // Set bottom border thickness
              ),
            ),
          ),
          child: Center(
            child: TextField(
              controller: controllers[index],
              focusNode: focusNodes[index],
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF086494),
                fontSize: 25.0,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
              maxLength: 1,
              buildCounter: (BuildContext context,
                      {int? currentLength, bool? isFocused, int? maxLength}) =>
                  null,
              onChanged: (value) {
                if (value.isNotEmpty && index < widget.length - 1) {
                  FocusScope.of(context).requestFocus(
                      focusNodes[index + 1]); // Move focus to next box
                }
                onOTPChanged(index);
              },
            ),
          ),
        );
      }),
    );
  }
}
