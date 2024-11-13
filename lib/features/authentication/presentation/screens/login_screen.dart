import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:online_shop/features/authentication/presentation/providers/auth_providers.dart';
import 'package:online_shop/features/authentication/presentation/providers/state/login_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:online_shop/features/authentication/presentation/widgets/auth_field.dart';
import 'package:online_shop/routes/app_route.dart';
import 'package:online_shop/shared/constants/app_image.dart';
import 'package:online_shop/shared/globals.dart';
import 'package:online_shop/shared/services/form_validator.dart';
import 'package:online_shop/shared/theme/app_colors.dart';
import 'package:online_shop/shared/widgets/app_button.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();

  static Route<LoginScreen> route(RouteSettings routeSettings) {
    return MaterialPageRoute(
      builder: (context) {
        return const LoginScreen();
      },
    );
  }
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  TextEditingController emailCntrl = TextEditingController();
  TextEditingController passwordCntrl = TextEditingController();
  final GlobalKey<FormState> formState = GlobalKey();

  @override
  void dispose() {
    passwordCntrl.dispose();
    emailCntrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(loginStateNotifierProvider);
    ref.listen(
      loginStateNotifierProvider.select((value) => value),
      ((previous, current) {
        //show Snackbar on failure
        if (current is LoggedOutState) {
          if (current.status.isFailed) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(current.error?.message ?? ''),
              ),
            );
          }
        } else if (current is LoggedInState) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            AppRouter.dashboard,
            (route) => route.isFirst,
          );
        }
      }),
    );
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: Opacity(
              opacity: 0.3,
              child: Image.asset(
                AppImage.onboarding,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            top: 0,
            child: SafeArea(
              top: true,
              bottom: false,
              child: SingleChildScrollView(
                reverse: true,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20.r),
                      padding: EdgeInsets.all(4.r),
                      decoration: BoxDecoration(
                        color: AppColors.white.withOpacity(0.4),
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(10.r),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(20.r),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20.r),
                        ),
                      ),
                      child: Form(
                        key: formState,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            10.verticalSpace,
                            Text(
                              'Welcome Back',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 22.sp,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            8.verticalSpace,
                            Text(
                              'Enter your details below',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.darkGrey,
                                fontSize: 14.sp,
                              ),
                            ),
                            30.verticalSpace,
                            AppFormField(
                              label: 'Email',
                              controller: emailCntrl,
                              validator: FormValidator.email,
                            ),
                            20.verticalSpace,
                            AppFormField(
                              label: 'Password',
                              controller: passwordCntrl,
                              validator: FormValidator.password,
                            ),
                            30.verticalSpace,
                            AppButton(
                              text: 'Signin',
                              status: state.status.isLoading
                                  ? ButtonStatus.loading
                                  : ButtonStatus.active,
                              onTap: signin,
                            ),
                            20.verticalSpace,
                            RichText(
                              text: TextSpan(
                                text: 'Dont have an account?',
                                children: [
                                  TextSpan(
                                    text: ' Signup ',
                                    style: const TextStyle(
                                      color: AppColors.blue,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = signup,
                                  )
                                ],
                                style: TextStyle(
                                  color: AppColors.black,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ),
                            10.verticalSpace,
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void signin() {
    if (formState.currentState?.validate() ?? false) {
      ref.read(loginStateNotifierProvider.notifier).loginUser(
            emailCntrl.text,
            passwordCntrl.text,
          );
    }
  }

  void signup() {
    Navigator.of(context).pushReplacementNamed(AppRouter.signup);
  }
}
