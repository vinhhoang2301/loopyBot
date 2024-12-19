import 'package:final_project/consts/app_color.dart';
import 'package:flutter/material.dart';

class MaterialButtonCustomWidget extends StatelessWidget {
  const MaterialButtonCustomWidget({
    super.key,
    required this.onPressed,
    this.title,
    this.padding = const EdgeInsets.all(0),
    this.buttonStyle,
    this.content,
    this.isApproved = true,
    this.isDenied = false,
  });

  final String? title;
  final Widget? content;
  final Function() onPressed;

  final EdgeInsets? padding;
  final BoxDecoration? buttonStyle;
  final bool? isApproved;
  final bool? isDenied;

  @override
  Widget build(BuildContext context) {
    var titleStyle = TextStyle(
      color: isApproved == true ? Colors.white : Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 16.0,
    );

    return MaterialButton(
      onPressed: onPressed,
      padding: EdgeInsets.zero,
      child: Container(
        padding: padding,
        decoration: buttonStyle ??
            BoxDecoration(
              color: isDenied == true
                  ? Colors.red
                  : isApproved == true
                      ? AppColors.primaryColor
                      : AppColors.deniedColor,
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
