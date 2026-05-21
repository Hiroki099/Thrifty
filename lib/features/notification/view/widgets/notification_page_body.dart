import 'package:dealura/features/notification/view/widgets/notification_tap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class NotificationPageBody extends StatelessWidget {
  const NotificationPageBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 45.0, left: 16.0, right: 16.0),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: SvgPicture.asset('assets/images/X.svg'),
              ),
              SizedBox(width: 16),
              Text(
                "Notifications",
                style: TextStyle(
                  color: Color(0xff1A1A1A),
                  fontFamily: "DM Serif Display",
                  fontSize: 25,
                  height: 2.85,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),

          NotificatioTap(),
          NotificatioTap(),
          NotificatioTap(),
          NotificatioTap(),
        ],
      ),
    );
  }
}
