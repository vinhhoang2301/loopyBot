import 'package:final_project/consts/app_color.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    this.obscureText = false,
    this.hintText = '',
    this.errorText,
    this.focusNode,
    this.prefixIcon,
    this.maxLines,
  });

  final TextEditingController controller;
  final bool obscureText;

  final String? hintText;
  final String? errorText;
  final FocusNode? focusNode;
  final IconData? prefixIcon;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: errorText != null ? Colors.red : AppColors.backgroundColor2,
              width: 1.5,
            ),
          ),
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            obscureText: obscureText,
            style: const TextStyle(
              color: AppColors.defaultTextColor,
            ),
            decoration: InputDecoration(
              hintText: hintText,
              prefixIcon: prefixIcon == null
                  ? null
                  : Icon(
                      prefixIcon,
                      color: AppColors.primaryColor,
                    ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: AppColors.primaryColor,
                    width: 1.5,
                  ),
                )
            ),
          ),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 12),
            child: Text(
              errorText!,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }
}
