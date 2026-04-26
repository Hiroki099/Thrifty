import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push('/product_details', extra: 'sale');
      },
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        width: 171,
        height: 235,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Color(0xffD3D1C7), width: 1),
            ),
            child: Column(
              children: [
                // IMAGE
                Container(
                  height: 115,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                    color: Colors.black,
                    image: DecorationImage(
                      image: AssetImage('assets/images/product_image.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                  padding: EdgeInsets.all(12),
                  width: double.infinity,
                  height: 118,

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "MacBook Pro 14",
                        style: TextStyle(
                          fontFamily: "IBM Plex Sans",
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff1A1A1A),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "120,000 SYP",
                            style: TextStyle(
                              fontFamily: "IBM Plex Sans",
                              fontWeight: FontWeight.bold,
                              color: Color(0xffE8A87C),
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                "Damascus .",
                                style: TextStyle(
                                  color: Color(0xffB5B0A8),
                                  fontFamily: "IBM Plex Sans",
                                  fontSize: 11,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                "1h",
                                style: TextStyle(
                                  color: Color(0xffB5B0A8),
                                  fontFamily: "IBM Plex Sans",
                                  fontSize: 11,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
