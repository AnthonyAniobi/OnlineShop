import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:online_shop/features/authentication/presentation/widgets/auth_field.dart';
import 'package:online_shop/features/authentication/presentation/providers/auth_providers.dart';
import 'package:online_shop/features/authentication/presentation/providers/state/login_state.dart';
import 'package:online_shop/shared/constants/app_svg.dart';
import 'package:online_shop/shared/services/form_validator.dart';
import 'package:online_shop/shared/theme/app_colors.dart';
import 'package:online_shop/shared/widgets/app_button.dart';
import 'package:online_shop/shared/widgets/custom_image.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileScreenState();

  static Route<ProfileScreen> route(RouteSettings routeSettings) {
    return MaterialPageRoute(
      builder: (context) {
        return const ProfileScreen();
      },
    );
  }
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  TextEditingController emailCntrl = TextEditingController();
  TextEditingController nameCntrl = TextEditingController();
  TextEditingController passwordCntrl = TextEditingController();
  final GlobalKey<FormState> formState = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = ref.watch(loginStateNotifierProvider) as LoggedInState;
      emailCntrl.text = state.user?.email ?? '';
      nameCntrl.text = state.user?.name ?? '';
      passwordCntrl.text = state.user?.password ?? '';
      setState(() {});
    });
  }

  @override
  void dispose() {
    passwordCntrl.dispose();
    emailCntrl.dispose();
    nameCntrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(loginStateNotifierProvider) as LoggedInState;
    ref.listen(
      signupStateNotifierProvider.select((value) => value),
      ((previous, current) {
        //show Snackbar on failure
        if (current is LoggedInState) {
          if (current.status.isSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Profile Updated successfully'),
              ),
            );
          } else if (current.status.isFailed) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(current.error?.message ?? ''),
              ),
            );
          }
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
              10.verticalSpace,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.r),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AppBackButton(),
                    const Spacer(),
                    SizedBox(
                      width: 150.r,
                      height: 150.r,
                      child: Stack(
                        children: [
                          Container(
                            width: 150.r,
                            height: 150.r,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: NetworkImage(state.user?.avatar ?? ''),
                                fit: BoxFit.cover,
                              ),
                              border: Border.all(
                                color: AppColors.white,
                                width: 2,
                              ),
                              color: AppColors.white,
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: InkWell(
                              onTap: editProfileImage,
                              child: const CircleAvatar(
                                backgroundColor: AppColors.white,
                                child: CustomImage(
                                  AppSvg.edit,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    40.horizontalSpace,
                  ],
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
    if (formState.currentState?.validate() ?? false) {
      ref.read(loginStateNotifierProvider.notifier).updateUserData(
            email: emailCntrl.text,
            password: passwordCntrl.text,
            name: nameCntrl.text,
          );
    }
  }

  void editProfileImage() async {
    final result = await showDialog<bool>(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Please Pick an Image'),
                content: const Text(
                  'pick an image from your device',
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
        ref.read(loginStateNotifierProvider.notifier).updateUserImage(
              file: file,
            );
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
