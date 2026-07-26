import 'dart:io';
import 'package:flutter/material.dart';

class ImagePickerGrid extends StatelessWidget {
  final List<File> images;
  final VoidCallback onAddPressed;
  final Function(File) onRemovePressed;

  const ImagePickerGrid({
    super.key,
    required this.images,
    required this.onAddPressed,
    required this.onRemovePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xffF3EDE4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xffE5E2DC)),
      ),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          ...images.map(
            (image) => Stack(
              children: [
                Container(
                  width: 95,
                  height: 95,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    image: DecorationImage(
                      image: FileImage(image),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: GestureDetector(
                    onTap: () => onRemovePressed(image),    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (images.length < 5)
            GestureDetector(
              onTap: onAddPressed, 
              child: Container(
                width: 95,
                height: 95,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: const Color(0xffE5E2DC),
                  ),
                  color: Colors.white,
                ),
                child: const Icon(
                  Icons.add,
                  color: Color(0xffB5B0A8),
                  size: 30,
                ),
              ),
            ),
        ],
      ),
    );
  }
}