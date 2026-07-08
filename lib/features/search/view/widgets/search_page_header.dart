import 'package:dealura/features/home/model/category_model.dart';
import 'package:dealura/features/home/view/widgets/custom_filter_list.dart';
import 'package:flutter/material.dart';

class SearchHeader extends StatelessWidget {
  final List<CategoryModel> categories;
  final int? selectedCategoryId;
  final Function(int?) onCategorySelected;
  final Function(String) onSearch;

  const SearchHeader({
    super.key,
    required this.categories,
    required this.selectedCategoryId,
    required this.onCategorySelected,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextFormField(onChanged: onSearch,
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
        CustomFilterList(
          categories: categories,
          selectedCategoryId: selectedCategoryId,
          onCategorySelected: onCategorySelected,
        ),
        SizedBox(height: 8),
      ],
    );
  }
}
