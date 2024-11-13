import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:online_shop/shared/theme/app_colors.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: ListView(
        // padding: EdgeInsets.symmetric(horizontal: 20.w),
        children: [
          20.verticalSpace,
          SizedBox(height: MediaQuery.of(context).padding.top),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Text(
              'We have Prepared new Products for you',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24.sp,
                color: AppColors.white,
              ),
            ),
          ),
          10.verticalSpace,
          SizedBox(
            width: double.maxFinite,
            height: 40.h,
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 10.r),
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.r),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 5.r,
                        height: 5.r,
                        decoration: const BoxDecoration(
                          color: AppColors.white,
                        ),
                      ),
                      5.horizontalSpace,
                      Text(
                        'All',
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
