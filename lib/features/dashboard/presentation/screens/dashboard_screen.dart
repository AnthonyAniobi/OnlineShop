import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:online_shop/features/dashboard/presentation/providers/dashboard_state_provider.dart';
import 'package:online_shop/features/dashboard/presentation/providers/state/dashboard_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:online_shop/features/dashboard/presentation/screens/home_screen.dart';
import 'package:online_shop/features/dashboard/presentation/widgets/navbar_icon.dart';
import 'package:online_shop/features/profile/presentation/screens/profile_screen.dart';
import 'package:online_shop/shared/constants/app_svg.dart';
import 'package:online_shop/shared/services/rest_service.dart';
import 'package:online_shop/shared/theme/app_colors.dart';
import 'package:online_shop/shared/widgets/custom_image.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();

  static Route<DashboardScreen> route(RouteSettings routeSettings) {
    return MaterialPageRoute(
      builder: (context) {
        return const DashboardScreen();
      },
    );
  }
}

class _DashboardScreenState extends ConsumerState<DashboardScreen>
    with SingleTickerProviderStateMixin {
  final scrollController = ScrollController();
  final TextEditingController searchController = TextEditingController();
  late final StreamSubscription _errorStream;
  late TabController tabController;
  int tabIndex = 0;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 4, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = ref.watch(restServiceProvider);
      state.errorStream.listen((event) {
        // listen for unauthorized api requests and once this occurs the token has expired,
        // so, Logout from the device move to home page
        if (event.statusCode == 401) {}
      });
    });
  }

  @override
  void dispose() {
    _errorStream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(dashboardNotifierProvider);

    // ref.listen(
    //   dashboardNotifierProvider.select((value) => value),
    //   ((DashboardState? previous, DashboardState next) {
    //     //show Snackbar on failure
    //   }),
    // );
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: TabBarView(
              controller: tabController,
              children: <Widget>[
                const HomeScreen(),
                Container(),
                Container(),
                const ProfileScreen(),
              ],
              //controller: _tabController,
            ),
          ),
          Positioned(
            bottom: 20.h,
            left: 20.w,
            right: 20.w,
            child: Container(
              height: 60.h,
              padding: EdgeInsets.symmetric(horizontal: 10.r),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                color: AppColors.darkGrey,
              ),
              child: Row(
                children: [
                  _navbarIcon(0, AppSvg.homeFilled, AppSvg.homeOutline),
                  _navbarIcon(
                      1, AppSvg.shoppingBagFilled, AppSvg.shoppingBagOutline),
                  _navbarIcon(2, AppSvg.heartFilled, AppSvg.heartOutline),
                  _navbarIcon(3, AppSvg.settingsFilled, AppSvg.settingsOutline),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _navbarIcon(int index, String filledIcon, String outlinedIcon) {
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            tabIndex = index;
          });
          tabController.animateTo(index);
        },
        child: NavbarIcon(
            selected: index == tabIndex,
            outlinedIcon: outlinedIcon,
            filledIcon: filledIcon),
      ),
    );
  }
}
