import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44, // أهم تعديل
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          /// الخلفية
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 44,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: const BoxDecoration(
                color: Color(0xffFBF8F2),
                border: Border(
                  top: BorderSide(color: Color(0xffEDEDED), width: 1),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _item(0, 'assets/images/homeIcon.svg', 'Home'),
                  _item(1, 'assets/images/searchIcon.svg', 'Search'),
                  const SizedBox(width: 50),
                  _item(2, 'assets/images/chatIcon.svg', 'Chat'),
                  _item(3, 'assets/images/profileIcon.svg', 'Profile'),
                ],
              ),
            ),
          ),

          /// زر الإضافة
          Positioned(
            top: -3,
            left: MediaQuery.of(context).size.width / 2 - 25,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {},
              child: Container(
                height: 45,
                width: 45,
                decoration: BoxDecoration(
                  color: const Color(0xffE8A87C),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0x47D85A30),
                      blurRadius: 10,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 22),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _item(int index, String iconPath, String label) {
    final isActive = currentIndex == index;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onTap(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            iconPath,
            width: 22,
            height: 22,
            colorFilter: ColorFilter.mode(
              isActive ? Color(0xffE8A87C) : Color(0xffB5B0A8),
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontFamily: "IBM Plex Sans",
              fontSize: 10,
              height: 1.2,
              color: isActive ? Color(0xffE8A87C) : Color(0xffB5B0A8),
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
