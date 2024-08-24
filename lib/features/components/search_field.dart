import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:avahan/utils/extensions.dart';

class SearchField extends HookWidget {
  const SearchField({
    super.key,
    this.hintText,
    this.onChanged,
    this.initial = "",
    this.onTap,
    this.validator,
    this.keyboardType,
    this.suffix,
  });

  final String? hintText;
  final ValueChanged<String>? onChanged;
  final String initial;
  final VoidCallback? onTap;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final Widget? suffix;
  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController(text: initial);
    final empty = useState<bool>(initial.isEmpty);
    return TextFormField(
      autovalidateMode:
          validator != null ? AutovalidateMode.onUserInteraction : null,
      keyboardType: keyboardType,
      readOnly: onTap != null,
      onTap: onTap,
      controller: controller,
      onChanged: (value) {
        if (value.isEmpty != empty.value) {
          empty.value = value.isEmpty;
        }
        onChanged?.call(value);
      },
      validator: validator,
      decoration: InputDecoration(
        filled: true,
        fillColor: context.scheme.surfaceTint.withOpacity(0.05),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        prefixIcon: const Icon(Icons.search_rounded),
        hintText: hintText,
        hintStyle:const TextStyle(fontSize: 13.8),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: context.scheme.outlineVariant,
          ),
        ),
        suffixIcon: !empty.value && onChanged != null
            ? IconButton(
                onPressed: () {
                  controller.clear();
                  onChanged?.call("");
                },
                icon: const Icon(Icons.clear_rounded),
              )
            : suffix,
      ),
    );
  }
}
