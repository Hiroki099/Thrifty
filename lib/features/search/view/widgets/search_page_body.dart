import 'package:dealura/features/home/model/category_model.dart';
import 'package:dealura/features/home/model/item_model.dart';
import 'package:dealura/features/product/view/widgets/product_card.dart';
import 'package:dealura/features/search/view/pages/repository/search_repository_impl.dart';
import 'package:dealura/features/search/view/widgets/search_page_header.dart';
import 'package:flutter/material.dart';

class SearchPageBody extends StatefulWidget {
  const SearchPageBody({super.key});

  @override
  State<SearchPageBody> createState() => _SearchPageBodyState();
}

class _SearchPageBodyState extends State<SearchPageBody> {
  final SearchRepositoryImpl repository = SearchRepositoryImpl();
  String search = '';

  List<CategoryModel> categories = [];
  List<ItemModel> items = [];

  int? selectedCategoryId;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> searchItems(String value) async {
    search = value;

    setState(() {
      isLoading = true;
    });

    items = await repository.getItemsList(
      search,
      selectedCategoryId,
      null,
      null,
    );

    setState(() {
      isLoading = false;
    });
  }

  Future<void> loadData() async {
    setState(() {
      isLoading = true;
    });

    categories = await repository.getCategoriesList();

    items = await repository.getItemsList(null, selectedCategoryId, null, null);

    setState(() {
      isLoading = false;
    });
  }

  Future<void> selectCategory(int? id) async {
    setState(() {
      selectedCategoryId = id;
      isLoading = true;
    });

    items = await repository.getItemsList(
      search,
      selectedCategoryId,
      null,
      null,
    );

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 45.0, left: 18.0, right: 18.0),
            child: SearchHeader(
              categories: categories,
              selectedCategoryId: selectedCategoryId,
              onCategorySelected: selectCategory,
              onSearch: searchItems,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: 358,
            height: 596,
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Color(0xffE8A87C)),
                  )
                : items.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off_rounded,
                          size: 48,
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
                          'Try a different search or category.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'IBM Plex Sans',
                            fontSize: 13,
                            color: Color(0xff8A8580),
                          ),
                        ),
                      ],
                    ),
                  )
                : GridView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: items.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 171 / 236,
                        ),
                    itemBuilder: (context, index) {
                      return ProductCard(
                        item: items[index],
                        onRefresh: () {
                          if (search.isNotEmpty) {
                            searchItems(search);
                          } else {
                            loadData();
                          }
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
