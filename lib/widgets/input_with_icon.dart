import 'package:flutter/material.dart';
import 'package:irza/utils/constants.dart';

class InputWithIcon extends StatefulWidget {
  final String inputText;
  final IconData icon;
  final TextEditingController controller;
  final String? Function(String?) validator;

  const InputWithIcon(
      {key,
      required this.inputText,
      required this.icon,
      required this.controller,
      required this.validator})
      : super(key: key);

  @override
  _InputWithIconState createState() => _InputWithIconState();
}

class _InputWithIconState extends State<InputWithIcon> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: kHintTextColor, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            child: Icon(
              widget.icon,
              size: 20,
              color: kHintTextColor,
            ),
          ),
          Expanded(
              child: TextFormField(
            controller: widget.controller,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: widget.inputText,
            ),
            validator: widget.validator,
          ))
        ],
      ),
    );
  }
}
