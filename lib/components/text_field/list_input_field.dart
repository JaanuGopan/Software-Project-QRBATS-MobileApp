import 'package:flutter/material.dart';

class ListInputFieldWidget extends StatefulWidget {
  final String hintText;
  final Icon icon;
  final double width;
  final List<String> options;
  final String? initialValue;
  final double height;
  final double borderWidth;
  final void Function(String?)? onChanged;

  const ListInputFieldWidget({
    Key? key,
    required this.hintText,
    required this.icon,
    required this.width,
    required this.options,
    this.initialValue,
    this.height = 55.0,
    this.borderWidth = 1.0,
    this.onChanged,
  }) : super(key: key);

  @override
  _ListInputFieldWidgetState createState() => _ListInputFieldWidgetState();
}

class _ListInputFieldWidgetState extends State<ListInputFieldWidget> {
  String? _selectedValue;

  @override
  void initState() {
    super.initState();

    if (widget.initialValue != null) {
      print("Initial value " + widget.initialValue.toString());
      _selectedValue = widget.initialValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
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
            color: Color(0xFF086494),
            width: 3,
          ),
        ),
      ),
      child: DropdownButtonFormField<String>(
        value: _selectedValue,
        onChanged: (newValue) {
          setState(() {
            _selectedValue = newValue;
          });
          if (widget.onChanged != null) {
            int index = int.parse(newValue!) - 1;
            widget.onChanged!(widget.options[index]);
          }
        },
        items: List.generate(widget.options.length, (index) {
          return DropdownMenuItem<String>(
            value: (index + 1).toString(),
            child: Text(
              widget.options[index],
              style: const TextStyle(color: Color(0xFF086494)),
            ),
          );
        }),
        decoration: InputDecoration(
          border: InputBorder.none,
          fillColor: Colors.transparent,
          prefixIcon: Icon(
            widget.icon.icon,
            color: const Color(0xFF086494),
          ),
          prefixIconColor: const Color(0xFF086494),
          filled: true,
          hintText: widget.hintText,
          hintStyle: const TextStyle(
            color: Color(0xFF086494),
          ),
        ),
      ),
    );
  }
}
