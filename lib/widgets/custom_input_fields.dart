import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    Key? key,
    required this.onSaved,
    required this.regularExpression,
    required this.hintText,
    required this.obscureText,
  }) : super(key: key);

  final Function(String) onSaved;
  final String regularExpression;
  final String hintText;
  final bool obscureText;

// TODO: Adicionar funcionalidade de break line quando mensagem for longa (ou quando o usuario clicar enter button)
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
          fillColor: const Color.fromRGBO(30, 29, 27, 1),
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Colors.white54,
          )),
      style: const TextStyle(
        color: Colors.white,
      ),
      cursorColor: Colors.white,
      obscureText: obscureText,
      onSaved: (_value) => onSaved(_value!),
      validator: (_value) => RegExp(regularExpression).hasMatch(_value!)
          ? null
          : 'Enter a valid value.',
    );
  }
}

// * Search Bar for Users Page
class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {Key? key,
      required this.onEditingComplete,
      required this.hintText,
      required this.obscureText,
      required this.controller,
      this.icon})
      : super(key: key);

  final Function(String) onEditingComplete;
  final String hintText;
  final bool obscureText;
  final TextEditingController controller;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      cursorColor: Colors.white,
      decoration: InputDecoration(
        fillColor: const Color.fromRGBO(30, 29, 37, 1),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Colors.white54,
        ),
        prefixIcon: Icon(
          icon,
          color: Colors.white54,
        ),
      ),
      onEditingComplete: () => onEditingComplete(controller.value.text),
      style: const TextStyle(color: Colors.white),
      obscureText: obscureText,
    );
  }
}
