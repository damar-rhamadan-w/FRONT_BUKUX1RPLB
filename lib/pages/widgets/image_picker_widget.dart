import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerWidget extends StatefulWidget {
  final Uint8List? imageBytes;
  final void Function(Uint8List) onImageSelected;

  const ImagePickerWidget({
    super.key,
    required this.imageBytes,
    required this.onImageSelected,
  });

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      final bytes = await pickedImage.readAsBytes();
      widget.onImageSelected(bytes);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 150,
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          color: const Color(0xfff2f2f2),
        ),
        child: widget.imageBytes == null
            ? const Center(child: Text("Klik untuk upload cover"))
            : Image.memory(widget.imageBytes!, fit: BoxFit.cover),
      ),
    );
  }
}
