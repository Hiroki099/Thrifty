import 'package:flutter/material.dart';

class NotificatioTap extends StatelessWidget {
  const NotificatioTap({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 18.0),
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Color(0xffD9D9D9),
                image: DecorationImage(
                  image: AssetImage('assets/images/notification_image.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SizedBox(width: 16),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    color: Color(0xff1A1A1A),
                    fontFamily: "IBM Plex Sans",
                    fontWeight: FontWeight.w400,
                  ),
                  children: [
                    TextSpan(text: "You've "),
                    TextSpan(
                      text: "outbid",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: " on vintage camera.\n"),
                    TextSpan(
                      text: "Current:",
                      style: TextStyle(
                        color: Color(0xff4A90E2),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(
                      text: " 13,500 SYR",
                      style: TextStyle(fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8),
              Text(
                "2 hours ago",
                style: TextStyle(
                  color: Color(0xff8A8580),
                  fontFamily: "IBM Plex Sans",
                  fontSize: 11,
                  height: 1.5,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
