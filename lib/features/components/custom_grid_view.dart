import 'package:flutter/material.dart';

class CustomGridView extends StatelessWidget {
  const CustomGridView({
    super.key,
    required this.children,
    this.shrinkWrap = false,
    this.padding,
    this.crossAxisCount = 2,
  });

  final List<Widget> children;
  final bool shrinkWrap;
  final EdgeInsets? padding;
  final int crossAxisCount;
  @override
  Widget build(BuildContext context) {
    final finalPadding = padding ?? const EdgeInsets.all(8);

    final child = Column(
      children: List.generate(
        (children.length ~/ crossAxisCount +
            (children.length % crossAxisCount > 0 ? 1 : 0)),
        (index) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(
              crossAxisCount,
              (i) => children.length > ((index * crossAxisCount) + i)
                  ? Expanded(child: children[(index * crossAxisCount) + i])
                  : const Spacer(),
            ),
          );
        },
      ),
    );

    return shrinkWrap
        ? Padding(
            padding: finalPadding,
            child: child,
          )
        : SingleChildScrollView(padding: finalPadding, child: child);
  }
}

class CustomHorizontalGridView extends StatelessWidget {
  const CustomHorizontalGridView({
    super.key,
    required this.children,
    this.shrinkWrap = false,
    this.padding,
    this.crossAxisCount = 2,
  });

  final List<Widget> children;
  final bool shrinkWrap;
  final EdgeInsets? padding;
  final int crossAxisCount;
  @override
  Widget build(BuildContext context) {
    final finalPadding = padding ?? const EdgeInsets.all(8);

    return SingleChildScrollView(
      padding: finalPadding,
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          (children.length ~/ crossAxisCount +
              (children.length % crossAxisCount > 0 ? 1 : 0)),
          (index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                crossAxisCount,
                (i) => children.length > ((index * crossAxisCount) + i)
                    ? children[(index * crossAxisCount) + i]
                    : const SizedBox(),
              ),
            );
          },
        ),
      ),
    );
  }
}
