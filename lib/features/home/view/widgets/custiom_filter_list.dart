import 'package:dealura/features/home/model/category_model.dart';
import 'package:dealura/features/home/view/widgets/filter_item.dart';
import 'package:flutter/material.dart';

class CustiomFilterList extends StatelessWidget {
  const CustiomFilterList({
    super.key,
    required this.categories,
    required this.selectedCategoryId,
    required this.onCategorySelected,
  });

  final List<CategoryModel> categories;
  final int? selectedCategoryId;
  final Function(int?) onCategorySelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 35,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          FilterItem(
            title: "All",
            isSelected: selectedCategoryId == null,
            onTap: () => onCategorySelected(null),
          ),

          ...categories.map(
            (category) => FilterItem(
              title: category.name ?? "",
              isSelected: selectedCategoryId == category.id,
              onTap: () => onCategorySelected(category.id),
            ),
          ),
        ],
      ),
    );
  }
}
