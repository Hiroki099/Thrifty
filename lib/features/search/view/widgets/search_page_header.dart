import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SearchHeader extends StatelessWidget {
  const SearchHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SizedBox(width: 13),
            SvgPicture.asset('assets/images/go_back.svg'),
            const SizedBox(width: 41),
            Expanded(
              child: TextFormField(
                style: TextStyle(
                  color: const Color(0xff1A1A1A),
                  fontFamily: "IBM Plex Sans",
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(
                      color: const Color(0xffE8A87C),
                      width: 1.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(
                      color: const Color(0xffE8A87C),
                      width: 1.5,
                    ),
                  ),
                  hintText: 'Search',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  filled: true,
                  fillColor: const Color(0xffFBF8F2),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        SizedBox(
          width: 361,
          height: 30,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 10,
            itemBuilder: (context, index) => Container(
              width: 90,
              height: 30,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: const Color(0xffFDF3EC),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  'Damascus',
                  style: TextStyle(
                    color: const Color(0xffE7A072),
                    fontFamily: "IBM Plex Sans",
                    fontSize: 13,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(left: 4.0),
          child: Text(
            '4 results for "Damascus"',
            style: TextStyle(
              color: const Color(0xff8A8580),
              fontFamily: "IBM Plex Sans",
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
