import 'package:avahan/utils/extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TableBottomView extends StatelessWidget {
  const TableBottomView({
    super.key,
    required this.count,
    required this.page,
    required this.pageChanged,
  });

  final int count;
  final int page;
  final Function(int) pageChanged;

  @override
  Widget build(BuildContext context) {
    final max = count ~/ 10 + ((count % 10) != 0 ? 1 : 0);
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
              "Showing ${count >= page * 10 + 1 ? page * 10 + 1 : 0}-${((page + 1) * 10) < count ? (page + 1) * 10 : count} of $count Results"),
        ),
        const Spacer(),
        TextButton(
          onPressed: page > 0
              ? () {
                  pageChanged(page - 1);
                }
              : null,
          child: const Row(
            children: [
              Icon(Icons.keyboard_arrow_left_rounded),
              Text(
                'Previous',
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        SizedBox(
          height: 32,
          width: 32,
          // decoration: BoxDecoration(
          //   border: Border.all(color: context.scheme.outlineVariant),
          // ),
          child: TextFormField(
            key: ValueKey(page),
            initialValue: "${page + 1}",
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
            ),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            onFieldSubmitted: (value) {
              if (value.isNotEmpty) {
                final v = int.parse(value);
                pageChanged((v > max ? max : v)-1);
              }
            },
          ),
        ),
        const SizedBox(width: 8),
        Text(
          'out of $max',
          style: TextStyle(
            color: context.scheme.outline,
          ),
        ),
        const SizedBox(width: 16),
        TextButton(
          onPressed: count > (10 * (page + 1))
              ? () {
                  pageChanged(page + 1);
                }
              : null,
          child: const Row(
            children: [
              Text(
                'Next',
              ),
              Icon(Icons.keyboard_arrow_right_rounded),
            ],
          ),
        ),
      ],
    );
  }
}
