import 'package:flutter/material.dart';


class ChatTextField extends StatelessWidget {
  final controller;
  final String hintText;
  final bool obscureText;
  final type;
  final icon;

  const ChatTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    required this.type,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 2),
      child: TextField(
        maxLines: 1,
        cursorColor: Theme.of(context).colorScheme.tertiary,
        keyboardType: type,
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 3),
            borderRadius: BorderRadius.circular(25.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 3),
            borderRadius: BorderRadius.circular(25.0),
          ),
          fillColor: Theme.of(context).colorScheme.primary,
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
          prefixIcon: Icon(icon, color: Theme.of(context).colorScheme.onPrimary,),
        ),
      ),
    );
  }
}
