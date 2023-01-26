import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  const CustomTextFormField({
    Key? key,
    required this.onSaved,
    required this.validator,
    required this.hintText,
    this.isSecret = false,
    this.keyboardType = TextInputType.text,
  }) : super(key: key);

  final Function(String) onSaved;
  final String? Function(String?)? validator;
  final String hintText;
  final bool isSecret;
  final TextInputType keyboardType;

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  Widget build(BuildContext context) {
    bool isObscure = false;
    setState(() {
      isObscure = widget.isSecret;
    });
    return TextFormField(
      keyboardType: widget.keyboardType,
      decoration: InputDecoration(
        prefix: widget.isSecret
            ? IconButton(
                onPressed: () {
                  setState(() {
                    isObscure = !isObscure;
                  });
                },
                icon: Icon(
                  isObscure
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
              )
            : null,
        fillColor: const Color.fromRGBO(30, 29, 27, 1),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        hintText: widget.hintText,
        hintStyle: const TextStyle(
          color: Colors.white54,
        ),
      ),
      style: const TextStyle(
        color: Colors.white,
      ),
      cursorColor: Colors.white,
      obscureText: isObscure,
      onSaved: (_value) => widget.onSaved(_value!),
      validator: (_value) => widget.validator!(_value),
    );
  }
}

// * Search Bar for Users Page
class CustomTextField extends StatelessWidget {
  const CustomTextField({
    Key? key,
    required this.onEditingComplete,
    required this.hintText,
    required this.obscureText,
    required this.controller,
    this.icon,
  }) : super(key: key);

  final Function(String) onEditingComplete;
  final String hintText;
  final bool obscureText;
  final TextEditingController controller;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.multiline,
      maxLines: null,
      obscureText: obscureText,
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
    );
  }
}
