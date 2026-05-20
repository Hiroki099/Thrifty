import 'dart:io';

import 'package:dealura/core/utls/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PublishPage extends StatefulWidget {
  const PublishPage({super.key});

  @override
  State<PublishPage> createState() => _PublishPageState();
}

class _PublishPageState extends State<PublishPage> {
  String selectedType = "Sale";
  List<File> images = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 25, right: 16, left: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Header
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        AppRouter.router.pop();
                      },
                      child: SvgPicture.asset('assets/images/X.svg'),
                    ),

                    const SizedBox(width: 14),

                    const Text(
                      "New listing",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: "IBM Plex Sans",
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                /// Listing type
                const Text(
                  "Listing type",
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: "IBM Plex Sans",
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    PublishOption(
                      text: "Sale",
                      icon: Icons.sell_outlined,
                      isSelected: selectedType == "Sale",
                      onTap: () {
                        setState(() {
                          selectedType = "Sale";
                        });
                      },
                    ),
                    SizedBox(width: 12),

                    PublishOption(
                      text: "Donate",
                      icon: Icons.card_giftcard,
                      isSelected: selectedType == "Donate",
                      onTap: () {
                        setState(() {
                          selectedType = "Donate";
                        });
                      },
                    ),
                    SizedBox(width: 12),

                    PublishOption(
                      text: "Auction",
                      icon: Icons.bolt,
                      isSelected: selectedType == "Auction",
                      onTap: () {
                        setState(() {
                          selectedType = "Auction";
                        });
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                const Text(
                  "Photos (up to 5)",
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: "IBM Plex Sans",
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 16),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xffF3EDE4),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xffE5E2DC)),
                  ),
                  child: Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      ...images.map(
                        (image) => Stack(
                          children: [
                            Container(
                              width: 95,
                              height: 95,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                image: DecorationImage(
                                  image: FileImage(image),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),

                            Positioned(
                              top: 4,
                              right: 4,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    images.remove(image);
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Colors.black54,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      if (images.length < 5)
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            width: 95,
                            height: 95,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: const Color(0xffE5E2DC),
                              ),
                              color: Colors.white,
                            ),
                            child: const Icon(
                              Icons.add,
                              color: Color(0xffB5B0A8),
                              size: 30,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 13),

                /// Title
                const Text(
                  "Title",
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: "IBM Plex Sans",
                    fontWeight: FontWeight.w400,
                  ),
                ),

                const SizedBox(height: 5),

                textField(),

                const SizedBox(height: 5),

                /// Price
                const Text(
                  "Price (SYP)",
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: "IBM Plex Sans",
                    fontWeight: FontWeight.w400,
                  ),
                ),

                const SizedBox(height: 5),

                textField(),

                const SizedBox(height: 5),

                /// Category
                const Text(
                  "Category",
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: "IBM Plex Sans",
                    fontWeight: FontWeight.w400,
                  ),
                ),

                const SizedBox(height: 5),

                textField(),

                const SizedBox(height: 30),

                /// Button
                Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    color: const Color(0xffE8A87C),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    "Publish listing",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      fontFamily: "IBM Plex Sans",
                    ),
                  ),
                ),
                SizedBox(height: 47),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PublishOption extends StatelessWidget {
  const PublishOption({
    super.key,
    required this.text,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String text;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 112,
        height: 116,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected
                ? const Color(0xffE8A87C)
                : const Color(0xffE5E2DC),
            width: 1.5,
          ),
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 28,
              color: isSelected
                  ? const Color(0xffE8A87C)
                  : const Color(0xffB5B0A8),
            ),

            const SizedBox(height: 12),

            Text(
              text,
              style: TextStyle(
                fontSize: 15,
                fontFamily: "IBM Plex Sans",
                fontWeight: FontWeight.w500,
                color: isSelected ? const Color(0xffE8A87C) : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget textField() {
  return Container(
    height: 56,
    decoration: BoxDecoration(
      color: Color(0xffFFFFFF),
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: const Color(0xffE5E2DC)),
    ),
    child: const TextField(
      decoration: InputDecoration(
        border: InputBorder.none,
        contentPadding: EdgeInsets.symmetric(horizontal: 16),
      ),
    ),
  );
}
