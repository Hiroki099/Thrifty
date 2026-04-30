
import 'package:flutter/material.dart';

Widget dot(bool active, String type) {
  if (type == "Auction") {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: active ? 18 : 6,
      height: 6,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: active ? const Color(0xffBEB0E5) : const Color(0xff8B7EC8),
      ),
    );
  } else if (type == "Sale") {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: active ? 18 : 6,
      height: 6,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: active ? const Color(0xffE8A87C) : const Color(0xffD3D1C7),
      ),
    );
  } else {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: active ? 18 : 6,
      height: 6,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: active ? const Color(0xff86F3C7) : const Color(0xff5BAB8B),
      ),
    );
  }
}
