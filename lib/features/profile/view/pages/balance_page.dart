import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BalancePage extends StatelessWidget {
  const BalancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(right: 16.0, left: 16.0, top: 64.0),
          child: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: SvgPicture.asset(
                      'assets/images/go_back.svg',
                      width: 20,
                      height: 20,
                    ),
                  ),
                  SizedBox(width: 13),
                  const Text(
                    "balance",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      fontFamily: "DM Serif Display",
                    ),
                  ),
                ],
              ),
              SizedBox(height: 26),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 28, vertical: 28),
                width: 361,
                height: 182,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Color(0xffE8A87C), width: 1.5),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Available Balance",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        fontFamily: "IBM Plex Sans",
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "5000 SYP",
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w400,
                            fontFamily: "IBM Plex Sans",
                          ),
                        ),
                        SvgPicture.asset(
                          'assets/images/wallet.svg',
                          width: 80,
                          height: 80,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 26),
              DefaultTabController(
                length: 2,
                child: SizedBox(
                  height: 500,
                  child: Column(
                    children: [
                      const TabBar(
                        indicatorColor: Color(0xffE8A87C),
                        indicatorWeight: 2,
                        labelColor: Colors.black,
                        unselectedLabelColor: Color(0xff8A8580),
                        labelStyle: TextStyle(
                          fontFamily: "IBM Plex Sans",
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                        tabs: [
                          Tab(text: "Transactions"),
                          Tab(text: "Transfers"),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            ListView.separated(
                              itemCount: 10,
                              separatorBuilder: (_, _) =>
                                  const Divider(color: Color(0xffE5E2DC)),
                              itemBuilder: (context, index) {
                                return const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "You purchased iphone 16 pro from Amy M.",
                                        style: TextStyle(
                                          fontFamily: "IBM Plex Sans",
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        "500k SYP was transferred to Amy M.",
                                        style: TextStyle(
                                          fontFamily: "IBM Plex Sans",
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            ListView.separated(
                              itemCount: 10,
                              separatorBuilder: (_, _) =>
                                  const Divider(color: Color(0xffE5E2DC)),
                              itemBuilder: (context, index) {
                                return const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "20k SYP was transferred to your account",
                                        style: TextStyle(
                                          fontFamily: "IBM Plex Sans",
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        "3:07 PM",
                                        style: TextStyle(
                                          color: Color(0xff8A8580),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
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
            ],
          ),
        ),
      ),
    );
  }
}
