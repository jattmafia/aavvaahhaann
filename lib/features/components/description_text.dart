import 'package:avahan/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

class DescriptionText extends StatelessWidget {
  const DescriptionText(this.value, {super.key, this.style});
  final String value;
  final TextStyle? style;
  @override
  Widget build(BuildContext context) {
    final labels = context.labels;
    return ReadMoreText(
      value,
      trimLines: 3,
      trimLength: 150,
      colorClickableText: context.scheme.primary,
      trimMode: TrimMode.Length,
      trimCollapsedText: labels.showMore,
      trimExpandedText: labels.showLess,
      moreStyle: context.style.labelMedium?.copyWith(
        color: context.scheme.primary,
      ),
      lessStyle: context.style.labelMedium?.copyWith(
        color: context.scheme.primary,
      ),
    );
  }
}
