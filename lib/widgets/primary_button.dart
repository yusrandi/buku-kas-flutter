import 'package:flutter/material.dart';
import 'package:irza/utils/constants.dart';

class PrimaryButton extends StatefulWidget {
  final String btnText;
  const PrimaryButton({required this.btnText});

  @override
  _PrimaryButtonState createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: kSecondaryColor, borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Text(widget.btnText,
            style: Theme.of(context).primaryTextTheme.headline6),
      ),
    );
  }
}
