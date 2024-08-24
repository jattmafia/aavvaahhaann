import 'package:avahan/utils/extensions.dart';
import 'package:flutter/material.dart';

class DataStatusView extends StatelessWidget {
  const DataStatusView({
    super.key,
    this.createdBy,
    this.createdAt,
    this.updatedBy,
    this.updatedAt,
    this.type,
    this.size,
  });
  final int? createdBy;
  final DateTime? createdAt;
  final int? updatedBy;
  final DateTime? updatedAt;
  final String? type;
  final int? size;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.scheme.surfaceTint.withOpacity(0.05),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 2,
                    child: RichText(
                      text: TextSpan(
                        text: "File Type: ",
                        style: context.style.bodySmall
                            ?.copyWith(color: context.scheme.outline),
                        children: [
                          TextSpan(
                            text: type?.toString() ?? "Unknown",
                            style: context.style.bodySmall?.copyWith(
                              color: context.scheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        text: "Size: ",
                        style: context.style.bodySmall
                            ?.copyWith(color: context.scheme.outline),
                        children: [
                          /// byte to mb
                          TextSpan(
                            text: size != null
                                ? "${(size! / 1000000).toStringAsFixed(2)} MB"
                                : "Unknown",
                            style: context.style.bodySmall?.copyWith(
                              color: context.scheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 2,
                    child: RichText(
                      text: TextSpan(
                        text: "Created At: ",
                        style: context.style.bodySmall
                            ?.copyWith(color: context.scheme.outline),
                        children: [
                          TextSpan(
                            text: createdAt?.dateTimeLabel ?? "Admin",
                            style: context.style.bodySmall?.copyWith(
                              color: context.scheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        text: "By: ",
                        style: context.style.bodySmall
                            ?.copyWith(color: context.scheme.outline),
                        children: [
                          TextSpan(
                            text: createdBy?.toString() ?? "Admin",
                            style: context.style.bodySmall?.copyWith(
                              color: context.scheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: RichText(
                      text: TextSpan(
                        text: "Updated At: ",
                        style: context.style.bodySmall
                            ?.copyWith(color: context.scheme.outline),
                        children: [
                          TextSpan(
                            text: updatedAt?.dateTimeLabel ?? "",
                            style: context.style.bodySmall?.copyWith(
                              color: context.scheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        text: "By: ",
                        style: context.style.bodySmall
                            ?.copyWith(color: context.scheme.outline),
                        children: [
                          TextSpan(
                            text: updatedBy?.toString() ?? "",
                            style: context.style.bodySmall?.copyWith(
                              color: context.scheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
