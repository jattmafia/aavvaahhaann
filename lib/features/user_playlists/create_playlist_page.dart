import 'package:avahan/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CreatePlaylistPage extends HookWidget {
  const CreatePlaylistPage({super.key, required this.suggestedName,this.edit=false});

  static const route = "/create-playlist";

  final String suggestedName;
  final bool edit;
  @override
  Widget build(BuildContext context) {
    final labels = context.labels;
    final controller = useTextEditingController(text: suggestedName);
    return Material(
      color: context.scheme.surface,
      child: Container(
        color: context.scheme.surfaceTint.withOpacity(0.05),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  labels.giveYourPlaylistAname,
                  style: context.style.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  autofocus: true,
                  controller: controller,
                  style: context.style.headlineMedium,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    enabledBorder: UnderlineInputBorder(),
                    hintText: suggestedName,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        context.pop();
                      },
                      child: Text(labels.cancel),
                    ),
                    const SizedBox(width: 24),
                    FilledButton(
                      style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 24)),
                      onPressed: () {
                        context.pop(controller.text.crim ?? suggestedName);
                      },
                      child: Text(edit? labels.save: labels.create),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
