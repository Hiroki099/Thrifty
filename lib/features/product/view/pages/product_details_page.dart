import 'package:dealura/features/home/model/item_model.dart';
import 'package:dealura/features/product/models/image_model/image_model.dart';
import 'package:dealura/features/product/repository/product_detailles_repository_impl.dart';
import 'package:dealura/features/product/view/widgets/bottom_action.dart';
import 'package:dealura/features/product/view/widgets/custom_photo_dots.dart';
import 'package:dealura/features/product/view/widgets/product_descripion.dart';
import 'package:dealura/features/product/view/widgets/product_info.dart';
import 'package:dealura/features/product/view/widgets/product_tag.dart';
import 'package:dealura/features/product/view/widgets/seller_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ProductDetailsPage extends StatefulWidget {
  const ProductDetailsPage({super.key, required this.id});

  final int? id;

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  int currentPage = 0;

  late Future<Map<String, dynamic>> pageData;

  @override
  void initState() {
    super.initState();
    pageData = loadData();
  }

  Future<Map<String, dynamic>> loadData() async {
    final repo = ProductDetaillesRepositoryImpl();

    final results = await Future.wait([
      repo.getProductDetailes(widget.id!),
      repo.getProductImages(widget.id!),
    ]);

    return {
      'product': results[0] as ItemModel,
      'images': results[1] as List<ImageModel>,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFAF6F0),
      body: FutureBuilder<Map<String, dynamic>>(
        future: pageData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          final product = snapshot.data!['product'] as ItemModel;
          final images = snapshot.data!['images'] as List<ImageModel>;

          return SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 220,
                    child: Stack(
                      children: [
                        PageView.builder(
                          itemCount: images.isEmpty ? 1 : images.length,
                          onPageChanged: (index) {
                            setState(() {
                              currentPage = index;
                            });
                          },
                          itemBuilder: (_, index) {
                            if (images.isEmpty) {
                              return productImage(product.image ?? '');
                            }

                            return productImage(images[index].image ?? '');
                          },
                        ),

                        Positioned(
                          top: 20,
                          left: 16,
                          child: GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10),
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
                              images.isEmpty ? 1 : images.length,
                              (index) =>
                                  dot(index == currentPage, _getType(product)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 19),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        tag(_getTagName(product)),
                        const SizedBox(width: 8),
                        tag(product.category?.name ?? ''),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                      bottom: 45,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 12),

                        ProductInfo(type: _getType(product)),

                        const SizedBox(height: 18),

                        SellerInfo(
                          // عدل الويدجت ليأخذ البيانات
                        ),

                        const SizedBox(height: 18),

                        ProductDescripion(
                          // عدل الويدجت ليأخذ الوصف
                        ),

                        const SizedBox(height: 80),

                        bottomAction(_getActionText(product)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _getType(ItemModel product) {
    switch (product.listingType) {
      case 'auction':
        return 'Auction';

      case 'donation':
        return 'Free';

      default:
        return 'Sale';
    }
  }

  String _getTagName(ItemModel product) {
    switch (product.listingType) {
      case 'auction':
        return 'Auction';

      case 'donation':
        return 'Donations';

      default:
        return 'Sale';
    }
  }

  String _getActionText(ItemModel product) {
    switch (product.listingType) {
      case 'auction':
        return 'Place bid';

      case 'donation':
        return 'Request item';

      default:
        return 'Buy now';
    }
  }
}

Widget productImage(String imageUrl) {
  return Container(
    width: double.infinity,
    decoration: BoxDecoration(
      image: DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover),
    ),
  );
}
