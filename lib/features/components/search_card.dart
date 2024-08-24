import 'package:avahan/utils/extensions.dart';
import 'package:flutter/material.dart';

class SearchCard extends StatelessWidget {
  const SearchCard({
    super.key,
    this.hint,
  });

  final String? hint;

  @override
  Widget build(BuildContext context) {
    final labels = context.labels;
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: context.scheme.surfaceTint.withOpacity(0.05),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          const AspectRatio(
            aspectRatio: 1,
            child: Icon(Icons.search),
          ),
          const SizedBox(width: 8),
          Text(
            hint ?? labels.search,
            style: context.style.titleMedium!
                .copyWith(color: context.scheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
