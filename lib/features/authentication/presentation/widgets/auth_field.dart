// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ignore: must_be_immutable
class AuthField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool obsecure;
  final FormFieldValidator<String>? validator;
  final Function(String)? onChanged;
  Widget? suffixIcon;
  Widget? prefixIcon;
  List<TextInputFormatter>? inputFormatters;
  TextInputType? textInputType;

  AuthField({
    super.key,
    required this.hintText,
    required this.controller,
    this.obsecure = false,
    required this.validator,
    this.onChanged,
    this.suffixIcon,
    this.prefixIcon,
    this.inputFormatters,
    this.textInputType,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obsecure,
      validator: validator,
      keyboardType: textInputType,
      inputFormatters: inputFormatters,
      onChanged: onChanged,
      style:  Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 14), 
      decoration: InputDecoration(
        hintText: hintText,
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        isDense: true, 
        contentPadding:
            const EdgeInsets.symmetric(vertical: 14, horizontal: 12), 
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
