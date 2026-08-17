import 'package:dealura/features/auth/model/user_model.dart';
import 'package:dealura/features/home/model/item_model.dart';
import 'package:dealura/features/product/models/RatingModel.dart';
import 'package:dealura/features/product/models/auction_model.dart';
import 'package:dealura/features/product/models/bid_model.dart';
import 'package:dealura/features/product/models/image_model/image_model.dart';
import 'package:dealura/features/product/repository/product_detailles_repository_impl.dart';
import 'package:dealura/features/product/view/widgets/Rating_bottom_sheet.dart';
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
  Future<void> showRatingDialog() async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xffFBF8F2),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) {
        return const RatingBottomSheet();
      },
    );

    if (result == null || !mounted) return;

    final rating = result['rating'] as int;
    final comment = result['comment'] as String;

    await rateProduct(rating, comment);
  }

  Future<void> showReportDialog(ItemModel product) async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xffFBF8F2),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) {
        return _ReportBottomSheet(productId: product.id!);
      },
    );

    if (result == null || !mounted) return;

    final reason = result['reason'] as String;
    final description = result['description'] as String;

    await submitReport(product.id!, reason, description);
  }

  Future<void> submitReport(
    int productId,
    String reason,
    String description,
  ) async {
    try {
      final repo = ProductDetaillesRepositoryImpl();
     await repo.createReport(productId, description, reason);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Report submitted successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to submit report: $e')));
    }
  }

  Future<void> showBids(AuctionModel auction) async {
    if (auction.id == null) return;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xffFBF8F2),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return _BidsBottomSheet(auctionId: auction.id!);
      },
    );
  }

  Future<void> rateProduct(int rating, String comment) async {
    if (rating < 1 || rating > 5) return;

    setState(() {
      ratingLoading = true;
    });

    try {
      final repo = ProductDetaillesRepositoryImpl();

      await repo.rateSellerFromClaimed(widget.id!, rating, comment);

      if (!mounted) return;

      setState(() {
        canRateProduct = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Rating submitted successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } on DioException catch (e) {
      print('RATE ERROR: ${e.response?.statusCode}');
      print('RATE ERROR DATA: ${e.response?.data}');

      if (e.response?.statusCode == 200 || e.response?.statusCode == 201) {
        if (!mounted) return;

        setState(() {
          canRateProduct = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Rating submitted successfully'),
            backgroundColor: Colors.green,
          ),
        );

        return;
      }

      if (!mounted) return;

      String message = 'Failed to submit rating';

      final data = e.response?.data;

      if (data is Map<String, dynamic>) {
        message =
            data['detail']?.toString() ??
            data['error']?.toString() ??
            data['comment']?.toString() ??
            message;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    } catch (e) {
      print('RATE ERROR: $e');

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to submit rating')));
    } finally {
      if (mounted) {
        setState(() {
          ratingLoading = false;
        });
      }
    }
  }

  bool canRateProduct = false;
  bool checkingRating = false;
  bool ratingLoading = false;
  bool isRequested = false;
  bool requestLoading = false;
  bool checkingRequest = false;
  int? requestId;
  bool checkedRequest = false;
  bool purchaseLoading = false;
  bool bidLoading = false;
  final TextEditingController bidController = TextEditingController();
  List<ItemModel> myClaims = [];
  Future<void> handleBid(AuctionModel auction, int amount) async {
    if (bidLoading) return;

    final repo = ProductDetaillesRepositoryImpl();

    setState(() {
      bidLoading = true;
    });

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

      // Reload all page data after successful bid
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

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
    } catch (e) {
      print("BID ERROR: $e");

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to place bid"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          bidLoading = false;
        });
      }
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
      prepo.getMyClaims(),
      repo.getMyGivenRatings(),
    ]);

    final images = results[0] as List<ImageModel>;
    final ratings = results[1] as List<RatingModel>;
    myClaims = results[2] as List<ItemModel>;
    final myGivenRatings = results[3] as List<RatingModel>;

    final isClaimed = myClaims.any((item) => item.id == product.id);

    final alreadyRated = myGivenRatings.any(
      (rating) => rating.itemDetailUrl == product.detailUrl,
    );

    canRateProduct = isClaimed && !alreadyRated;

    print('Product ID: ${product.id}');
    print('Is claimed: $isClaimed');
    print('Already rated: $alreadyRated');
    print('Can rate: $canRateProduct');
    for (final rating in myGivenRatings) {
      print('================ RATING =================');
      print('Rating ID: ${rating.id}');
      print('Item Name: ${rating.itemName}');
      print('Rating item URL: ${rating.itemDetailUrl}');
      print('Product detail URL: ${product.detailUrl}');
      print('Same URL: ${rating.itemDetailUrl == product.detailUrl}');
    }
    return {
      'product': product,
      'images': images,
      'ratings': ratings,
      'auction': auction,
      'me': me,
      'canRateProduct': canRateProduct,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFAF6F0),
      body: Stack(
        children: [
          FutureBuilder<Map<String, dynamic>>(
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

                                return productImage(
                                  images[index].imageUrl ?? '',
                                );
                              },
                            ),

                            // Back button
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

                            // Rating button
                            if (canRateProduct)
                              Positioned(
                                top: 20,
                                right: 16,
                                child: GestureDetector(
                                  onTap: ratingLoading
                                      ? null
                                      : showRatingDialog,
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: ratingLoading
                                        ? const Padding(
                                            padding: EdgeInsets.all(11),
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: Color(0xffE8A87C),
                                            ),
                                          )
                                        : const Icon(
                                            Icons.star_border_rounded,
                                            color: Color(0xffE8A87C),
                                            size: 25,
                                          ),
                                  ),
                                ),
                              ),

                            // Dots
                            Positioned(
                              bottom: 10,
                              left: 16,
                              right: 16,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  images.isEmpty ? 1 : images.length,
                                  (index) => dot(
                                    index == currentPage,
                                    _getType(product),
                                  ),
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
                              onBidPressed: () async {
                                await showBids(auction!);
                              },
                              onReportPressed: !isMyProduct
                                  ? () async {
                                      await showReportDialog(product);
                                    }
                                  : null,
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
                              isClaimed: myClaims.any(
                                (item) => item.id == product.id,
                              ),
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
          if (bidLoading)
            Positioned.fill(
              child: AbsorbPointer(
                absorbing: true,
                child: Container(
                  color: Colors.black.withValues(alpha: 0.35),
                  child: const Center(
                    child: CircularProgressIndicator(color: Color(0xffE8A87C)),
                  ),
                ),
              ),
            ),
        ],
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

