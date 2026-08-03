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
import 'package:dio/dio.dart';
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
  bool isRequested = false;
  bool requestLoading = false;
  bool checkingRequest = false;
  int? requestId;
  bool checkedRequest = false;
  bool purchaseLoading = false;
  final TextEditingController bidController = TextEditingController();
  Future<void> handleBid(AuctionModel auction, int amount) async {
    final repo = ProductDetaillesRepositoryImpl();

    try {
      print("Auction ID: ${auction.id}");
      print("Amount: $amount");
      await repo.createBid(auction.id!, amount);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Bid placed successfully"),
          backgroundColor: Colors.green,
        ),
      );

      final data = await loadData();

      if (!mounted) return;

      setState(() {
        pageData = Future.value(data);
      });
    } on DioException catch (e) {
      print("STATUS CODE: ${e.response?.statusCode}");
      print("ERROR DATA: ${e.response?.data}");
      print("REQUEST DATA: ${e.requestOptions.data}");
      print("REQUEST URL: ${e.requestOptions.uri}");

      String message = "Failed to place bid";

      final data = e.response?.data;

      if (data is Map<String, dynamic>) {
        final bidError = data["bid_amount"];
        final auctionError = data["auction"];

        if (bidError is List && bidError.isNotEmpty) {
          final error = bidError.first.toString();

          if (error.contains("Insufficient wallet balance")) {
            message = "Sorry, you don't have enough balance.";
          } else if (error.contains("higher than the current price")) {
            message = "Your bid must be higher than the current bid.";
          } else {
            message = error;
          }
        } else if (auctionError is List && auctionError.isNotEmpty) {
          final error = auctionError.first.toString();

          if (error.contains("auction has ended")) {
            message = "Sorry, this auction has already ended.";
          } else {
            message = error;
          }
        }
      }

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  Future<void> handlePurchase(ItemModel product) async {
    final repo = ProductDetaillesRepositoryImpl();

    setState(() {
      purchaseLoading = true;
    });

    try {
      final result = await repo.purchaseItem(product.id!);

      if (result.containsKey('error')) {
        String message;

        switch (result['error']) {
          case 'Insufficient buyer wallet balance':
            message = 'sorry you do not have enough balance';
            break;

          case 'Item is not available.':
            message = 'sorry this item is no longer available';
            break;

          default:
            message = result['error'];
        }

        if (!mounted) return;

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
        return;
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result["message"]),
          backgroundColor: Colors.green,
        ),
      );

      final data = await loadData();

      if (!mounted) return;

      setState(() {
        pageData = Future.value(data);
      });
    } on DioException catch (e) {
      String message = "Purchase failed";

      final data = e.response?.data;

      if (data is Map<String, dynamic>) {
        switch (data["error"]) {
          case "Insufficient buyer wallet balance":
            message = "sorry you do not have enough balance";
            break;

          case "Item is not available.":
            message = "sorry this item is no longer available";
            break;

          default:
            message = data["error"] ?? message;
        }
      }

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    } finally {
      if (mounted) {
        setState(() {
          purchaseLoading = false;
        });
      }
    }
  }

  Future<void> handleDonationRequest(ItemModel product) async {
    final repo = ProductDetaillesRepositoryImpl();

    setState(() {
      requestLoading = true;
    });

    try {
      if (isRequested) {
        await repo.cancelRequest(requestId!);

        setState(() {
          isRequested = false;
          requestId = null;
        });
      } else {
        final request = await repo.requestForDonation(product.id!);

        setState(() {
          isRequested = true;
          requestId = request.id;
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          requestLoading = false;
        });
      }
    }
  }

  Future<void> checkDonationRequest(ItemModel product) async {
    setState(() {
      checkingRequest = true;
    });

    try {
      final repo = ProductDetaillesRepositoryImpl();

      final requests = await repo.getRequests("sent");

      for (final request in requests) {
        if (request.itemId == product.id) {
          if (!mounted) return;

          if (request.itemId == product.id) {
            if (!mounted) return;

            setState(() {
              isRequested = true;
              requestId = request.id;
            });

            return;
          }
        }
      }

      if (!mounted) return;

      setState(() {
        isRequested = false;
        requestId = null;
      });
    } finally {
      if (mounted) {
        setState(() {
          checkingRequest = false;
        });
      }
    }
  }

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
    bidController.dispose();
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

          if (product.listingType == "donation" &&
              !isMyProduct &&
              !checkedRequest) {
            checkedRequest = true;

            WidgetsBinding.instance.addPostFrameCallback((_) {
              checkDonationRequest(product);
            });
          }

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
                          context: context,
                          text: _getActionText(product),
                          product: product,
                          isMyProduct: isMyProduct,
                          isRequested: isRequested,
                          isLoading: requestLoading,
                          isCheckingRequest: checkingRequest,
                          isAvailable: product.isAvailable ?? true,
                          purchaseLoading: purchaseLoading,
                          onPurchase: () {
                            handlePurchase(product);
                          },
                          onRequest: () {
                            handleDonationRequest(product);
                          },
                          onEdit: () {
                            _showEditBottomSheet(product);
                          },
                          onBid: auction == null
                              ? null
                              : (amount) {
                                  handleBid(auction, amount);
                                },
                          bidController: bidController,
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
