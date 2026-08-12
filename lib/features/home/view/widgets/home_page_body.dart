import 'package:dealura/features/home/model/category_model.dart';
import 'package:dealura/features/home/model/item_model.dart';
import 'package:dealura/features/home/repository/home_repository_impl.dart';
import 'package:dealura/features/home/view/widgets/custom_filter_list.dart';
import 'package:dealura/features/home/view/widgets/custom_app_bar.dart';
import 'package:dealura/features/home/view/widgets/custom_search_bar.dart';
import 'package:dealura/features/product/view/widgets/product_card.dart';
import 'package:flutter/material.dart';

class HomePageBody extends StatefulWidget {
  final VoidCallback onSearchTap;

  const HomePageBody({super.key, required this.onSearchTap});

  @override
  State<HomePageBody> createState() => _HomePageBodyState();
}

class _HomePageBodyState extends State<HomePageBody> {
  final HomeRepositoryImpl repository = HomeRepositoryImpl();

  List<CategoryModel> categories = [];
  List<ItemModel> items = [];

  int? selectedCategoryId;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadInitialData();
  }

  Future<void> loadInitialData() async {
    categories = await repository.getCategoriesList();

    items = await repository.getItemsList(null, null, null);

    setState(() {
      isLoading = false;
    });
  }

  Future<void> selectCategory(int? categoryId) async {
    setState(() {
      selectedCategoryId = categoryId;
      isLoading = true;
    });

    items = await repository.getItemsList(categoryId, null, true);

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 45, left: 18, right: 18),
        child: Column(
          children: [
            const CustomAppBar(),

            const SizedBox(height: 39),

            CustomSearchBar(onTap: widget.onSearchTap),

            const SizedBox(height: 15),

            CustomFilterList(
              categories: categories,
              selectedCategoryId: selectedCategoryId,
              onCategorySelected: selectCategory,
            ),

            const SizedBox(height: 28),

            if (isLoading)
              const SizedBox(
                height: 500,
                child: Center(child: CircularProgressIndicator()),
              )
            else
              SizedBox(
                width: 358,
                height: 500,
                child: GridView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: items.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 171 / 236,
                  ),
                  itemBuilder: (context, index) {
                    return ProductCard(item: items[index]);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
