import 'package:flutter/material.dart';

class SubmitGeneralWidget extends StatelessWidget {
  final String title;
  final Function? onPressed;
  const SubmitGeneralWidget({super.key, required this.title, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed as void Function()?,
      style: TextButton.styleFrom(
        foregroundColor: const Color(0xff003087),
        backgroundColor: const Color(0xff003087),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        minimumSize: const Size(double.maxFinite, 50),
      ),
      child: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