class _BidsBottomSheet extends StatefulWidget {
  final int auctionId;

  const _BidsBottomSheet({required this.auctionId});

  @override
  State<_BidsBottomSheet> createState() => _BidsBottomSheetState();
}

class _BidsBottomSheetState extends State<_BidsBottomSheet> {
  late Future<List<BidModel>> bidsFuture;

  @override
  void initState() {
    super.initState();

    bidsFuture = ProductDetaillesRepositoryImpl().getBids(widget.auctionId);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.75,
        child: Column(
          children: [
            const SizedBox(height: 12),

            Container(
              width: 45,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'All bids',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontFamily: 'IBM Plex Sans',
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 16),

            Expanded(
              child: FutureBuilder<List<BidModel>>(
                future: bidsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xff8B7EC8),
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Failed to load bids',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontFamily: 'IBM Plex Sans',
                        ),
                      ),
                    );
                  }

                  final bids = snapshot.data ?? [];

                  if (bids.isEmpty) {
                    return Center(
                      child: Text(
                        'No bids yet',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontFamily: 'IBM Plex Sans',
                        ),
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    itemCount: bids.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      return _BidItem(bid: bids[index], index: index);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BidItem extends StatelessWidget {
  final BidModel bid;
  final int index;

  const _BidItem({required this.bid, required this.index});

  @override
  Widget build(BuildContext context) {
    final user = bid.bidderUser;

    final username =
        user?.username ??
        (bid.bidder != null ? 'User #${bid.bidder}' : 'Unknown user');

    final profilePicture = user?.profilePictureUrl;

    final amount = bid.bidAmount ?? '0';

    String dateText = '';

    if (bid.bidDate != null) {
      final date = bid.bidDate!.toLocal();

      final hour = date.hour.toString().padLeft(2, '0');
      final minute = date.minute.toString().padLeft(2, '0');

      dateText =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-'
          '${date.day.toString().padLeft(2, '0')} '
          '$hour:$minute';
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Color(0xFFEEEBF7),
              shape: BoxShape.circle,
            ),
            child: Text(
              '${index + 1}',
              style: const TextStyle(
                color: Color(0xFF8B7EC8),
                fontSize: 13,
                fontFamily: 'IBM Plex Sans',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          const SizedBox(width: 12),

          ClipOval(
            child: SizedBox(
              width: 42,
              height: 42,
              child: profilePicture != null && profilePicture.isNotEmpty
                  ? Image.network(
                      profilePicture,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) {
                        return Container(
                          color: const Color(0xFFEEEBF7),
                          child: const Icon(
                            Icons.person,
                            color: Color(0xFF8B7EC8),
                          ),
                        );
                      },
                    )
                  : Container(
                      color: const Color(0xFFEEEBF7),
                      child: const Icon(Icons.person, color: Color(0xFF8B7EC8)),
                    ),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  username,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontFamily: 'IBM Plex Sans',
                    fontWeight: FontWeight.w600,
                  ),
                ),

                if (dateText.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    dateText,
                    style: const TextStyle(
                      color: Color(0xFFB5B0A8),
                      fontSize: 12,
                      fontFamily: 'IBM Plex Sans',
                    ),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(width: 8),
          Text(
            '$amount SYP',
            style: const TextStyle(
              color: Color(0xFF8B7EC8),
              fontSize: 16,
              fontFamily: 'IBM Plex Sans',
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReportBottomSheet extends StatefulWidget {
  final int productId;

  const _ReportBottomSheet({required this.productId});

  @override
  State<_ReportBottomSheet> createState() => _ReportBottomSheetState();
}

class _ReportBottomSheetState extends State<_ReportBottomSheet> {
  String selectedReason = 'harassment';
  final descriptionController = TextEditingController();
  final List<String> reasons = [
    'harassment',
    'spam',
    'fraud',
    'inappropriate_content',
    'other',
  ];

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Report item',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: 'IBM Plex Sans',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              const Text(
                'Reason',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontFamily: 'IBM Plex Sans',
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 12),

              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: reasons.map((reason) {
                  final isSelected = selectedReason == reason;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedReason = reason;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xffE8A87C)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xffE8A87C)
                              : const Color(0xffE5E0D9),
                        ),
                      ),
                      child: Text(
                        reason
                            .split('_')
                            .map(
                              (part) => part.isEmpty
                                  ? ''
                                  : part[0].toUpperCase() + part.substring(1),
                            )
                            .join(' '),
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontSize: 14,
                          fontFamily: 'IBM Plex Sans',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 20),

              const Text(
                'Description',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontFamily: 'IBM Plex Sans',
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 12),

              TextField(
                controller: descriptionController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Describe the issue...',
                  hintStyle: TextStyle(
                    color: Colors.grey.shade400,
                    fontFamily: 'IBM Plex Sans',
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xffE8A87C)),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, {
                      'reason': selectedReason,
                      'description': descriptionController.text.trim(),
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffE8A87C),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Submit report',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'IBM Plex Sans',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
