import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:image_picker/image_picker.dart';

class XFileView extends HookWidget {
  const XFileView(this.file, {super.key, this.fit, this.alignment});

  final XFile file;
  final BoxFit? fit;
  final Alignment? alignment;
  @override
  Widget build(BuildContext context) {
    final memoried = kIsWeb ? useMemoized(() => file.readAsBytes()) : null;
    final memory = memoried != null ? useFuture(memoried) : null;
    return kIsWeb
        ? memory!.hasData
            ? Image.memory(
                memory.data!,
                fit: fit,
                alignment: alignment ?? Alignment.center,
              )
            : const Center(
                child: CircularProgressIndicator(),
              )
        : Image.file(
            File(file.path),
            fit: fit,
            alignment: alignment ?? Alignment.center,
          );
  }
}

class XFileViewBuilder extends HookWidget {
  const XFileViewBuilder(this.file, {super.key, required this.builder});

  final XFile? file;

  final Widget Function(ImageProvider? image) builder;
  @override
  Widget build(BuildContext context) {
    final memoried = kIsWeb && file != null ? useMemoized(() => file!.readAsBytes()) : null;
    final memory = memoried != null ? useFuture(memoried) : null;
    return kIsWeb && file != null
        ? memory!.hasData
            ? builder(MemoryImage(
                memory.data!,
              ))
            : const Center(
                child: CircularProgressIndicator(),
              )
        :  builder(file != null? FileImage(File(file!.path)): null);
  }
}
