import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:online_shop/routes/app_route.dart';
import 'package:online_shop/shared/domain/models/product_model.dart';
import 'package:online_shop/shared/theme/app_colors.dart';
import 'package:online_shop/shared/widgets/custom_image.dart';

class StaggeredProductGrid extends StatelessWidget {
  const StaggeredProductGrid({
    super.key,
    required this.products,
  });

  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    return StaggeredGrid.count(
      crossAxisCount: 20,
      mainAxisSpacing: 10.r,
      crossAxisSpacing: 10.r,
      children: List.generate(products.length, (idx) => gridTile(idx, context)),
    );
  }

  StaggeredGridTile gridTile(int index, BuildContext context) {
    int cellIdx = index % 4;
    int crossCellCount = 10;
    int mainCellCount;
    if (cellIdx == 0) {
      mainCellCount = 10;
    } else if (cellIdx == 1) {
      mainCellCount = 15;
    } else if (cellIdx == 2) {
      mainCellCount = 15;
    } else {
      mainCellCount = 10;
    }
    final prod = products[index];
    return StaggeredGridTile.count(
      crossAxisCellCount: crossCellCount,
      mainAxisCellCount: mainCellCount,
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            AppRouter.productDetail,
            arguments: prod,
          );
        },
        child: Stack(
          children: [
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.r),
                child: CustomImage(
                  fixImage(prod.images.first),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              left: 4.r,
              right: 4.r,
              bottom: 5.r,
              child: Container(
                color: AppColors.white.withOpacity(0.8),
                padding: EdgeInsets.all(4.r),
                child: Text(
                  prod.title,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String fixImage(String imgUrl) {
    RegExp pattern = RegExp(r'[\[\]]|" and "');

    return imgUrl.replaceAll(pattern, '');
  }
}
