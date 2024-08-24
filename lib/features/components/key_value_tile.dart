import 'package:avahan/utils/extensions.dart';
import 'package:flutter/material.dart';


class KeyValueTile extends StatelessWidget {
  const KeyValueTile(this.name, this.value,  {super.key,this.label});

  final String name;
  final String value;

  final Widget? label;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Flexible(
              child: Text(
                name,
                style:
                    context.style.titleSmall!.copyWith(color: context.scheme.outline),
              ),
            ),
            if(label!=null) ...[
              const SizedBox(width: 4),
              label!
            ],
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: context.style.titleMedium,
        ),
      ],
    );
  }
}
