import 'package:flutter/material.dart';

import '../theme/app_colors.dart';



/// 正方形图片外框：浅底 + 金黄描边；[inset] 避免贴边与描边冲突。

class FramedThumbnail extends StatelessWidget {

  const FramedThumbnail({

    super.key,

    required this.size,

    required this.child,

    this.backgroundColor,

    this.borderRadius = 8,

    this.inset = 0,

    this.extraPadding = EdgeInsets.zero,

  });



  final double size;

  final Widget child;

  final Color? backgroundColor;

  final double borderRadius;

  final double inset;

  final EdgeInsets extraPadding;



  @override

  Widget build(BuildContext context) {

    final innerRadius = (borderRadius - 1).clamp(0.0, borderRadius);

    final pad = EdgeInsets.all(inset).add(extraPadding);



    return SizedBox.square(

      dimension: size,

      child: DecoratedBox(

        decoration: BoxDecoration(

          color: backgroundColor ?? AppColors.surfaceInset,

          borderRadius: BorderRadius.circular(borderRadius),

          border: Border.all(

            color: AppColors.gold.withValues(alpha: 0.85),

            width: 1.5,

          ),

        ),

        child: ClipRRect(

          borderRadius: BorderRadius.circular(innerRadius),

          child: Padding(padding: pad, child: child),

        ),

      ),

    );

  }

}


