import 'package:flutter/material.dart';

class MyTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final Icon icon;
  final double width;
  final double height;
  final double borderWidth; // Added border thickness property

  const MyTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    required this.icon,
    required this.width, // Set default width to infinity
    this.height = 55.0, // Set default height to 65.0
    this.borderWidth = 1.0, // Set default border thickness to 1.0
  }) : super(key: key);

  @override
  _MyTextFieldState createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  bool _obscureText = true; // Default to false, not obscuring

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0), // Add border corner radius
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
      child: TextField(
        controller: widget.controller,
        obscureText: widget.obscureText && _obscureText,
        style: const TextStyle(
          color: Color(0xFF086494), // Changed text color
        ),
        decoration: InputDecoration(
          border: InputBorder.none, // Remove default border
          fillColor: Colors.transparent,
          prefixIcon: Icon(
            widget.icon.icon,
            color: const Color(0xFF086494), // Changed prefix icon color
          ),
          prefixIconColor: const Color(0xFF086494), // Changed prefix icon color
          suffixIcon: widget.obscureText
              ? IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off,
                    color: const Color(0xFF086494), // Changed suffix icon color
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                )
              : null,
          filled: true,
          hintText: widget.hintText,
          hintStyle: const TextStyle(
            color: Color(0xFF888888), // Changed hint text color
          ),
        ),
      ),
    );
  }
}
