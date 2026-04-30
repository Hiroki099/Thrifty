import 'package:dealura/features/product/view/widgets/bottom_action.dart';
import 'package:dealura/features/product/view/widgets/custom_photo_dots.dart';
import 'package:dealura/features/product/view/widgets/product_descripion.dart';
import 'package:dealura/features/product/view/widgets/product_info.dart';
import 'package:dealura/features/product/view/widgets/product_tag.dart';
import 'package:dealura/features/product/view/widgets/seller_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ProductDetailsPage extends StatefulWidget {
  const ProductDetailsPage({super.key, required this.type});

  final String type;

  @override
  State<ProductDetailsPage> createState() => ProductDetailsPageState();
}

class ProductDetailsPageState extends State<ProductDetailsPage> {
  int currentPage = 0;
  final List<String> images = [
    'assets/images/rool.png',
    'assets/images/rool.png',
    'assets/images/rool.png',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFAF6F0),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 220,
                      child: Stack(
                        children: [
                          Expanded(
                            child: PageView.builder(
                              itemCount: images.length,
                              onPageChanged: (index) {
                                setState(() {
                                  currentPage = index;
                                });
                              },
                              itemBuilder: (_, index) {
                                return productImage(images[index]);
                              },
                            ),
                          ),
                          const SizedBox(height: 10),

                          Positioned(
                            top: 20,
                            left: 16,
                            child: GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: SvgPicture.asset(
                                    'assets/images/go_back2.svg',
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 10,
                            left: 16,
                            right: 16,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                images.length,
                                (index) => dot(index == currentPage, "Free"),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 19),

                    Row(
                      children: [
                        tag("Donations"),
                        const SizedBox(width: 8),
                        tag("Like new"),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 16.0,
                        right: 16.0,
                        bottom: 45,
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 12),

                          ProductInfo(type: 'Free'),

                          const SizedBox(height: 18),
                          SellerInfo(),

                          const SizedBox(height: 18),

                          ProductDescripion(),

                          const SizedBox(height: 80),
                          bottomAction('Place bid'),
                        ],
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

Widget productImage(String path) {
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
