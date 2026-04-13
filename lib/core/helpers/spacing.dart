import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Reusable vertical spacers
SizedBox verticalSpace(double height) => SizedBox(height: height.h);

/// Reusable horizontal spacers
SizedBox horizontalSpace(double width) => SizedBox(width: width.w);

const SizedBox verticalSpace8 = SizedBox(height: 8);
const SizedBox verticalSpace12 = SizedBox(height: 12);
const SizedBox verticalSpace16 = SizedBox(height: 16);
const SizedBox verticalSpace24 = SizedBox(height: 24);
const SizedBox verticalSpace32 = SizedBox(height: 32);

const SizedBox horizontalSpace8 = SizedBox(width: 8);
const SizedBox horizontalSpace12 = SizedBox(width: 12);
const SizedBox horizontalSpace16 = SizedBox(width: 16);
