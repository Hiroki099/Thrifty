import 'package:dealura/features/home/model/category_model.dart';
import 'package:flutter/material.dart';

class SelectCateygoryWidget extends StatelessWidget {
  const SelectCateygoryWidget({
    super.key,
    required this.isLoadingCategories,
    required this.selectedCategory,
    required this.categories,
  });

  final bool isLoadingCategories;
  final CategoryModel? selectedCategory;
  final List<CategoryModel> categories;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Category",
          style: TextStyle(
            fontSize: 15,
            fontFamily: "IBM Plex Sans",
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 5),

        isLoadingCategories
            ? const Center(child: CircularProgressIndicator())
            : Container(
                height: 56,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xffE5E2DC)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<CategoryModel>(
                    value: selectedCategory,
                    isExpanded: true,
                    hint: const Text("Select category"),
                    items: categories.map((category) {
                      return DropdownMenuItem<CategoryModel>(
                        value: category,
                        child: Text(category.name ?? ""),
                      );
                    }).toList(),
                    onChanged: (value) {},
                  ),
                ),
              ),
      ],
    );
  }
}
