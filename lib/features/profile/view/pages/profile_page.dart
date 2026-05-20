import 'package:dealura/features/product/view/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 56.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Profile",
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w400,
                      fontFamily: "DM Serif Display",
                    ),
                  ),
                  SvgPicture.asset("assets/images/packet.svg"),
                ],
              ),
              SizedBox(height: 6),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(color: Color(0xFFE8A87C), width: 2),
                ),
                width: 80,
                height: 80,
                child: Center(
                  child: Text(
                    "S",
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w400,
                      fontFamily: "DM Serif Display",
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Sarah M.",
                style: TextStyle(
                  fontFamily: "IBM Plex Sans",
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Damascus,Syria",
                style: TextStyle(
                  fontFamily: "IBM Plex Sans",
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff8A8580),
                ),
              ),
              SizedBox(height: 18),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xffE8A87C),
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
                      SizedBox(width: 2),
                      Text(
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
              SizedBox(height: 18),
              SizedBox(
                width: 242,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text(
                          "13",
                          style: TextStyle(
                            fontFamily: "IBM Plex Sans",
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Listings",
                          style: TextStyle(
                            fontSize: 13,
                            fontFamily: "IBM Plex Sans",
                            color: Color(0xff8A8580),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          "22",
                          style: TextStyle(
                            fontFamily: "IBM Plex Sans",
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Deals",
                          style: TextStyle(
                            fontSize: 13,
                            fontFamily: "IBM Plex Sans",
                            color: Color(0xff8A8580),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          "4.5",
                          style: TextStyle(
                            fontFamily: "IBM Plex Sans",
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Ratings",
                          style: TextStyle(
                            fontSize: 13,
                            fontFamily: "IBM Plex Sans",
                            color: Color(0xff8A8580),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          "2",
                          style: TextStyle(
                            fontFamily: "IBM Plex Sans",
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Donations",
                          style: TextStyle(
                            fontSize: 13,
                            fontFamily: "IBM Plex Sans",
                            color: Color(0xff8A8580),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 18),
              SizedBox(
                width: 319,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 30,
                      width: 90,
                      decoration: BoxDecoration(
                        color: Color(0xffF3EDE4),
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
                            SizedBox(width: 4),
                            Text(
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
                        color: Color(0xffF3EDE4),
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
                            SizedBox(width: 4),
                            Text(
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
                        color: Color(0xffF3EDE4),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
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
              SizedBox(height: 33),
              DefaultTabController(
                length: 3,
                child: Column(
                  children: [
                    /// Tabs
                    TabBar(
                      indicatorColor: const Color(0xffE8A87C),
                      labelColor: const Color(0xffE8A87C),
                      unselectedLabelColor: const Color(0xffB5B0A8),
                      labelStyle: const TextStyle(
                        fontFamily: "IBM Plex Sans",
                        fontWeight: FontWeight.w600,
                      ),
                      tabs: const [
                        Tab(text: "Listings"),
                        Tab(text: "Your items"),
                        Tab(text: "Requests"),
                      ],
                    ),

                    /// Content
                    SizedBox(
                      height: 1000, 
                      child: TabBarView(
                        children: [
                          GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                ),
                            itemBuilder: (context, index) {
                              return ProductCard();
                            },
                            itemCount: 6,
                          ),

                          /// Your items Tab
                          Center(child: Text("Your items content here")),

                          /// Requests Tab
                          Center(child: Text("Requests content here")),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
