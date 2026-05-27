import 'package:flutter/material.dart';

Widget tag(String text) {
  if (text == 'Sale') {
    return Container(
      width: 47,
      height: 22,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Color(0xffFDF3EC),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          color: Color(0xffE8A87C),
          fontWeight: FontWeight.bold,
          fontFamily: "IBM Plex Sans",
        ),
      ),
    );
  } else if (text == 'Auction') {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: Color(0xffEEEBF7),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          color: Color(0xff8B7EC8),
          fontFamily: "IBM Plex Sans",
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  } else if (text == 'Donations') {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: Color(0xffE3F2EC),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          color: Color(0xff5BAB8B),
          fontFamily: "IBM Plex Sans",
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  } else {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: Color(0xffF3EDE4),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          color: Color(0xff918B86),
          fontFamily: "IBM Plex Sans",
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
