import 'package:dealura/features/profile/view/pages/edit_profile_page.dart';
import 'package:dealura/features/profile/view/widgets/profile_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AccountSettingPage extends StatelessWidget {
  const AccountSettingPage({super.key});

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
                    width: 22,
                    height: 22,
                  ),
                ),
                SvgPicture.asset(
                  'assets/images/settingsvg.svg',
                  colorFilter: ColorFilter.mode(
                    Color(0xFF000000),
                    BlendMode.srcIn,
                  ),
                  width: 22,
                  height: 22,
                ),
              ],
            ),
          ),
          SizedBox(height: 18),
          ProfileButton(
            text: "log out",
            icon: Icon(Icons.logout, size: 24, color: Colors.black87),
            onTap: () {
              showConfirmationDialog(context, "log out");
            },
          ),
          ProfileButton(
            text: "delete account",
            icon: SvgPicture.asset(
              'assets/images/delete.svg',
              width: 24,
              height: 24,
            ),
            onTap: () {
              showConfirmationDialog(context, "delete account");
            },
          ),
          ProfileButton(
            text: "saved posts",
            icon: SvgPicture.asset(
              'assets/images/save.svg',
              width: 24,
              height: 24,
            ),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
