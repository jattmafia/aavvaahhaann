// import 'package:flutter/material.dart';

// const green = Color(0xFF90FFC1);


// CustomColors lightCustomColors = const CustomColors(
//   sourceGreen: Color(0xFF90FFC1),
//   green: Color(0xFF006D44),
//   onGreen: Color(0xFFFFFFFF),
//   greenContainer: Color(0xFF8AF8BB),
//   onGreenContainer: Color(0xFF002111),
// );

// CustomColors darkCustomColors = const CustomColors(
//   sourceGreen: Color(0xFF90FFC1),
//   green: Color(0xFF6DDBA0),
//   onGreen: Color(0xFF003921),
//   greenContainer: Color(0xFF005232),
//   onGreenContainer: Color(0xFF8AF8BB),
// );



// /// Defines a set of custom colors, each comprised of 4 complementary tones.
// ///
// /// See also:
// ///   * <https://m3.material.io/styles/color/the-color-system/custom-colors>
// @immutable
// class CustomColors extends ThemeExtension<CustomColors> {
//   const CustomColors({
//     required this.sourceGreen,
//     required this.green,
//     required this.onGreen,
//     required this.greenContainer,
//     required this.onGreenContainer,
//   });

//   final Color? sourceGreen;
//   final Color? green;
//   final Color? onGreen;
//   final Color? greenContainer;
//   final Color? onGreenContainer;

//   @override
//   CustomColors copyWith({
//     Color? sourceGreen,
//     Color? green,
//     Color? onGreen,
//     Color? greenContainer,
//     Color? onGreenContainer,
//   }) {
//     return CustomColors(
//       sourceGreen: sourceGreen ?? this.sourceGreen,
//       green: green ?? this.green,
//       onGreen: onGreen ?? this.onGreen,
//       greenContainer: greenContainer ?? this.greenContainer,
//       onGreenContainer: onGreenContainer ?? this.onGreenContainer,
//     );
//   }

//   @override
//   CustomColors lerp(ThemeExtension<CustomColors>? other, double t) {
//     if (other is! CustomColors) {
//       return this;
//     }
//     return CustomColors(
//       sourceGreen: Color.lerp(sourceGreen, other.sourceGreen, t),
//       green: Color.lerp(green, other.green, t),
//       onGreen: Color.lerp(onGreen, other.onGreen, t),
//       greenContainer: Color.lerp(greenContainer, other.greenContainer, t),
//       onGreenContainer: Color.lerp(onGreenContainer, other.onGreenContainer, t),
//     );
//   }

//   /// Returns an instance of [CustomColors] in which the following custom
//   /// colors are harmonized with [dynamic]'s [ColorScheme.primary].
//   ///
//   /// See also:
//   ///   * <https://m3.material.io/styles/color/the-color-system/custom-colors#harmonization>
//   CustomColors harmonized(ColorScheme dynamic) {
//     return copyWith(
//     );
//   }
// }