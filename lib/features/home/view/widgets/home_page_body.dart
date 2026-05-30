import 'package:dealura/features/home/view/widgets/custiom_filter_list.dart';
import 'package:dealura/features/home/view/widgets/custom_app_bar.dart';
import 'package:dealura/features/home/view/widgets/custom_search_bar.dart';
import 'package:dealura/features/product/view/widgets/product_card.dart';
import 'package:flutter/material.dart';

class HomePageBody extends StatelessWidget {
  final VoidCallback onSearchTap;
  const HomePageBody({super.key, required this.onSearchTap});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 45.0, left: 18.0, right: 18.0),
        child: Column(
          children: [
            CustomAppBar(),
            SizedBox(height: 39),
            CustomSearchBar(onTap: onSearchTap),
            SizedBox(height: 15),
            CustiomFilterList(),
            SizedBox(height: 28),
            SizedBox(
              width: 357,
              height: 517,
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
                  return ProductCard();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
