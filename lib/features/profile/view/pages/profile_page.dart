import 'package:dealura/core/utls/app_router.dart';
import 'package:dealura/features/auth/model/user_model.dart';
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
  UserModel? user;
  WalletModel? wallet;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    user = await ProfileRepositoryImpl().getMyProfile();
    wallet = await ProfileRepositoryImpl().getMyWallet();
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
      length: 3,
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
                      Text(
                        "${user?.averageRating ?? 0} (${user?.ratingCount ?? 0})",
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  /// Edit Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          AppRouter.router.push('/edit_profile');
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
                                  "Edit profile",
                                  style: TextStyle(
                                    fontFamily: "IBM Plex Sans",
                                    fontSize: 13,
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
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// Tab Content
                  SizedBox(
                    height: 500,
                    child: TabBarView(
                      children: [
                        GridView.builder(
                          shrinkWrap: true,
                          itemCount: 11,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                childAspectRatio: 0.72,
                              ),
                          itemBuilder: (context, index) {
                            return null;

                            // return const ProductCard();
                          },
                        ),

                        const Center(child: Text("Your items content here")),

                        const Center(child: Text("Requests content here")),
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
