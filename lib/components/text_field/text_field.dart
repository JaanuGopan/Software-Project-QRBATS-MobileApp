import 'package:flutter/material.dart';

class MyTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final Icon icon;
  final double width;
  final double height;
  final bool hasError;
  final String errorText;

  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    required this.icon,
    required this.width,
    this.height = 55.0,
    this.hasError = false,
    this.errorText = '',
  });

  @override
  _MyTextFieldState createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    Color borderColor = widget.hasError ? Colors.red : const Color(0xFF086494);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: widget.width,
          height: widget.height, // Increase height if there's an error
          padding: EdgeInsets.zero,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            border: Border(
              top: BorderSide(color: borderColor, width: 0.5),
              right: BorderSide(color: borderColor, width: 0.25),
              left: BorderSide(color: borderColor, width: 0.25),
              bottom: BorderSide(color: borderColor, width: 3),
            ),
          ),
          child: TextField(
            controller: widget.controller,
            obscureText: widget.obscureText && _obscureText,
            style: TextStyle(color: borderColor),
            decoration: InputDecoration(
              border: InputBorder.none,
              prefixIcon: Icon(widget.icon.icon, color: borderColor),
              suffixIcon: widget.obscureText
                  ? IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                        color: borderColor,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    )
                  : null,
              hintText: widget.hintText,
              hintStyle: const TextStyle(color: Color(0xFF888888)),
            ),
          ),
        ),
        if (widget.hasError)
          Padding(
            padding: const EdgeInsets.only(top: 5, left: 5),
            child: Text(
              widget.errorText,
              style: const TextStyle(fontSize: 10, color: Colors.red),
            ),
          ),
      ],
    );
  }
}
