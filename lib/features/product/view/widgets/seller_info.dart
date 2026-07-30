import 'package:dealura/features/auth/model/user_model.dart';

import 'package:dealura/features/product/view/widgets/star_rating_widget.dart';
import 'package:flutter/material.dart';

class SellerInfo extends StatelessWidget {
  const SellerInfo({
    super.key,
    required this.owner,
    required this.averageRating,
    required this.ratingsCount,
  });

  final UserModel owner;
  final double averageRating;
  final int ratingsCount;
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
            backgroundColor: const Color(0xffFDF3EC),
            backgroundImage: owner.profilePictureUrl != null
                ? NetworkImage(owner.profilePictureUrl!)
                : null,
            child: owner.profilePictureUrl == null
                ? Text(
                    owner.username![0].toUpperCase(),
                    style: const TextStyle(
                      color: Color(0xffE8A87C),
                      fontFamily: "IBM Plex Sans",
                      fontWeight: FontWeight.w600,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                owner.username!,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  fontFamily: "IBM Plex Sans",
                ),
              ),
              SizedBox(height: 2),
              Row(
                children: [
                  StarRating(rating: averageRating),
                  Text(
                    "${averageRating.toStringAsFixed(1)} ($ratingsCount)",
                    style: const TextStyle(
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
