
import 'package:examify/core/themes/colors.dart';
import 'package:examify/core/themes/text_styles.dart';
import 'package:flutter/material.dart';

class ExamCardState extends StatelessWidget {
  const ExamCardState({super.key, required this.isLive});
  final bool isLive;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(0),
      decoration: BoxDecoration(
        color: isLive ? AppColors.greenAlpha10 : AppColors.white5,
        border: Border.all(
          color: isLive ? AppColors.greenBorder : AppColors.white10,
        ),
        borderRadius: BorderRadius.circular(16),
      ),

      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        child: isLive
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CircleAvatar(backgroundColor: Colors.green, radius: 5),
                  SizedBox(width: 5),
                  Text(
                    'Live',
                    style: AppTextStyles.blue14w400.copyWith(
                      color: Colors.green,
                    ),
                  ),
                ],
              )
            : Text('Scheduled', style: AppTextStyles.whit14w400alpha60),
      ),
    );
  }
}
