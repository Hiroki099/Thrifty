import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Color(0xffD3D1C7), width: 1),
      ),
      height: 237,
      width: 171,
      child: Column(
        children: [
          Container(
            height: 117,
            width: 171,
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              image: DecorationImage(
                image: AssetImage('assets/images/product_image.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            width: 171,
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
                    fontWeight: FontWeight.w500,
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
    );
  }
}
