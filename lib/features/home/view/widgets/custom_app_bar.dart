import 'package:dealura/core/utls/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 62,
      width: 343,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Text(
                "Welcome!",
                style: TextStyle(
                  color: Color(0xff1A1A1A),
                  fontFamily: "DM Serif Display",
                  fontSize: 30,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                "Find something you love",
                style: TextStyle(
                  color: Color(0xff8A8580),
                  fontFamily: "IBM Plex Sans",
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () => AppRouter.router.push('/exchange'),
                child: SvgPicture.asset('assets/images/exchange.svg'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
