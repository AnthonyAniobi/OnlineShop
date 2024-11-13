import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:online_shop/features/dashboard/presentation/providers/favorite_state_provider.dart';
import 'package:online_shop/shared/app_utils.dart';
import 'package:online_shop/shared/constants/app_svg.dart';
import 'package:online_shop/shared/domain/models/product_model.dart';
import 'package:online_shop/shared/globals.dart';
import 'package:online_shop/shared/theme/app_colors.dart';
import 'package:online_shop/shared/widgets/app_button.dart';
import 'package:online_shop/shared/widgets/custom_image.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  const ProductDetailScreen({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProductDetailScreenState();

  static Route<ProductDetailScreen> route(RouteSettings routeSettings) {
    return MaterialPageRoute(
      builder: (context) {
        return ProductDetailScreen(
          product: routeSettings.arguments as Product,
        );
      },
    );
  }
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  int imageIndex = 0;
  late FlutterCarouselController controller;

  @override
  void initState() {
    super.initState();
    controller = FlutterCarouselController();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final favoriteState = ref.watch(favoriteStateProvider);

    return Scaffold(
      body: Stack(
        children: [
          AnimatedSwitcher(
            duration: kDuration500Mil,
            child: backgroundImage(),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            top: 0,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: SafeArea(
                bottom: false,
                child: Column(
                  children: [
                    10.verticalSpace,
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.r),
                      child: Row(
                        children: [
                          const AppBackButton(),
                          const Spacer(),
                          favoriteButton(favoriteState),
                        ],
                      ),
                    ),
                    10.verticalSpace,
                    carouselWidget(),
                    20.verticalSpace,
                    Expanded(
                      child: Container(
                        constraints: BoxConstraints(maxHeight: 200.h),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20.r),
                          ),
                        ),
                        child: ListView(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.r,
                            vertical: 20.h,
                          ),
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    widget.product.title,
                                    style: TextStyle(fontSize: 24.sp),
                                  ),
                                ),
                                20.horizontalSpace,
                                Text(
                                  AppUtils.formatCurrency(widget.product.price),
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            // 10.verticalSpace,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  'Category: ',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: AppColors.darkGrey,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                10.horizontalSpace,
                                Column(
                                  children: [
                                    CustomImage(
                                      widget.product.category.image,
                                      borderRadius: BorderRadius.circular(15.r),
                                      width: 30.r,
                                      height: 30.r,
                                    ),
                                    Text(
                                      widget.product.category.name,
                                      style: TextStyle(
                                          fontSize: 12.sp,
                                          color: AppColors.black),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            10.verticalSpace,
                            Text(
                              widget.product.description,
                              style: TextStyle(fontSize: 14.sp),
                            ),
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

  Widget favoriteButton(Set<int> favorites) {
    bool selected = favorites.contains(widget.product.id);
    return InkWell(
      onTap: () {
        final id = widget.product.id;
        if (selected) {
          ref.read(favoriteStateProvider.notifier).removeProductId(id);
        } else {
          ref.read(favoriteStateProvider.notifier).addProductId(id);
        }
      },
      child: Container(
        height: 40.r,
        width: 40.r,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.darkGrey.withOpacity(0.5),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: CustomImage(
          selected ? AppSvg.heartFilled : AppSvg.heartOutline,
          width: 20.r,
          color: selected ? AppColors.error : AppColors.white,
        ),
      ),
    );
  }

  Widget carouselWidget() {
    return FlutterCarousel(
      options: FlutterCarouselOptions(
          height: 0.4.sh,
          viewportFraction: 0.8,
          enlargeCenterPage: true,
          showIndicator: false,
          slideIndicator: CircularSlideIndicator(),
          onPageChanged: (idx, reason) {
            setState(() {
              imageIndex = idx;
            });
          }),
      items: widget.product.images.map((img) {
        return Builder(
          builder: (BuildContext context) {
            return CustomImage(
              fixImage(img),
              fit: BoxFit.cover,
              borderRadius: BorderRadius.circular(10.r),
            );
          },
        );
      }).toList(),
    );
  }

  String fixImage(String imgUrl) {
    RegExp pattern = RegExp(r'[\[\]]|" and "');
    return imgUrl.replaceAll(pattern, '');
  }

  Widget backgroundImage() {
    return SizedBox(
      width: 1.sw,
      height: 1.sh,
      child: CustomImage(
        fixImage(widget.product.images[imageIndex]),
        fit: BoxFit.cover,
      ),
    );
  }
}
