import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:online_shop/routes/app_route.dart';
import 'package:online_shop/shared/constants/app_image.dart';
import 'package:online_shop/shared/globals.dart';
import 'package:online_shop/shared/theme/app_colors.dart';
import 'package:online_shop/shared/widgets/app_button.dart';

class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  static Route<OnboardingScreen> route(RouteSettings routeSettings) {
    return MaterialPageRoute(
      builder: (context) {
        return const OnboardingScreen();
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            bottom: 0,
            right: 0,
            left: 0,
            child: Opacity(
              opacity: 0.8,
              child: Hero(
                tag: ONBOARDING_HERO_TAG,
                child: Image.asset(
                  AppImage.onboarding,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 10.h,
            left: 10.w,
            right: 10.w,
            child: Container(
              padding: EdgeInsets.all(
                35.r,
              ),
              decoration: BoxDecoration(
                color: AppColors.white.withOpacity(0.85),
                borderRadius: BorderRadius.circular(30.r),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Find Everything you need for your daily lives',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 22.sp,
                    ),
                  ),
                  8.verticalSpace,
                  Text(
                    'Buy, store, trade, exchange, learn and earn trading with a single app.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 12.sp,
                    ),
                  ),
                  30.verticalSpace,
                  AppButton(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, AppRouter.login);
                    },
                    text: 'Get Started',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
