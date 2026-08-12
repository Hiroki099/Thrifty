import 'package:dealura/features/product/models/RatingModel.dart';
import 'package:dealura/features/product/view/widgets/star_rating_widget.dart';
import 'package:dealura/features/profile/view/pages/Ratings_page.dart';
import 'package:flutter/material.dart';

class RatingListItem extends StatelessWidget {
  const RatingListItem({
    super.key,
    required this.rating,
    required this.isReceived,
  });

  final RatingModel rating;
  final bool isReceived;

  static const Color backgroundColor = Color(0xffFFFFFF);
  static const Color primaryColor = Color(0xffE8A87C);
  static const Color textColor = Color(0xff24211E);
  static const Color secondaryTextColor = Color(0xff8A8580);
  static const Color avatarBackground = Color(0xffF3EDE4);

  @override
  Widget build(BuildContext context) {
    final user = isReceived ? rating.rater : rating.seller;

    final username = user?.username?.trim().isNotEmpty == true
        ? user!.username!
        : "Unknown user";

    final hasComment =
        rating.comment != null && rating.comment!.trim().isNotEmpty;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.fromLTRB(14, 13, 14, 14),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xffEFE9E2), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAvatar(user?.profilePictureUrl),

              const SizedBox(width: 11),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            username,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              fontFamily: "IBM Plex Sans",
                              color: textColor,
                              height: 1.2,
                            ),
                          ),
                        ),

                        if (rating.createdAt != null) ...[
                          const SizedBox(width: 8),
                          Text(
                            formatRatingDate(rating.createdAt!),
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                              fontFamily: "IBM Plex Sans",
                              color: secondaryTextColor,
                            ),
                          ),
                        ],
                      ],
                    ),

                    const SizedBox(height: 6),

                    Row(
                      children: [
                        StarRating(
                          rating: (rating.rating ?? 0).toDouble(),
                          size: 17,
                        ),

                        const SizedBox(width: 7),
                        Text(
                          '${rating.rating ?? 0}.0',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            fontFamily: "IBM Plex Sans",
                            color: secondaryTextColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          if (hasComment) ...[
            const SizedBox(height: 11),

            Padding(
              padding: const EdgeInsets.only(left: 63),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(11, 9, 11, 9),
                decoration: BoxDecoration(
                  color: const Color(0xffFBF8F3),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  rating.comment!.trim(),
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.4,
                    fontFamily: "IBM Plex Sans",
                    fontWeight: FontWeight.w400,
                    color: textColor,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAvatar(String? imageUrl) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: avatarBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: imageUrl == null || imageUrl.isEmpty
          ? const Icon(
              Icons.person_outline_rounded,
              size: 25,
              color: Color(0xffB5AEA5),
            )
          : Image.network(
              imageUrl,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) {
                return const Icon(
                  Icons.person_outline_rounded,
                  size: 25,
                  color: Color(0xffB5AEA5),
                );
              },
            ),
    );
  }
}
