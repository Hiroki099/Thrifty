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
    setState(() {
      isLoading = true;
    });

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

    items = await repository.getItemsList(categoryId, null, null);

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
            else if (items.isEmpty)
              SizedBox(
                width: double.infinity,
                height: 300,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 24,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xffFBF8F2),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xffEFE9E2)),
                    ),
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.inventory_2_outlined,
                          size: 46,
                          color: Color(0xffE8A87C),
                        ),
                        SizedBox(height: 14),
                        Text(
                          'No items found',
                          style: TextStyle(
                            fontFamily: 'IBM Plex Sans',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff24211E),
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'There are no items in this category.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'IBM Plex Sans',
                            fontSize: 13,
                            color: Color(0xff8A8580),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
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
                    return ProductCard(
                      item: items[index],
                      onRefresh: loadInitialData,
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
