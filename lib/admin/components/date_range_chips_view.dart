import 'package:avahan/utils/extensions.dart';
import 'package:avahan/utils/utils.dart';
import 'package:flutter/material.dart';

class DateRangeChipsView extends StatelessWidget {
  const DateRangeChipsView({super.key, required this.dateRange});

  final ValueNotifier<DateTimeRange> dateRange;
  @override
  Widget build(BuildContext context) {
    final map = Utils.dateTimeRanges;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ...map.entries.map(
          (e) => ChoiceChip(
            label: Text(e.key),
            selected: dateRange.value == e.value,
            onSelected: (v) => dateRange.value = e.value,
          ),
        ),
        ChoiceChip(
          label: Text(
              "${dateRange.value.start.dateMonth}-${dateRange.value.end.dateMonth}"),
          selected: map.entries
              .where((element) => element.value == dateRange.value)
              .isEmpty,
          onSelected: (v) async {
            final picked = await showDateRangePicker(
              context: context,
              firstDate: DateTime(2021),
              lastDate: DateTime.now(),
            );
            if (picked != null) {
              dateRange.value = DateTimeRange(
                start: picked.start,
                end: picked.end.add(const Duration(days: 1)).subtract(
                      const Duration(milliseconds: 1),
                    ),
              );
            }
          },
        ),
      ],
    );
  }
}
