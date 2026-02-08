import 'package:examify/core/themes/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        width: double.infinity,
        height: 55.h,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.red.withAlpha((255 * .3).toInt()),
          ),
          color: Colors.red.withAlpha((255 * .1).toInt()),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout, color: Color(0xffFF6467)),
            SizedBox(width: 10),
            Text(
              'Log Out',
              style: AppTextStyles.white16w400.copyWith(
                color: Color(0xffFF6467),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
