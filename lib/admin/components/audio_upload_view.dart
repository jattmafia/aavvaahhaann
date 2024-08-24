import 'package:avahan/admin/components/xfile_audio_view.dart';
import 'package:avahan/utils/extensions.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class AudioUploadView extends StatelessWidget {
  const AudioUploadView({
    super.key,
    this.url,
    this.file,
    required this.onFilePicked,
    required this.onClear,
    this.label = "",
    this.duration,
  });

  final String? url;
  final PlatformFile? file;
  final String label;

  final Function(PlatformFile? file) onFilePicked;
  final VoidCallback onClear;
  final ValueChanged<int>? duration;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 144,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: context.scheme.surfaceTint.withOpacity(0.05),
        borderRadius: BorderRadius.circular(6),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(6),
        splashColor: context.scheme.primary.withOpacity(0.1),
        onTap: () async {
          final pickedFile = await FilePicker.platform.pickFiles(
            type: FileType.audio,
          );
          if (pickedFile != null &&
              pickedFile.files.isNotEmpty &&
              pickedFile.files.first.bytes != null) {
            onFilePicked(pickedFile.files.first);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Stack(
            children: [
              Center(
                child: file != null || url != null
                    ? XFileAudioView(
                        file: file,
                        url: url,
                        duration: duration,
                      )
                    : Center(
                        child: Text(
                          "Drag & drop audio here $label",
                          style: TextStyle(color: context.scheme.outline),
                        ),
                      ),
              ),
              if (file != null)
                Positioned(
                  top: 0,
                  right: 0,
                  child: TextButton(
                    onPressed: () {
                      onClear();
                    },
                    child: const Text("Discard"),
                  ),
                ),
              if (file != null)
                Positioned(
                  child: Text(
                    file!.name,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
