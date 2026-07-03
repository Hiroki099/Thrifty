import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future<File?> showProfileImageBottomSheet(BuildContext context) async {
  final picker = ImagePicker();

  return showModalBottomSheet<File>(
    context: context,
    isScrollControlled: true,
    backgroundColor: const Color(0xFFFBF8F2),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (sheetContext) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 45,
                height: 5,
                decoration: BoxDecoration(
                  color: const Color(0xFFD3D1C7),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            const SizedBox(height: 28),

            const Text(
              "Profile Picture",
              style: TextStyle(
                fontFamily: "DM Serif Display",
                fontSize: 28,
                color: Color(0xFF4A4843),
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              "Choose a new picture for your profile.",
              style: TextStyle(
                fontFamily: "IBM Plex Sans",
                fontSize: 15,
                color: Color(0xFF8A8580),
              ),
            ),

            const SizedBox(height: 28),

            _ImageTile(
              icon: Icons.photo_camera_outlined,
              title: "Camera",
              subtitle: "Take a new photo",
              onTap: () async {
                final image = await picker.pickImage(
                  source: ImageSource.camera,
                  imageQuality: 85,
                );

                if (sheetContext.mounted) {
                  Navigator.pop(
                    sheetContext,
                    image == null ? null : File(image.path),
                  );
                }
              },
            ),

            const SizedBox(height: 16),

            _ImageTile(
              icon: Icons.photo_library_outlined,
              title: "Gallery",
              subtitle: "Choose from your gallery",
              onTap: () async {
                final image = await picker.pickImage(
                  source: ImageSource.gallery,
                  imageQuality: 85,
                );

                if (sheetContext.mounted) {
                  Navigator.pop(
                    sheetContext,
                    image == null ? null : File(image.path),
                  );
                }
              },
            ),

            const SizedBox(height: 12),
          ],
        ),
      );
    },
  );
}

class _ImageTile extends StatelessWidget {
  const _ImageTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFD3D1C7)),
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: const BoxDecoration(
                color: Color(0xFFF7F3EE),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: const Color(0xFFE8A87C)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: "IBM Plex Sans",
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF4A4843),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontFamily: "IBM Plex Sans",
                      fontSize: 14,
                      color: Color(0xFF8A8580),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFFE8A87C)),
          ],
        ),
      ),
    );
  }
}
