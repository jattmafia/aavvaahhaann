import 'package:avahan/utils/assets.dart';
import 'package:avahan/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class EmptyTrackView extends StatelessWidget {
   const EmptyTrackView({super.key});

  @override
  Widget build(BuildContext context) {
    final labels = context.labels;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            Assets.defaultImage,
            height: 200,
          ),
          const SizedBox(
            height: 16,
          ),
          Text(
            labels.noTracksAvailable,
            style: context.style.titleLarge!.copyWith(
              color: context.scheme.outline.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}
