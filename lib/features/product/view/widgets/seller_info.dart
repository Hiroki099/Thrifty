import 'package:dealura/features/product/view/widgets/star_rating_widget.dart';
import 'package:flutter/material.dart';

class SellerInfo extends StatelessWidget {
  const SellerInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.symmetric(
          horizontal: BorderSide(color: Color(0xffB5B0A8), width: 0.5),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: Color(0xffFDF3EC),
            child: const Text(
              "AS",
              style: TextStyle(
                color: Color(0xffE8A87C),
                fontFamily: "IBM Plex Sans",
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "Ahmad S.",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  fontFamily: "IBM Plex Sans",
                ),
              ),
              SizedBox(height: 2),
              Row(
                children: [
                  StarRating(rating: 4.8),
                  Text(
                    "4.8 (23) • Fast",
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xff8A8580),
                      fontFamily: "IBM Plex Sans",
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
