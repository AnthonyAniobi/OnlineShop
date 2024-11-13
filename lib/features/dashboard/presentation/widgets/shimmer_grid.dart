import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:online_shop/shared/theme/app_colors.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerGrid extends StatelessWidget {
  const ShimmerGrid({
    super.key,
    required this.length,
  });

  final int length;

  @override
  Widget build(BuildContext context) {
    return StaggeredGrid.count(
      crossAxisCount: 20,
      mainAxisSpacing: 10.r,
      crossAxisSpacing: 10.r,
      children: List.generate(length, (idx) => gridTile(idx)),
    );
  }

  StaggeredGridTile gridTile(int index) {
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
    return StaggeredGridTile.count(
      crossAxisCellCount: crossCellCount,
      mainAxisCellCount: mainCellCount,
      child: Shimmer.fromColors(
        baseColor: AppColors.shimmerBase,
        highlightColor: AppColors.shimmerHighlight,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            color: AppColors.shimmerBase,
          ),
        ),
      ),
      // child: widget(
      //   child: ,
      // ),
    );
  }
}
