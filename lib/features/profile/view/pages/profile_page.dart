import 'package:dealura/core/utls/app_router.dart';
import 'package:dealura/features/auth/model/user_model.dart';
import 'package:dealura/features/home/model/item_model.dart';
import 'package:dealura/features/product/models/bid_model.dart';
import 'package:dealura/features/product/models/request_model.dart';
import 'package:dealura/features/product/view/widgets/product_card.dart';
import 'package:dealura/features/profile/model/wallet_model.dart';
import 'package:dealura/features/profile/repository/profile_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future<void> _rejectRequest(
    RequestModel request,
    StateSetter setModalState,
  ) async {
    if (request.id == null || isProcessingRequest) return;

    setModalState(() {
      isProcessingRequest = true;
    });

    try {
      await ProfileRepositoryImpl().rejectRequest(request.id!);

      final requests = await ProfileRepositoryImpl().getRecivedRequests();

      if (!mounted) return;

      setState(() {
        receivedRequests = requests.where((request) {
          return request.status == 'pending' &&
              request.itemDetails?.listingType == 'donation';
        }).toList();
      });

      setModalState(() {});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Request rejected'),
          backgroundColor: Color(0xffE8A87C),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to reject request: $e')));
    } finally {
      if (mounted) {
        setModalState(() {
          isProcessingRequest = false;
        });
      }
    }
  }

  Future<void> _acceptRequest(
    RequestModel request,
    StateSetter setModalState,
  ) async {
    if (request.id == null || isProcessingRequest) return;

    setModalState(() {
      isProcessingRequest = true;
    });

    try {
      await ProfileRepositoryImpl().acceptRequest(request.id!);

      final requests = await ProfileRepositoryImpl().getRecivedRequests();

      if (!mounted) return;

      setState(() {
        receivedRequests = requests.where((request) {
          return request.status == 'pending' &&
              request.itemDetails?.listingType == 'donation';
        }).toList();
      });

      setModalState(() {});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Request accepted successfully'),
          backgroundColor: Color(0xff5BAB8B),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to accept request: $e')));
    } finally {
      if (mounted) {
        setModalState(() {
          isProcessingRequest = false;
        });
      }
    }
  }

  Widget _requestCard(RequestModel request, StateSetter setModalState) {
    final item = request.itemDetails;
    final requester = request.requester;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xffE5E0D9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Item
          Row(
            children: [
              Container(
                width: 65,
                height: 65,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: const Color(0xffF0ECE6),
                ),
                clipBehavior: Clip.antiAlias,
                child: item?.image != null && item!.image!.isNotEmpty
                    ? Image.network(item.image!, fit: BoxFit.cover)
                    : const Icon(
                        Icons.image_outlined,
                        color: Color(0xffB5B0A8),
                      ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item?.name ?? 'Unknown item',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'IBM Plex Sans',
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      'Requested by ${requester?.username ?? 'Unknown user'}',
                      style: const TextStyle(
                        fontFamily: 'IBM Plex Sans',
                        fontSize: 13,
                        color: Color(0xff8A8580),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Buttons
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: isProcessingRequest
                      ? null
                      : () async {
                          await _acceptRequest(request, setModalState);
                        },
                  child: Container(
                    height: 44,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xff5BAB8B),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'Accept',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'IBM Plex Sans',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: GestureDetector(
                  onTap: isProcessingRequest
                      ? null
                      : () async {
                          await _rejectRequest(request, setModalState);
                        },
                  child: Container(
                    height: 44,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xffE8A87C),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'Reject',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'IBM Plex Sans',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _showReceivedRequests() async {
    await showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      isScrollControlled: true,
      backgroundColor: const Color(0xffFBF8F2),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return PopScope(
              canPop: !isProcessingRequest,
              child: Stack(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.75,
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Donation requests',
                                  style: TextStyle(
                                    fontFamily: 'DM Serif Display',
                                    fontSize: 25,
                                  ),
                                ),
                                IconButton(
                                  onPressed: isProcessingRequest
                                      ? null
                                      : () {
                                          Navigator.pop(context);
                                        },
                                  icon: const Icon(Icons.close),
                                ),
                              ],
                            ),

                            const SizedBox(height: 8),

                            Text(
                              '${receivedRequests.length} pending request${receivedRequests.length == 1 ? '' : 's'}',
                              style: const TextStyle(
                                fontFamily: 'IBM Plex Sans',
                                fontSize: 14,
                                color: Color(0xff8A8580),
                              ),
                            ),

                            const SizedBox(height: 16),

                            Expanded(
                              child: receivedRequests.isEmpty
                                  ? const Center(
                                      child: Text(
                                        'No pending requests',
                                        style: TextStyle(
                                          fontFamily: 'IBM Plex Sans',
                                          color: Color(0xff8A8580),
                                        ),
                                      ),
                                    )
                                  : ListView.separated(
                                      itemCount: receivedRequests.length,
                                      separatorBuilder: (_, __) =>
                                          const SizedBox(height: 12),
                                      itemBuilder: (context, index) {
                                        final request = receivedRequests[index];

                                        return _requestCard(
                                          request,
                                          setModalState,
                                        );
                                      },
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Loading overlay
                  if (isProcessingRequest)
                    Positioned.fill(
                      child: AbsorbPointer(
                        absorbing: true,
                        child: Container(
                          color: Colors.black.withOpacity(0.35),
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xffE8A87C),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );

    if (mounted) {
      await loadProfile();
    }
  }

  UserModel? user;
  WalletModel? wallet;
  List<RequestModel> receivedRequests = [];
  bool requestsLoading = false;
  bool isProcessingRequest = false;
  bool isLoading = true;
  List<ItemModel> myItems = [];
  List<ItemModel> myClaims = [];
  List<ItemModel> myRequests = [];
  List<BidModel> myBids = [];
  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    final repo = ProfileRepositoryImpl();

    final results = await Future.wait([
      repo.getMyProfile(),
      repo.getMyWallet(),
      repo.getMyItems(),
      repo.getMyClaims(),
      repo.getMyRequests(),
      repo.getRecivedRequests(),
      repo.getMyBids(),
    ]);

    user = results[0] as UserModel;
    wallet = results[1] as WalletModel;
    myItems = results[2] as List<ItemModel>;
    myClaims = results[3] as List<ItemModel>;
    myRequests = results[4] as List<ItemModel>;

    final allReceivedRequests = results[5] as List<RequestModel>;

    receivedRequests = allReceivedRequests.where((request) {
      return request.status == 'pending' &&
          request.itemDetails?.listingType == 'donation';
    }).toList();

    myBids = results[6] as List<BidModel>;

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 56.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  /// Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Profile",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w400,
                          fontFamily: "DM Serif Display",
                        ),
                      ),

                      if (receivedRequests.isNotEmpty)
                        GestureDetector(
                          onTap: () async {
                            await _showReceivedRequests();
                          },
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: const Color(0xffFBF8F2),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: const Color(0xffD4D0CA),
                                  ),
                                ),
                                child: const Icon(
                                  Icons.notifications_none_rounded,
                                  color: Color(0xff8A8580),
                                  size: 27,
                                ),
                              ),

                              Positioned(
                                right: -4,
                                top: -4,
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  constraints: const BoxConstraints(
                                    minWidth: 20,
                                    minHeight: 20,
                                  ),
                                  decoration: const BoxDecoration(
                                    color: Color(0xffE8A87C),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${receivedRequests.length}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "IBM Plex Sans",
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  /// Avatar
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Color(0xffE8A87C)),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: user?.profilePictureUrl != null
                        ? Image.network(
                            user!.profilePictureUrl!,
                            fit: BoxFit.cover,
                          )
                        : Center(
                            child: Text(
                              user?.username?.substring(0, 1).toUpperCase() ??
                                  "?",
                            ),
                          ),
                  ),
                  const SizedBox(height: 8),

                  /// Name
                  Text(
                    user?.username ?? '',
                    style: const TextStyle(
                      fontFamily: "IBM Plex Sans",
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        "assets/images/star.svg",
                        width: 15,
                        height: 15,
                        colorFilter: ColorFilter.mode(
                          Color(0xffE8A87C),
                          BlendMode.srcIn,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          AppRouter.router.push('/ratings');
                        },
                        child: Text(
                          "${user?.averageRating ?? 0} (${user?.ratingCount ?? 0}) >>",
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  /// Edit Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          final updated = await AppRouter.router.push<bool>(
                            '/edit_profile',
                          );

                          if (updated == true) {
                            loadProfile();
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xffE8A87C),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          height: 36,
                          width: 127,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 22.0,
                              vertical: 9,
                            ),
                            child: Row(
                              children: [
                                SvgPicture.asset("assets/images/pen.svg"),
                                const SizedBox(width: 2),
                                const Text(
                                  "Profile settings",
                                  style: TextStyle(
                                    fontFamily: "IBM Plex Sans",
                                    fontSize: 10,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFFFFFFFF),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 13),
                      GestureDetector(
                        onTap: () {
                          AppRouter.router.push('/balance');
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xffE8A87C)),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          height: 36,
                          width: 127,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 22.0,
                              vertical: 9,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset("assets/images/packet2.svg"),
                                const SizedBox(width: 2),
                                Text(
                                  "${formatBalance(wallet?.balance ?? '0')} SYP",
                                  style: const TextStyle(
                                    fontFamily: "IBM Plex Sans",
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xffE8A87C),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  /// Tags
                  const SizedBox(height: 33),

                  /// Tabs
                  const TabBar(
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicatorColor: Color(0xffE8A87C),
                    labelColor: Color(0xffE8A87C),
                    unselectedLabelColor: Color(0xffB5B0A8),
                    labelStyle: TextStyle(
                      fontFamily: "IBM Plex Sans",
                      fontWeight: FontWeight.w600,
                    ),
                    tabs: [
                      Tab(text: "Listings"),
                      Tab(text: "Your items"),
                      Tab(text: "Requests"),
                      Tab(text: "Bids"),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// Tab Content
                  SizedBox(
                    height: 300,
                    child: TabBarView(
                      children: [
                        myItems.isEmpty
                            ? const Center(child: Text("No items yet"))
                            : GridView.builder(
                                itemCount: myItems.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 16,
                                      mainAxisSpacing: 16,
                                      childAspectRatio: 0.72,
                                    ),
                                itemBuilder: (context, index) {
                                  return ProductCard(item: myItems[index]);
                                },
                              ),

                        myClaims.isEmpty
                            ? const Center(child: Text("No requests yet"))
                            : GridView.builder(
                                itemCount: myClaims.length,
                                shrinkWrap: true,

                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 16,
                                      crossAxisSpacing: 16,
                                      childAspectRatio: 171 / 236,
                                    ),
                                itemBuilder: (context, index) {
                                  return ProductCard(item: myClaims[index]);
                                },
                              ),
                        myRequests.isEmpty
                            ? const Center(child: Text("No requests yet"))
                            : GridView.builder(
                                itemCount: myRequests.length,
                                shrinkWrap: true,

                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 16,
                                      crossAxisSpacing: 16,
                                      childAspectRatio: 171 / 236,
                                    ),
                                itemBuilder: (context, index) {
                                  return ProductCard(item: myRequests[index]);
                                },
                              ),
                        myBids.isEmpty
                            ? const Center(child: Text("No bids yet"))
                            : ListView.separated(
                                itemCount: myBids.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(height: 12),
                                itemBuilder: (context, index) {
                                  return _BidItem(
                                    bid: myBids[index],
                                    index: index,
                                  );
                                },
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget statItem(String number, String title) {
    return Column(
      children: [
        Text(
          number,
          style: const TextStyle(
            fontFamily: "IBM Plex Sans",
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            fontFamily: "IBM Plex Sans",
            color: Color(0xff8A8580),
          ),
        ),
      ],
    );
  }
}

String formatBalance(String balance) {
  final value = double.tryParse(balance) ?? 0;
  final isNegative = value < 0;
  final absValue = value.abs();

  String formatted;

  if (absValue >= 1000000) {
    formatted = "${(absValue / 1000000).toStringAsFixed(0)}M";
  } else if (absValue >= 1000) {
    formatted = "${(absValue / 1000).toStringAsFixed(1)}K";
  } else {
    formatted = absValue.toStringAsFixed(0);
  }

  return isNegative ? "-$formatted" : formatted;
}

class _BidItem extends StatelessWidget {
  final BidModel bid;
  final int index;

  const _BidItem({required this.bid, required this.index});

  @override
  Widget build(BuildContext context) {
    final user = bid.bidderUser;

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
                  "${bid.item!.name}",
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
