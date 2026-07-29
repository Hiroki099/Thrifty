import 'package:dealura/features/home/model/item_model.dart';
import 'package:flutter/material.dart';

class ProductInfo extends StatelessWidget {
  const ProductInfo({super.key, required this.product});
  final ItemModel product;
  @override
  Widget build(BuildContext context) {
    if (product.listingType == "fixed_price") {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product.name!,
            style: const TextStyle(
              fontFamily: "IBM Plex Sans",
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xff000000),
            ),
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
                        '4h 20m left ',
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
                  Text(
                    '12 bids',
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
            ),
          ),

          SizedBox(height: 19),
          Text(
            product.name!,
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontFamily: 'IBM Plex Sans',
              fontWeight: FontWeight.w700,
              height: 0.75,
            ),
          ),
          Container(
            width: 24,
            height: 24,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(),
          ),
          Text(
            'Current :${product.price} SYP',
            style: TextStyle(
              color: const Color(0xFF8B7EC8),
              fontSize: 20,
              fontFamily: 'IBM Plex Sans',
              fontWeight: FontWeight.w700,
              height: 0.68,
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
                SizedBox(
                  width: 280,
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
