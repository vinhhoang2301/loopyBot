import 'package:final_project/consts/app_color.dart';
import 'package:flutter/material.dart';

class MaterialButtonCustomWidget extends StatelessWidget {
  const MaterialButtonCustomWidget({
    super.key,
    required this.onPressed,
    this.title,
    this.padding = const EdgeInsets.all(0),
    this.titleStyle = const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 16.0,
    ),
    this.buttonStyle,
    this.content,
  });

  final String? title;
  final Widget? content;
  final Function() onPressed;

  final EdgeInsets? padding;
  final TextStyle? titleStyle;
  final BoxDecoration? buttonStyle;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      padding: padding,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: buttonStyle ??
            BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(8.0),
            ),
        child: Center(
          child: content ??
              Text(
                title ?? 'No child',
                style: titleStyle,
              ),
        ),
      ),
    );
  }
}
