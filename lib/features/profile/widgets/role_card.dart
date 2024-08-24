import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:avahan/themes/app_colors.dart';
import 'package:avahan/utils/extensions.dart';

class RoleCard extends StatelessWidget {
  const RoleCard(
      {super.key,
      required this.image,
      required this.name,
      this.selected = false,
      this.onTap});

  final String name;
  final String image;
  final bool selected;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AspectRatio(
        aspectRatio: 5 / 6,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: selected
                  ? context.scheme.primary
                  : context.scheme.outlineVariant,
            ),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: SvgPicture.asset(
                        image,
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Text(
                      name,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Icon(
                  Icons.check_circle,
                  color: selected
                      ? AppColors.lightGreen
                      : context.scheme.outlineVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
