import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:online_shop/shared/theme/app_colors.dart';
import 'package:shimmer/shimmer.dart';

class CustomImage extends StatelessWidget {
  final String image;
  final double? width;
  final double? height;
  final Color? color;
  final BoxFit fit;
  final Alignment alignment;
  final BorderRadiusGeometry borderRadius;

  const CustomImage(
    this.image, {
    super.key,
    this.width,
    this.height,
    this.color,
    this.fit = BoxFit.contain,
    this.borderRadius = BorderRadius.zero,
    this.alignment = Alignment.center,
  });

  @override
  Widget build(BuildContext context) {
    bool isNetwork = image.startsWith('http');
    bool isSvg = image.endsWith('svg');

    final errorWidget = Container(
      alignment: Alignment.center,
      child: Icon(
        Icons.broken_image_outlined,
        color: color,
      ),
    );

    final placehoderWidget = Shimmer.fromColors(
      baseColor: AppColors.shimmerBase,
      highlightColor: AppColors.shimmerHighlight,
      child: Container(
        width: width,
        height: height,
        color: AppColors.shimmerBase,
      ),
    );

    return ClipRRect(
      borderRadius: borderRadius,
      child: SizedBox(
        width: width,
        height: height,
        child: Builder(builder: (context) {
          switch ((isNetwork, isSvg)) {
            // svg network image
            case (true, true):
              return SvgPicture.network(
                image,
                width: width,
                height: height,
                fit: fit,
                alignment: alignment,
                placeholderBuilder: (_) => placehoderWidget,
                colorFilter: color != null
                    ? ColorFilter.mode(color!, BlendMode.srcIn)
                    : null,
              );
            // svg asset image
            case (false, true):
              return SvgPicture.asset(
                image,
                width: width,
                height: height,
                alignment: alignment,
                fit: fit,
                placeholderBuilder: (_) => placehoderWidget,
                colorFilter: color != null
                    ? ColorFilter.mode(color!, BlendMode.srcIn)
                    : null,
              );
            // image network
            case (true, false):
              return CachedNetworkImage(
                imageUrl: image,
                width: width,
                height: height,
                fit: fit,
                alignment: alignment,
                color: color,
                placeholder: (c, s) => placehoderWidget,
                errorWidget: (c, s, b) => errorWidget,
              );

            // image asset
            case (false, false):
              return Image.asset(
                image,
                width: width,
                height: height,
                fit: fit,
                color: color,
                alignment: alignment,
                errorBuilder: (c, e, s) => errorWidget,
              );
          }
        }),
      ),
    );
  }
}
