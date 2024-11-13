import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:online_shop/shared/theme/app_colors.dart';

enum ButtonStatus {
  disabled,
  loading,
  active;

  bool get isLoading => this == loading;
  bool get isActive => this == active;
  bool get isDisabled => this == disabled;
}

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.text,
    required this.onTap,
    this.status = ButtonStatus.active,
  });

  final String text;
  final ButtonStatus status;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(15.r),
      onTap: status.isActive ? onTap : null,
      child: Container(
        width: double.maxFinite,
        alignment: Alignment.center,
        height: 55,
        decoration: BoxDecoration(
          color: status.isDisabled ? AppColors.lightGrey : AppColors.black,
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: status.isLoading
            ? const SizedBox(
                height: 30,
                width: 30,
                child: CircularProgressIndicator(
                  color: AppColors.white,
                ),
              )
            : Text(
                text,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.white,
                ),
              ),
      ),
    );
  }
}
