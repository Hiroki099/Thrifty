import 'package:dealura/features/auth/model/user_model.dart';
import 'package:dealura/features/home/model/item_model.dart';
import 'package:dealura/features/product/models/RatingModel.dart';
import 'package:dealura/features/product/models/auction_model.dart';
import 'package:dealura/features/product/models/image_model/image_model.dart';
import 'package:dealura/features/product/repository/product_detailles_repository_impl.dart';
import 'package:dealura/features/product/view/widgets/bottom_action.dart';
import 'package:dealura/features/product/view/widgets/custom_photo_dots.dart';
import 'package:dealura/features/product/view/widgets/edit_product_bottomsheet.dart';
import 'package:dealura/features/product/view/widgets/product_descripion.dart';
import 'package:dealura/features/product/view/widgets/product_info.dart';
import 'package:dealura/features/product/view/widgets/product_tag.dart';
import 'package:dealura/features/product/view/widgets/seller_info.dart';
import 'package:dealura/features/profile/repository/profile_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:async';

class ProductDetailsPage extends StatefulWidget {
  const ProductDetailsPage({super.key, required this.id});

  final int? id;

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  Future<void> _showEditBottomSheet(ItemModel product) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xffFBF8F2),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) {
        return EditProductBottomSheet(
          product: product,
          onSave: (body) async {
            await ProductDetaillesRepositoryImpl().updateProductDetails(
              product.id!,
              body,
            );

            final data = await loadData();

            if (!mounted) return;

            setState(() {
              pageData = Future.value(data);
            });
          },
        );
      },
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Timer? timer;

  Duration remaining = Duration.zero;
  bool auctionEnded = false;
  int currentPage = 0;

  late Future<Map<String, dynamic>> pageData;

  @override
  void initState() {
    super.initState();
    pageData = loadData();
  }

  void startTimer(DateTime endTime) {
    timer?.cancel();

    remaining = endTime.difference(DateTime.now());

    timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (!mounted) return;

      final diff = endTime.difference(DateTime.now());

      if (diff.isNegative || diff == Duration.zero) {
        timer.cancel();

        setState(() {
          remaining = Duration.zero;
          auctionEnded = true;
        });

        timer.cancel();

        setState(() {
          remaining = Duration.zero;
          auctionEnded = true;
        });

        final data = await loadData();

        if (!mounted) return;

        setState(() {
          pageData = Future.value(data);
        });
        return;
      }

      setState(() {
        remaining = diff;
      });
    });
  }

  Future<Map<String, dynamic>> loadData() async {
    final repo = ProductDetaillesRepositoryImpl();
    final prepo = ProfileRepositoryImpl();
    final product = await repo.getProductDetailes(widget.id!);
    final me = await prepo.getMyProfile();
    AuctionModel? auction;

    if (product.listingType == "auction") {
      auction = await repo.getAuctionDetails(widget.id!);
      if (auction.endTime != null) {
        if (auction.endTime!.isAfter(DateTime.now())) {
          auctionEnded = false;
          startTimer(auction.endTime!);
        } else {
          auctionEnded = true;
          remaining = Duration.zero;
        }
      }
    }

    final results = await Future.wait([
      repo.getProductImages(widget.id!),
      repo.getOwnerRating(product.owner!.id!),
    ]);
    return {
      'product': product,
      'images': results[0] as List<ImageModel>,
      'ratings': results[1] as List<RatingModel>,
      'auction': auction,
      'me': me,
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
          final ratings = snapshot.data!['ratings'] as List<RatingModel>;
          final auction = snapshot.data!['auction'] as AuctionModel?;
          final me = snapshot.data!['me'] as UserModel;

          final isMyProduct = product.owner?.id == me.id;

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

                            return productImage(images[index].imageUrl ?? '');
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
                        ProductInfo(
                          product: product,
                          auction: auction,
                          remaining: remaining,
                          auctionEnded: auctionEnded,
                        ),
                        const SizedBox(height: 18),

                        SellerInfo(
                          owner: product.owner!,
                          averageRating: calculateAverageRating(ratings),
                          ratingsCount: ratings.length,
                        ),

                        const SizedBox(height: 18),

                        ProductDescripion(
                          description: product.description ?? '',
                        ),

                        const SizedBox(height: 80),

                        bottomAction(
                          text: _getActionText(product),
                          isMyProduct: isMyProduct,
                          onEdit: () {
                            _showEditBottomSheet(product);
                          },
                        ),
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

Widget productImage(String? imageUrl) {
  if (imageUrl == null || imageUrl.isEmpty) {
    return Container(
      color: Colors.grey.shade200,
      child: const Center(child: Icon(Icons.image_not_supported)),
    );
  }

  return Container(
    width: double.infinity,
    decoration: BoxDecoration(
      image: DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover),
    ),
  );
}

double calculateAverageRating(List<RatingModel> ratings) {
  if (ratings.isEmpty) return 0;

  final total = ratings.fold<int>(0, (sum, r) => sum + (r.rating ?? 0));

  return total / ratings.length;
}
