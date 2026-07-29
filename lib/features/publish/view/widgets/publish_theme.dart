import 'package:flutter/material.dart';

enum ListingType { sale, donation, auction }

class PublishTheme {
  static Color color(ListingType type) {
    switch (type) {
      case ListingType.sale:
        return const Color(0xffE8A87C);

      case ListingType.donation:
        return const Color(0xff67B246);

      case ListingType.auction:
        return const Color(0xff6C63FF);
    }
  }
}
