import 'package:flutter/material.dart';

/// 列表行：左侧固定正方形槽，避免 [ListTile] 压扁 leading。
class WikiListRow extends StatelessWidget {
  const WikiListRow({
    super.key,
    required this.leadingSize,
    required this.leading,
    required this.title,
    this.subtitle,
    this.extraLines = const [],
    this.onTap,
  });

  final double leadingSize;
  final Widget leading;
  final Widget title;
  final Widget? subtitle;
  final List<Widget> extraLines;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox.square(
                dimension: leadingSize,
                child: leading,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    title,
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      subtitle!,
                    ],
                    for (final line in extraLines) ...[
                      const SizedBox(height: 2),
                      line,
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
