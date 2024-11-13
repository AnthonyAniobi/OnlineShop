import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:online_shop/features/authentication/presentation/providers/auth_providers.dart';
import 'package:online_shop/features/authentication/presentation/providers/state/login_state.dart';
import 'package:online_shop/features/dashboard/presentation/providers/dashboard_state_provider.dart';
import 'package:online_shop/features/dashboard/presentation/widgets/shimmer_grid.dart';
import 'package:online_shop/features/dashboard/presentation/widgets/staggered_product_grid.dart';
import 'package:online_shop/routes/app_route.dart';
import 'package:online_shop/shared/theme/app_colors.dart';
import 'package:online_shop/shared/widgets/custom_image.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(dashboardNotifierProvider);
    final stateLogin = ref.watch(loginStateNotifierProvider);
    if (state.loadingState.isInitial) {
      ref.read(dashboardNotifierProvider.notifier).fetchProducts();
    }
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(dashboardNotifierProvider.notifier).fetchProducts();
        },
        child: ListView(
          // padding: EdgeInsets.symmetric(horizontal: 20.w),
          children: [
            SizedBox(height: MediaQuery.of(context).padding.top),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.r),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Builder(builder: (context) {
                    if (stateLogin is LoggedInState) {
                      return InkWell(
                        onTap: () {
                          // move to profile page
                          Navigator.pushNamed(context, AppRouter.profile);
                        },
                        child: CustomImage(
                          stateLogin.user?.avatar ?? '',
                          borderRadius: BorderRadius.circular(5.r),
                          fit: BoxFit.cover,
                          width: 35.r,
                          height: 35.r,
                        ),
                      );
                    } else {
                      return SizedBox(height: 35.r);
                    }
                  })
                ],
              ),
            ),
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
            10.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Builder(builder: (context) {
                if (state.loadingState.isLoading ||
                    state.loadingState.isInitial) {
                  return const ShimmerGrid(
                    length: 5,
                  );
                } else if (state.hasData) {
                  return StaggeredProductGrid(products: state.productList);
                } else {
                  return SizedBox(
                    height: 200.h,
                    child: Center(
                      child: Text(
                        state.message,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22.sp,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  );
                }
              }),
            ),
            10.verticalSpace,
          ],
        ),
      ),
    );
  }
}
