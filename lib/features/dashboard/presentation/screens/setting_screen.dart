import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:online_shop/features/authentication/presentation/providers/auth_providers.dart';
import 'package:online_shop/routes/app_route.dart';
import 'package:online_shop/shared/constants/app_svg.dart';
import 'package:online_shop/shared/theme/app_colors.dart';
import 'package:online_shop/shared/widgets/app_button.dart';
import 'package:online_shop/shared/widgets/custom_image.dart';

class SettingScreen extends ConsumerStatefulWidget {
  const SettingScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<SettingScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final state = ref.watch(loginStateNotifierProvider) as LoggedInState;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Settings',
          style: TextStyle(
            color: AppColors.white,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        bottom: true,
        child: ListView(
          children: [
            ListTile(
              onTap: () {
                Navigator.pushNamed(context, AppRouter.profile);
              },
              title: const Text(
                'User Profile',
                style: TextStyle(
                  color: AppColors.white,
                ),
              ),
              subtitle: const Text(
                'Edit Profile Information',
                style: TextStyle(
                  color: AppColors.white,
                ),
              ),
              trailing: CustomImage(
                AppSvg.personOutline,
                width: 20.w,
                color: AppColors.white,
              ),
            ),
            5.verticalSpace,
            const Divider(color: AppColors.lightGrey),
            5.verticalSpace,
            ListTile(
              onTap: logout,
              title: const Text(
                'Logout',
                style: TextStyle(
                  color: AppColors.white,
                ),
              ),
              trailing: CustomImage(
                AppSvg.logout,
                width: 20.w,
                color: AppColors.white,
              ),
            ),
            5.verticalSpace,
            const Divider(color: AppColors.lightGrey),
            5.verticalSpace,
          ],
        ),
      ),
    );
  }

  void logout() async {
    final bool shouldLogout = await showDialog<bool>(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Logout?'),
                content: const Text(
                  'Are you sure you want to logout from your account',
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
                  ),
                  SizedBox(
                    width: 100.w,
                    child: AppButton(
                        text: 'Logout',
                        onTap: () {
                          Navigator.of(context).pop(true);
                        }),
                  )
                ],
              );
            }) ??
        false;

    if (shouldLogout) {
      ref.read(loginStateNotifierProvider.notifier).logout();
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushNamedAndRemoveUntil(
        AppRouter.login,
        (routes) => routes.isFirst,
      );
    }
  }
}
