import 'package:file_picker/file_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:online_shop/features/authentication/presentation/providers/auth_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:online_shop/features/authentication/presentation/providers/state/signup_state.dart';
import 'package:online_shop/features/authentication/presentation/widgets/auth_field.dart';
import 'package:online_shop/routes/app_route.dart';
import 'package:online_shop/shared/constants/app_image.dart';
import 'package:online_shop/shared/globals.dart';
import 'package:online_shop/shared/services/form_validator.dart';
import 'package:online_shop/shared/theme/app_colors.dart';
import 'package:online_shop/shared/widgets/app_button.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
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
          Fluttertoast.showToast(msg: 'Account Created Successfully');
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
      body: SafeArea(
        top: true,
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: 150.r,
                height: 150.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  // image: DecorationImage(image: NetworkImage(state.)),
                  color: AppColors.white,
                ),
              ),
              20.verticalSpace,
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: 20.r,
                ),
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Form(
                  key: formState,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
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
                        text: 'Save Data',
                        status: state.status.isLoading
                            ? ButtonStatus.loading
                            : ButtonStatus.active,
                        onTap: saveData,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void saveData() {
    Navigator.of(context).pushReplacementNamed(AppRouter.login);
  }

  void saveProfile() async {
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
