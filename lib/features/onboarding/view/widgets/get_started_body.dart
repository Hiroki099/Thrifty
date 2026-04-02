import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GetStartBody extends StatelessWidget {
  const GetStartBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: -37,
          left: -25,
          child: Container(
            width: 250,
            height: 240,
            decoration: BoxDecoration(
              color: Color(0xFFE7A072).withOpacity(0.25),
              shape: BoxShape.circle,
            ),
          ),
        ),

        Positioned(
          top: -50,
          right: -50,
          child: Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: Color(0xFFE7A072).withOpacity(0.25),
              shape: BoxShape.circle,
            ),
          ),
        ),

        Positioned(
          top: 250,
          left: 22,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/Vector.png'),
                SizedBox(height: 66),
                Text(
                  "Thrifty",
                  style: TextStyle(
                    fontFamily: "DM Serif Display",
                    fontSize: 52,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                SizedBox(height: 31),
                Text(
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: "IBM Plex Sans",
                    fontWeight: FontWeight.w100,
                  ),
                  "A simple place to sell,\n bid and donate items with ease.\n Discover treasures ,support others \n and connect\n through a trusted community.",
                ),
                SizedBox(height: 40),
                GestureDetector(
                  onTap: () {
                    GoRouter.of(context).push('/sign-up');
                  },
                  child: Container(
                    height: 70,
                    width: 350,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(19),
                      color: Color(0xFFE7A072),
                    ),
                    child: Center(
                      child: Text(
                        "Get Started",
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: "DM Serif Display",
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
