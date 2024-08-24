// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:avahan/utils/extensions.dart';

class LargeAuthViewWrapper extends ConsumerWidget {
  const LargeAuthViewWrapper({super.key, required this.page});

  final Widget page;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: context.scheme.surface,
      child: Container(
        color: context.scheme.surfaceVariant.withOpacity(0.5),
        child: Center(
          child: Container(
            height: context.large ? 574 : null,
            width: context.large ? 947 : null,
            decoration: BoxDecoration(
              color: context.scheme.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(blurRadius: 24, color: context.scheme.outlineVariant)
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  if (context.large) ...[
                    const Expanded(child: AuthCarouselView()),
                    const SizedBox(width: 16),
                  ],
                  Expanded(child: page),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AuthCarouselView extends HookWidget {
  const AuthCarouselView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final index = useState(0);
    return Stack(
      children: [
        // CarouselSlider(
        //   items: [
        //     ...[Assets.onboard1, Assets.onboard2].map(
        //       (e) => ClipRRect(
        //         borderRadius: BorderRadius.circular(8),
        //         child: SvgPicture.asset(
        //           e,
        //           fit: BoxFit.cover,
        //         ),
        //       ),
        //     ),
        //   ],
        //   options: CarouselOptions(
        //       height: 574,
        //       viewportFraction: 1,
        //       autoPlay: true,
        //       autoPlayInterval: const Duration(seconds: 5),
        //       autoPlayAnimationDuration: const Duration(milliseconds: 800),
        //       autoPlayCurve: Curves.easeInOut,
        //       enlargeCenterPage: true,
        //       scrollDirection: Axis.horizontal,
        //       onPageChanged: (i, r) {
        //         index.value = i;
        //       }),
        // ),
        Positioned(
          bottom: 16,
          right: 0,
          left: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [0, 1]
                .map(
                  (e) => Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: CircleAvatar(
                      radius: 6,
                      backgroundColor: e == index.value
                          ? context.scheme.primary
                          : context.scheme.surface,
                    ),
                  ),
                )
                .toList(),
          ),
        )
      ],
    );
  }
}
