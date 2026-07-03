
import 'package:dealura/features/search/view/widgets/search_page_header.dart';
import 'package:flutter/material.dart';

class SearchPageBody extends StatelessWidget {
  const SearchPageBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 45.0, left: 18.0, right: 18.0),
            child: SearchHeader(),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: 358,
            height: 596,
            child: GridView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: 20,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 171 / 236,
              ),
              itemBuilder: (context, index) {
                return null;
              
                // return ProductCard();
              },
            ),
          ),
        ],
      ),
    );
  }
}
