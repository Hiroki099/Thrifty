import 'package:flutter/material.dart';

class StarRating extends StatelessWidget {
  const StarRating({
    super.key,
    required this.rating,
    this.size = 18,
    this.spacing = 4,
    this.color = const Color(0xffE8A87C),
    this.emptyColor = const Color(0xffD8D1C8),
  });

  final double rating;
  final double size;
  final double spacing;
  final Color color;
  final Color emptyColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final starValue = index + 1;

        IconData icon;

        if (rating >= starValue) {
          icon = Icons.star_rounded;
        } else if (rating >= starValue - 0.5) {
          icon = Icons.star_half_rounded;
        } else {
          icon = Icons.star_outline_rounded;
        }

        return Padding(
          padding: EdgeInsets.only(right: index == 4 ? 0 : spacing),
          child: Icon(
            icon,
            size: size,
            color: rating >= starValue - 0.5 ? color : emptyColor,
          ),
        );
      }),
    );
  }
}
