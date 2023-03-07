import 'package:flutter/material.dart';

class InputGeneralWidget extends StatelessWidget {
  final TextEditingController controller;
  final String title;
  final IconData icon;
  final bool show;
  final Function? onPressed;
  const InputGeneralWidget(
      {super.key,
      required this.controller,
      required this.title,
      required this.icon,
      this.onPressed,
      required this.show});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w300,
          ),
          textAlign: TextAlign.start,
        ),
        const SizedBox(height: 10.0),
        TextFormField(
          controller: controller,
          obscureText: show,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(
                color: Color(0xff0C3A30),
                width: 1.0,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(
                color: Color(0xff0C3A30),
                width: 1.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(
                color: Color(0xff0C3A30),
                width: 1.0,
              ),
            ),
            suffixIcon: Padding(
                padding: const EdgeInsetsDirectional.only(end: 2.0),
                child: IconButton(
                  onPressed: onPressed as void Function()?,
                  icon: Icon(
                    icon,
                    color: Colors.black,
                    size: 24,
                  ),
                )),
          ),
        ),
      ],
    );
  }
}
