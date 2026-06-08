import 'package:dealura/features/home/model/item_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProductCard extends StatelessWidget {
  final ItemModel item;

  const ProductCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final bool isAuction = item.listingType == "auction";
    final bool isDonation = item.listingType == "donation";

    Color badgeColor;
    String badgeText;

    if (isAuction) {
      badgeColor = const Color(0xff6C63FF);
      badgeText = "Bid";
    } else if (isDonation) {
      badgeColor = const Color(0xff67B246);
      badgeText = "Free";
    } else {
      badgeColor = const Color(0xffE8A87C);
      badgeText = "Sale";
    }

    return GestureDetector(
      onTap: () {
        context.push('/product_details', extra: item.id);
      },
      child: Container(
        width: 171,
        height: 235,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xffD3D1C7)),
        ),
        child: Column(
          children: [
            /// IMAGE
            Stack(
              children: [
                Container(
                  height: 115,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                    color: Colors.grey.shade200,
                    image: item.image != null
                        ? DecorationImage(
                            image: NetworkImage(item.image!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                ),

                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: badgeColor.withOpacity(.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      badgeText,
                      style: TextStyle(
                        color: badgeColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),

                if (isAuction)
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xff6C63FF),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        "4h 20m",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: "IBM Plex Sans",
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff1A1A1A),
                      ),
                    ),

                    const Spacer(),

                    Text(
                      isDonation
                          ? "Free"
                          : (item.price != null
                                ? "${item.price} SYP"
                                : "Auction"),
                      style: TextStyle(
                        fontFamily: "IBM Plex Sans",
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: isAuction
                            ? const Color(0xff6C63FF)
                            : isDonation
                            ? const Color(0xff67B246)
                            : const Color(0xffE8A87C),
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      item.category?.name ?? '',
                      style: const TextStyle(
                        color: Color(0xffB5B0A8),
                        fontFamily: "IBM Plex Sans",
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
