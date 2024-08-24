// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SvgIcon extends StatelessWidget {
  const SvgIcon(this.value,{super.key,  this.color, this.size});

  final String value;
  final double? size;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    final _color = color ?? IconTheme.of(context).color;
    return SvgPicture.asset(
      value,
      colorFilter:
          _color != null ? ColorFilter.mode(_color, BlendMode.srcIn) : null,
      height: size ?? 24,
      width: size ?? 24,
    );
  }
}
