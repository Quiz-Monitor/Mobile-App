import 'package:examify/core/themes/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextfield extends StatefulWidget {
  const CustomTextfield({
    super.key,
    required this.hintText,
    this.suffixIcon,
    this.isPassword = false,
    this.controller,
    this.validator,
    this.keyboardType,
  });

  final String hintText;
  final IconData? suffixIcon;
  final bool isPassword;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;

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
      keyboardType: widget.keyboardType,
      style: AppTextStyles.white16w400,
      decoration: InputDecoration(
        
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
