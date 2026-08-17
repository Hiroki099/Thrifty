import 'package:dealura/features/home/model/item_model.dart';
import 'package:dealura/features/product/models/auction_model.dart';
import 'package:flutter/material.dart';

class ProductInfo extends StatelessWidget {
  final ItemModel product;
  final AuctionModel? auction;
  final Duration remaining;
  final bool auctionEnded;
  final VoidCallback? onBidPressed;
  final VoidCallback? onReportPressed;
  const ProductInfo({
    super.key,
    required this.product,
    this.auction,
    required this.remaining,
    required this.auctionEnded,
    this.onBidPressed,
    this.onReportPressed,
  });
  @override
  Widget build(BuildContext context) {
    if (product.listingType == "fixed_price") {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  product.name!,
                  style: const TextStyle(
                    fontFamily: "IBM Plex Sans",
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff000000),
                  ),
                ),
              ),
              if (onReportPressed != null)
                GestureDetector(
                  onTap: onReportPressed,
                  child: const Icon(
                    Icons.report,
                    color: Color(0xffB5B0A8),
                    size: 20,
                  ),
                ),
            ],
          ),

          const SizedBox(height: 8),

          Text(
            "${product.price!.toString()} SYP",
            style: const TextStyle(
              fontFamily: "IBM Plex Sans",
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xffE8A87C),
            ),
          ),

          const SizedBox(height: 6),
          Text(
            '  Started : ${product.createdAt!.year.toString()}-${product.createdAt!.month.toString()}-${product.createdAt!.day.toString()}',
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xffB5B0A8),
              fontFamily: "IBM Plex Sans",
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      );
    } else if (product.listingType == 'auction') {
      final hours = remaining.inHours;
      final minutes = remaining.inMinutes.remainder(60);
      final seconds = remaining.inSeconds.remainder(60);

      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 361,
            height: 35,
            decoration: ShapeDecoration(
              color: const Color(0xFFEEEBF7),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 9,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.watch_later_outlined,
                        color: Color(0xFF8B7EC8),
                        size: 17,
                      ),
                      SizedBox(width: 12),
                      Text(
                        auctionEnded
                            ? "Auction ended"
                            : "$hours h $minutes m $seconds s",
                        style: TextStyle(
                          color: const Color(0xFF8B7EC8),
                          fontSize: 15,
                          fontFamily: 'IBM Plex Sans',
                          fontWeight: FontWeight.w700,
                          height: 0.90,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 19),
          Row(
            children: [
              Expanded(
                child: Text(
                  product.name!,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontFamily: 'IBM Plex Sans',
                    fontWeight: FontWeight.w700,
                    height: 0.75,
                  ),
                ),
              ),
              if (onReportPressed != null)
                GestureDetector(
                  onTap: onReportPressed,
                  child: const Icon(
                    Icons.flag_outlined,
                    color: Color(0xffB5B0A8),
                    size: 20,
                  ),
                ),
            ],
          ),
          Container(
            width: 24,
            height: 24,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(),
          ),
          GestureDetector(
            onTap: onBidPressed,
            child: Text(
              'Current : ${auction?.currentPrice ?? auction?.startPrice ?? "0"} SYP',
              style: TextStyle(
                color: const Color(0xFF8B7EC8),
                fontSize: 20,
                fontFamily: 'IBM Plex Sans',
                fontWeight: FontWeight.w700,
                height: 0.68,
              ),
            ),
          ),
          SizedBox(height: 18),
          SizedBox(
            width: 204,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text:
                        '  Started : ${product.createdAt!.year.toString()}-${product.createdAt!.month.toString()}-${product.createdAt!.day.toString()}',
                    style: TextStyle(
                      color: const Color(0xFFB5B0A8),
                      fontSize: 13,
                      fontFamily: 'IBM Plex Sans',
                      fontWeight: FontWeight.w400,
                      height: 1.04,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 361,
            height: 46,
            decoration: ShapeDecoration(
              color: const Color(0xFFE3F2EC),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Center(
              child: Text(
                'This item is free- request it below',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF5BAB8B),
                  fontSize: 15,
                  fontFamily: 'IBM Plex Sans',
                  fontWeight: FontWeight.w600,
                  height: 1.10,
                ),
              ),
            ),
          ),
          SizedBox(height: 26),
          SizedBox(
            width: 280,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 18,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        product.name!,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontFamily: 'IBM Plex Sans',
                          fontWeight: FontWeight.w700,
                          height: 0.75,
                        ),
                      ),
                    ),
                    if (onReportPressed != null)
                      GestureDetector(
                        onTap: onReportPressed,
                        child: const Icon(
                          Icons.flag_outlined,
                          color: Color(0xffB5B0A8),
                          size: 20,
                        ),
                      ),
                  ],
                ),
                SizedBox(
                  width: 280,
                  child: Text(
                    product.price == null ? 'Free' : '${product.price} SYP',
                    style: TextStyle(
                      color: const Color(0xFF5BAB8B),
                      fontSize: 20,
                      fontFamily: 'IBM Plex Sans',
                      fontWeight: FontWeight.w700,
                      height: 0.68,
                    ),
                  ),
                ),
                SizedBox(
                  width: 280,
                  child: Text(
                    '${product.createdAt!.year.toString()}-${product.createdAt!.month.toString()}-${product.createdAt!.day.toString()}',
                    style: TextStyle(
                      color: const Color(0xFFB5B0A8),
                      fontSize: 13,
                      fontFamily: 'IBM Plex Sans',
                      fontWeight: FontWeight.w400,
                      height: 1.04,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }
  }
}
