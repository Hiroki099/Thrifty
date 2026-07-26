import 'package:dealura/features/publish/view/widgets/publish_theme.dart';
import 'package:flutter/material.dart';

class ListingTypeWidget extends StatelessWidget {
  final ListingType selectedType;
  final ValueChanged<ListingType> onChanged;
  const ListingTypeWidget({
    super.key,
    required this.selectedType,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Listing type",
          style: TextStyle(
            fontSize: 16,
            fontFamily: "IBM Plex Sans",
            fontWeight: FontWeight.w500,
          ),
        ),

        const SizedBox(height: 16),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            PublishOption(
              text: "Sale",
              icon: Icons.sell_outlined,
              isSelected: selectedType == ListingType.sale,
              color: PublishTheme.color(ListingType.sale),
              onTap: () => onChanged(ListingType.sale),
            ),
            SizedBox(width: 12),

            PublishOption(
              text: "Donate",
              icon: Icons.card_giftcard,
              isSelected: selectedType == ListingType.donation,
              color: PublishTheme.color(ListingType.donation),
              onTap: () => onChanged(ListingType.donation),
            ),
            SizedBox(width: 12),

            PublishOption(
              text: "Auction",
              icon: Icons.bolt,
              isSelected: selectedType == ListingType.auction,
              color: PublishTheme.color(ListingType.auction),
              onTap: () => onChanged(ListingType.auction),
            ),
          ],
        ),
      ],
    );
  }
}

class PublishOption extends StatelessWidget {
  const PublishOption({
    super.key,
    required this.text,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    required this.color,
  });

  final String text;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 112,
        height: 116,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? color : const Color(0xffE5E2DC),
            width: 1.5,
          ),
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 28,
              color: isSelected ? color : const Color(0xffB5B0A8),
            ),

            const SizedBox(height: 12),

            Text(
              text,
              style: TextStyle(
                fontSize: 15,
                fontFamily: "IBM Plex Sans",
                fontWeight: FontWeight.w500,
                color: isSelected ? color : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
