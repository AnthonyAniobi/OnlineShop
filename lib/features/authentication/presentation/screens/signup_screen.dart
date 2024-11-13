import 'package:file_picker/file_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:online_shop/features/authentication/presentation/providers/auth_providers.dart';
import 'package:online_shop/features/authentication/presentation/providers/state/login_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:online_shop/features/authentication/presentation/providers/state/signup_state.dart';
import 'package:online_shop/features/authentication/presentation/widgets/auth_field.dart';
import 'package:online_shop/routes/app_route.dart';
import 'package:online_shop/shared/constants/app_image.dart';
import 'package:online_shop/shared/globals.dart';
import 'package:online_shop/shared/services/form_validator.dart';
import 'package:online_shop/shared/theme/app_colors.dart';
import 'package:online_shop/shared/widgets/app_button.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignupScreenState();

  static Route<SignupScreen> route(RouteSettings routeSettings) {
    return MaterialPageRoute(
      builder: (context) {
        return const SignupScreen();
      },
    );
  }
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  TextEditingController emailCntrl = TextEditingController();
  TextEditingController nameCntrl = TextEditingController();
  TextEditingController passwordCntrl = TextEditingController();
  final GlobalKey<FormState> formState = GlobalKey();

  @override
  void dispose() {
    passwordCntrl.dispose();
    emailCntrl.dispose();
    nameCntrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(signupStateNotifierProvider);
    ref.listen(
      signupStateNotifierProvider.select((value) => value),
      ((previous, current) {
        //show Snackbar on failure
        if (current is AccountCreatedState) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Account Created Successfully'),
            ),
          );

          Navigator.of(context).pushNamedAndRemoveUntil(
            AppRouter.login,
            (route) => route.isFirst,
          );
        } else if (current.status.isFailed) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(current.error?.message ?? ''),
            ),
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
                              'Create an account',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 22.sp,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            8.verticalSpace,
                            Text(
                              'You are a step away from a world of wonder',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.darkGrey,
                                fontSize: 14.sp,
                              ),
                            ),
                            30.verticalSpace,
                            AppFormField(
                              label: 'Name',
                              controller: nameCntrl,
                              validator: FormValidator.name,
                            ),
                            20.verticalSpace,
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
                              text: 'Signup',
                              status: state.status.isLoading
                                  ? ButtonStatus.loading
                                  : ButtonStatus.active,
                              onTap: signup,
                            ),
                            20.verticalSpace,
                            RichText(
                              text: TextSpan(
                                text: 'Already have an account?',
                                children: [
                                  TextSpan(
                                    text: ' Login ',
                                    style: const TextStyle(
                                      color: AppColors.blue,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = signin,
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
    Navigator.of(context).pushReplacementNamed(AppRouter.login);
  }

  void signup() async {
    if (formState.currentState?.validate() ?? false) {
      final result = await showDialog<bool>(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Please Pick an Image'),
                  content: const Text(
                    'A profile image is required for account registration',
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
                          text: 'Pick Image',
                          onTap: () {
                            Navigator.of(context).pop(true);
                          }),
                    )
                  ],
                );
              }) ??
          false;
      if (result) {
        final file = await pickFile();
        if (file != null) {
          ref.read(signupStateNotifierProvider.notifier).createAccount(
                emailCntrl.text,
                passwordCntrl.text,
                nameCntrl.text,
                file,
              );
        }
      }
    }
  }

  Future<PlatformFile?> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['png', 'jpg', 'jpeg'],
    );

    // User canceled the picker
    if (result == null) return null;

    // check for large file sizes
    final pickedImage = result.files.first;
    if (pickedImage.size >= 10485760) {
      Fluttertoast.showToast(msg: "Your File's size should be less than 10MB.");
      return null;
    } else {
      return pickedImage;
    }
  }
}
