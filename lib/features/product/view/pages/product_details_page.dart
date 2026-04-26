import 'package:dealura/features/product/view/widgets/product_descripion.dart';
import 'package:dealura/features/product/view/widgets/product_info.dart';
import 'package:dealura/features/product/view/widgets/seller_info.dart';
import 'package:flutter/material.dart';

class ProductDetailsPage extends StatelessWidget {
  const ProductDetailsPage({super.key, required this.type});

  final String type;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFBF8F2),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),

                    /// Back Button
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.arrow_back_ios_new, size: 20),
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      height: 220,
                      child: Column(
                        children: [
                          Expanded(
                            child: PageView(
                              children: [
                                _productImage('assets/images/rool.png'),
                                _productImage('assets/images/rool.png'),
                                _productImage('assets/images/rool.png'),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [_dot(true), _dot(false), _dot(false)],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    /// Tags
                    Row(
                      children: [
                        tag("Donations"),
                        const SizedBox(width: 8),
                        tag("Like new"),
                      ],
                    ),

                    const SizedBox(height: 12),

                    ProductInfo(),

                    const SizedBox(height: 18),
                    SellerInfo(),

                    const SizedBox(height: 18),

                    ProductDescripion(),

                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),

            /// Bottom Button
            _bottomAction('auction'),
          ],
        ),
      ),
    );
  }
}

Widget tag(String text) {
  if (text == 'Sale') {
    return Container(
      width: 47,
      height: 22,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Color(0xffFDF3EC),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          color: Color(0xffE8A87C),
          fontWeight: FontWeight.bold,
          fontFamily: "IBM Plex Sans",
        ),
      ),
    );
  } else if (text == 'Auction') {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: Color(0xffEEEBF7),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          color: Color(0xff8B7EC8),
          fontFamily: "IBM Plex Sans",
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  } else if (text == 'Donations') {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: Color(0xffE3F2EC),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          color: Color(0xff5BAB8B),
          fontFamily: "IBM Plex Sans",
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  } else {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: Color(0xffF3EDE4),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          color: Color(0xff918B86),
          fontFamily: "IBM Plex Sans",
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

Widget _bottomAction(String product) {
  String text;

  switch (product) {
    case 'buy':
      text = "Buy now";
      break;
    case 'auction':
      text = "Place bid";
      break;
    case 'free':
      text = "Request this item";
      break;
    default:
      text = "Place bid";
  }
  if (text == "Buy now") {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 20),
      decoration: const BoxDecoration(color: Color(0xffFBF8F2)),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 51,
              width: 293,
              decoration: BoxDecoration(
                color: const Color(0xffE8A87C),
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Text(
                text,
                style: const TextStyle(
                  color: Color(0xffFFFFFF),
                  fontSize: 20,
                  fontFamily: "IBM Plex Sans",
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xffD4D0CA), width: 1.5),
            ),
            child: const Icon(
              Icons.chat_bubble_outline,
              color: Color(0xffB5B0A8),
            ),
          ),
        ],
      ),
    );
  } else if (text == "Place bid") {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 20),
      decoration: const BoxDecoration(color: Color(0xffFBF8F2)),
      child: Row(
        children: [
          Container(
            width: 159,
            height: 53,
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 1.50, color: const Color(0xFF8B7EC8)),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          Container(
            width: 129,
            height: 53,
            decoration: ShapeDecoration(
              color: const Color(0xFF8B7EC8),
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 1.50, color: const Color(0xFF8B7EC8)),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontFamily: "IBM Plex Sans",
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  } else {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 20),
      decoration: const BoxDecoration(color: Color(0xffFBF8F2)),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xffE8A87C),
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontFamily: "IBM Plex Sans",
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _productImage(String path) {
  return Container(
    width: double.infinity,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      image: DecorationImage(
        image: AssetImage('assets/images/rool.png'),
        fit: BoxFit.cover,
      ),
    ),
  );
}

Widget _dot(bool active) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 4),
    width: active ? 18 : 6,
    height: 6,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: active ? const Color(0xffE8A87C) : const Color(0xffD3D1C7),
    ),
  );
}
