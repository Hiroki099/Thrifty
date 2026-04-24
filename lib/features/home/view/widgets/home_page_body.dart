import 'package:dealura/features/home/view/widgets/custiom_filter_list.dart';
import 'package:dealura/features/home/view/widgets/custom_app_bar.dart';
import 'package:dealura/features/home/view/widgets/custom_search_bar.dart';
import 'package:dealura/features/home/view/widgets/product_card.dart';
import 'package:flutter/material.dart';

class HomePageBody extends StatelessWidget {
  const HomePageBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 45.0, left: 16.0),
        child: Column(
          children: [
            CustomAppBar(),
            SizedBox(height: 39),
            CustomSearchBar(),
            SizedBox(height: 15),
            CustiomFilterList(),
            SizedBox(height: 28),
            SizedBox(
              width: 358,
              height: 560,
              child: GridView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: 20,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 171 / 235,
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
