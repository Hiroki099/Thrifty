import 'package:dealura/core/utls/app_router.dart';
import 'package:dealura/features/profile/view/widgets/profile_button.dart';
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
            onTap: () {},
          ),
          ProfileButton(
            text: "set location",
            icon: SvgPicture.asset(
              'assets/images/locationIcon.svg',
              width: 24,
              height: 24,
            ),
            onTap: () {},
          ),
          ProfileButton(
            text: "edit name",
            icon: SvgPicture.asset(
              'assets/images/tabler_edit.svg',
              width: 24,
              height: 24,
            ),
            onTap: () {},
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
      return AlertDialog(
        backgroundColor: const Color(0XFFE8A87C),
        title: const Text(
          "Are you sure?",
          style: TextStyle(
            color: Colors.white,
            fontFamily: "IBM Plex Sans",
            fontSize: 22,
            fontWeight: FontWeight.w400,
          ),
        ),
        content: Text(
          "Do you want to proceed with $action?",
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
            },
            child: const Text("Cancel", style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              await onConfirm();
            },
            child: const Text("Yes", style: TextStyle(color: Colors.white)),
          ),
        ],
      );
    },
  );
}
