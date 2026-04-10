import 'package:dealura/features/home/view/widgets/custiom_filter_list.dart';
import 'package:dealura/features/home/view/widgets/custom_app_bar.dart';
import 'package:dealura/features/home/view/widgets/custom_search_bar.dart';
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
          ],
        ),
      ),
    );
  }
}
