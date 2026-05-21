import 'package:dealura/core/utls/app_router.dart';
import 'package:dealura/features/product/view/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
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
                      SvgPicture.asset("assets/images/packet.svg"),
                    ],
                  ),

                  const SizedBox(height: 6),

                  /// Avatar
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        color: const Color(0xFFE8A87C),
                        width: 2,
                      ),
                    ),
                    width: 80,
                    height: 80,
                    child: const Center(
                      child: Text(
                        "S",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w400,
                          fontFamily: "DM Serif Display",
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  /// Name
                  const Text(
                    "Sarah M.",
                    style: TextStyle(
                      fontFamily: "IBM Plex Sans",
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const Text(
                    "Damascus,Syria",
                    style: TextStyle(
                      fontFamily: "IBM Plex Sans",
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff8A8580),
                    ),
                  ),

                  const SizedBox(height: 18),

                  /// Edit Button
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
                  const SizedBox(height: 18),

                  /// Stats
                  SizedBox(
                    width: 242,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        statItem("13", "Listings"),
                        statItem("22", "Deals"),
                        statItem("4.5", "Ratings"),
                        statItem("2", "Donations"),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  /// Tags
                  SizedBox(
                    width: 319,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 30,
                          width: 90,
                          decoration: BoxDecoration(
                            color: const Color(0xffF3EDE4),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                              right: 10,
                              left: 15,
                              top: 6,
                              bottom: 6,
                            ),
                            child: Row(
                              children: [
                                SvgPicture.asset("assets/images/check.svg"),
                                const SizedBox(width: 4),
                                const Text(
                                  "verified",
                                  style: TextStyle(
                                    fontFamily: 'IBM Plex Sans',
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        Container(
                          height: 30,
                          width: 90,
                          decoration: BoxDecoration(
                            color: const Color(0xffF3EDE4),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                              right: 10,
                              left: 10,
                              top: 6,
                              bottom: 6,
                            ),
                            child: Row(
                              children: [
                                SvgPicture.asset("assets/images/star.svg"),
                                const SizedBox(width: 4),
                                const Text(
                                  "4.5 stars",
                                  style: TextStyle(
                                    fontFamily: 'IBM Plex Sans',
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        Container(
                          height: 30,
                          width: 90,
                          decoration: BoxDecoration(
                            color: const Color(0xffF3EDE4),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.only(
                              right: 12,
                              left: 12,
                              top: 6,
                              bottom: 6,
                            ),
                            child: Row(
                              children: [
                                Text(
                                  "5 donations",
                                  style: TextStyle(
                                    fontFamily: 'IBM Plex Sans',
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 33),

                  /// Tabs
                  const TabBar(
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
                            return const ProductCard();
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
