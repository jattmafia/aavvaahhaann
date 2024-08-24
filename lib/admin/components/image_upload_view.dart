import 'package:avahan/admin/gallary/gallary_page.dart';
import 'package:avahan/features/components/xfile_view.dart';
import 'package:avahan/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:image_picker/image_picker.dart';

class ImageUploadView extends HookWidget {
  const ImageUploadView({
    super.key,
    this.url,
    this.file,
    required this.onFilePicked,
    this.label = "",
    this.aspectRatio,
    required this.onUrlChanged,
  });

  final String? url;
  final XFile? file;
  final String label;
  final double? aspectRatio;

  final Function(XFile? file) onFilePicked;
  final Function(String? url) onUrlChanged;
  @override
  Widget build(BuildContext context) {
    final controller = useRef<DropzoneViewController?>(null);
    return Container(
      height: 144,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: context.scheme.surfaceTint.withOpacity(0.05),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Stack(
        children: [
          DropzoneView(
            operation: DragOperation.copy,
            cursor: CursorType.grab,
            onCreated: (DropzoneViewController ctrl) {
              controller.value = ctrl;
            },
            onDrop: (dynamic ev) async {
              if (ev != null) {
                final data = await controller.value?.getFileData(ev);
                final name = await controller.value?.getFilename(ev);
                if (data != null &&
                    name != null &&
                    ['jpg', 'png'].contains(name.split('.').last)) {
                  final xfile = XFile('', name: name, bytes: data);
                  onFilePicked(xfile);
                }
              }
            },
          ),
          InkWell(
            borderRadius: BorderRadius.circular(6),
            splashColor: context.scheme.primary.withOpacity(0.1),
            onTap: () async {
              final pickedFile = await ImagePicker().pickImage(
                source: ImageSource.gallery,
              );
              if(pickedFile != null){
                onFilePicked(pickedFile);
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Stack(
                children: [
                  Center(
                    child: file != null || url != null
                        ? AspectRatio(
                            aspectRatio: aspectRatio ?? 1,
                            child: Container(
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  color: context.scheme.primaryContainer,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: file != null
                                      ? XFileView(file!, fit: BoxFit.contain,key: ValueKey(file?.name),)
                                      : Image.network(url!),
                                )),
                          )
                        : Center(
                            child: Text(
                              "Drag & drop image here $label",
                              style: TextStyle(color: context.scheme.outline),
                            ),
                          ),
                  ),
                  if (file != null || url != null)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: TextButton(
                        onPressed: () {
                          if(file != null){
                            onFilePicked(null);
                          } else {
                            onUrlChanged(null);
                          }
                        },
                        child:  Text(file != null? "Discard file": "Discard image"),
                      ),
                    ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: IconButton(
                      onPressed: () async {
                        final picked = await showSearch(
                          context: context,
                          delegate: GallaryImagesSearchDeledate(),
                        );
                        if (picked != null) {
                          onUrlChanged(picked);
                        }
                      },
                      icon: const Icon(Icons.photo),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
