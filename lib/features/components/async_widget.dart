import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:avahan/utils/extensions.dart';

class AsyncWidget<T> extends StatelessWidget {
  const AsyncWidget({
    super.key,
    required this.value,
    required this.data,
    this.error,
    this.onRefresh,
    this.socketError,
  });
  final AsyncValue<T> value;
  final Widget Function(T data) data;
  final Widget? error;
  final Widget? socketError;
  final VoidCallback? onRefresh;
  @override
  Widget build(BuildContext context) {
    final labels = context.labels;
    return value.when(
      data: data,
      error: (e, s) {
        if (e is SocketException) {
          if(socketError != null){
            return socketError!;
          }
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.error_outline_rounded,
                  size: 56,
                  color: context.scheme.outline,
                ),
                const SizedBox(height: 16),
                Text(
                  e.message,
                  style: context.style.titleLarge!.copyWith(
                    color: context.scheme.outline,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (onRefresh != null) ...[
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      onRefresh?.call();
                    },
                    child: Text(labels.retry),
                  )
                ],
              ],
            ),
          );
        }
        return error ??
            Center(
              child: Text(
                "$e",
                style: TextStyle(
                  color: context.scheme.outline,
                ),
                textAlign: TextAlign.center,
              ),
            );
      },
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
