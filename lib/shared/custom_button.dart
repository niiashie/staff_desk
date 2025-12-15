// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, sort_child_properties_last, use_super_parameters

import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final Widget? title;
  final double? width;
  final double? height;
  final Color? color;
  final Color? textColor;
  final bool isLoading;
  final Color? loadingColor;
  final Color? borderColors;
  final double? borderRadius;
  final double? elevation;
  final double? maxWidth;
  final VoidCallback? ontap;

  const CustomButton({
    Key? key,
    this.title,
    this.width,
    this.height = 60,
    this.color,
    this.ontap,
    this.borderRadius = 15,
    this.loadingColor = Colors.white,
    this.borderColors = Colors.transparent,
    this.isLoading = false,
    this.elevation = 0,
    this.textColor = Colors.white,
    this.maxWidth = 250,
  }) : super(key: key);

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: widget.color ?? Colors.white,
      elevation: widget.elevation!,
      borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius!)),
      child: InkWell(
        child: Container(
          width: widget.width,
          height: widget.height,
          constraints: BoxConstraints(maxWidth: widget.maxWidth!),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(widget.borderRadius!),
            ),
            border: Border.all(width: 1, color: widget.borderColors!),
          ),
          child: Center(
            child: widget.isLoading
                ? SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        widget.loadingColor!,
                      ),
                    ),
                  )
                : widget.title,
          ),
        ),
        onTap: widget.ontap,
      ),
    );
  }
}
