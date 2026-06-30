import 'package:examify/core/themes/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextfield extends StatefulWidget {
  const CustomTextfield({
    super.key,
    this.prefixIcon,
    this.hintText,
    this.labelText,
    this.suffixIcon,
    this.isPassword = false,
    this.controller,
    this.validator,
    this.keyboardType,
    this.readOnly = false,
    this.onTap,
    this.inputFormatters,
    this.maxLines = 1,
  });

  final String? hintText;
  final String? labelText;
  final IconData? suffixIcon;
  final Widget? prefixIcon;
  final bool isPassword;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool readOnly;
  final VoidCallback? onTap;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLines;

  @override
  State<CustomTextfield> createState() => _CustomTextfieldState();
}

class _CustomTextfieldState extends State<CustomTextfield> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: Colors.white,
      cursorOpacityAnimates: true,
      cursorHeight: 20.h,
      controller: widget.controller,
      validator: widget.validator,
      obscureText: widget.isPassword ? _obscureText : false,
      readOnly: widget.readOnly,
      onTap: widget.onTap,
      inputFormatters: widget.inputFormatters,
      keyboardType: widget.keyboardType,
      maxLines: widget.maxLines,
      style: AppTextStyles.white16w400,
      decoration: InputDecoration(
        labelText: widget.labelText,
        labelStyle: AppTextStyles.white16w400.copyWith(
          color: Colors.white.withAlpha((25)),
        ),
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.isPassword
            ? IconButton(
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                icon: Icon(
                  _obscureText
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: Colors.white.withAlpha((255 * .4).round()),
                ),
              )
            : (widget.suffixIcon != null
                  ? Icon(
                      widget.suffixIcon,
                      color: Colors.white.withAlpha((255 * .4).round()),
                    )
                  : null),
        filled: true,
        fillColor: Colors.white.withAlpha((255 * .05).round()),
        hintText: widget.hintText,
        hintStyle: AppTextStyles.white16w400.copyWith(
          color: Colors.white.withAlpha((255 * .4).round()),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white.withAlpha((255 * .1).round()),
            width: 1.w,
          ),
          borderRadius: BorderRadius.circular(14.r),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white.withAlpha((255 * .1).round()),
            width: 1.w,
          ),
          borderRadius: BorderRadius.circular(14.r),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.blue, // Highlight color when focused
            width: 1.w,
          ),
          borderRadius: BorderRadius.circular(14.r),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 1.w),
          borderRadius: BorderRadius.circular(14.r),
        ),
      ),
    );
  }
}
