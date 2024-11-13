import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:online_shop/shared/theme/app_colors.dart';
import 'package:online_shop/shared/widgets/custom_image.dart';

class NavbarIcon extends StatelessWidget {
  const NavbarIcon({
    super.key,
    required this.selected,
    required this.outlinedIcon,
    required this.filledIcon,
  });

  final bool selected;
  final String outlinedIcon;
  final String filledIcon;

  @override
  Widget build(BuildContext context) {
    return CustomImage(
      selected ? filledIcon : outlinedIcon,
      color: AppColors.white,
      width: 25.r,
      height: 25.r,
    );
  }
}
