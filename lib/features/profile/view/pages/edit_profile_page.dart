import 'dart:io';

import 'package:dealura/core/utls/app_router.dart';
import 'package:dealura/features/profile/repository/profile_repository_impl.dart';
import 'package:dealura/features/profile/view/widgets/profile_button.dart';
import 'package:dealura/features/profile/view/widgets/profile_image_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 68.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: SvgPicture.asset(
                    'assets/images/go_back.svg',
                    width: 20,
                    height: 20,
                  ),
                ),
                SvgPicture.asset(
                  'assets/images/pen.svg',
                  colorFilter: ColorFilter.mode(
                    Color(0xFF000000),
                    BlendMode.srcIn,
                  ),
                  width: 20,
                  height: 20,
                ),
              ],
            ),
          ),
          SizedBox(height: 18),
          ProfileButton(
            text: "set profile picture",
            icon: SvgPicture.asset(
              'assets/images/person.svg',
              width: 24,
              height: 24,
            ),
            onTap: () async {
              final File? image = await showProfileImageBottomSheet(context);

              if (image == null) return;

              try {
                await ProfileRepositoryImpl().partialEditProfile(
                  profileImage: image,
                );

                if (context.mounted) {
                  Navigator.pop(context, true);
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(e.toString())));
                }
              }
            },
          ),

          ProfileButton(
            text: "edit name",
            icon: SvgPicture.asset(
              'assets/images/tabler_edit.svg',
              width: 24,
              height: 24,
            ),
            onTap: () {
              showEditUsernameBottomSheet(context, context);
            },
          ),
          ProfileButton(
            text: "account setting",
            icon: SvgPicture.asset(
              'assets/images/settingsvg.svg',
              width: 24,
              height: 24,
            ),
            onTap: () {
              AppRouter.router.push('/account_setting');
            },
          ),
        ],
      ),
    );
  }
}

void showConfirmationDialog(
  BuildContext context,
  String action,
  Future<void> Function() onConfirm,
) {
  showDialog(
    context: context,
    builder: (dialogContext) {
      return Dialog(
        backgroundColor: const Color(0xFFFBF8F2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Are you sure?",
                style: TextStyle(
                  fontFamily: "DM Serif Display",
                  fontSize: 28,
                  color: Color(0xFF4A4843),
                ),
              ),

              const SizedBox(height: 12),

              Text(
                "Do you want to proceed with $action?",
                style: const TextStyle(
                  fontFamily: "IBM Plex Sans",
                  fontSize: 15,
                  color: Color(0xFF8A8580),
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 30),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(52),
                        side: const BorderSide(color: Color(0xFFE8A87C)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(dialogContext);
                      },
                      child: const Text(
                        "Cancel",
                        style: TextStyle(
                          color: Color(0xFFE8A87C),
                          fontFamily: "IBM Plex Sans",
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE8A87C),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        minimumSize: const Size.fromHeight(52),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () async {
                        Navigator.pop(dialogContext);
                        await onConfirm();
                      },
                      child: const Text(
                        "Confirm",
                        style: TextStyle(
                          fontFamily: "IBM Plex Sans",
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

void showEditUsernameBottomSheet(
  BuildContext pageContext,
  BuildContext context,
) {
  final controller = TextEditingController();

  showModalBottomSheet(
    context: pageContext,
    isScrollControlled: true,
    backgroundColor: const Color(0xFFFBF8F2),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (sheetContext) {
      return Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 20,
          bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 24,
        ),
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
              "Edit Username",
              style: TextStyle(
                fontFamily: "DM Serif Display",
                fontSize: 28,
                color: Color(0xFF4A4843),
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              "Choose a new username for your profile.",
              style: TextStyle(
                fontFamily: "IBM Plex Sans",
                fontSize: 15,
                color: Color(0xFF8A8580),
              ),
            ),

            const SizedBox(height: 28),

            const Text(
              "Username",
              style: TextStyle(
                color: Color(0xFF4A4843),
                fontFamily: "IBM Plex Sans",
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: controller,
              style: const TextStyle(
                fontFamily: "IBM Plex Sans",
                fontSize: 18,
                color: Color(0xFF4A4843),
              ),
              decoration: InputDecoration(
                hintText: "Enter new username",
                hintStyle: const TextStyle(
                  color: Color(0xFFB0AFA8),
                  fontFamily: "IBM Plex Sans",
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFD3D1C7)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFD3D1C7)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFFE8A87C),
                    width: 2,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xffE8A87C),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                onPressed: () async {
                  final username = controller.text.trim();
                  if (username.isEmpty) return;

                  try {
                    await ProfileRepositoryImpl().partialEditProfile(
                      username: username,
                    );

                    Navigator.pop(sheetContext);
                    Navigator.pop(context, true);
                  } catch (e) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(e.toString())));
                  }
                },
                child: const Text(
                  "Save Changes",
                  style: TextStyle(
                    fontFamily: "IBM Plex Sans",
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),
          ],
        ),
      );
    },
  );
}
