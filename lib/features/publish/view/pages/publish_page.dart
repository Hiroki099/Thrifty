import 'dart:io';
import 'package:dealura/features/home/model/category_model.dart';
import 'package:dealura/features/home/repository/home_repository_impl.dart';
import 'package:dealura/core/utls/app_router.dart';
import 'package:dealura/features/publish/view/widgets/listing_type_widget.dart';
import 'package:dealura/features/publish/view/widgets/publish_button.dart';
import 'package:dealura/features/publish/view/widgets/select_category_widget.dart';
import 'package:dealura/features/publish/view/widgets/select_images_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

class PublishPage extends StatefulWidget {
  const PublishPage({super.key});

  @override
  State<PublishPage> createState() => _PublishPageState();
}

class _PublishPageState extends State<PublishPage> {
  @override
  void initState() {
    super.initState();
    loadCategories();
  }

  List<CategoryModel> categories = [];
  CategoryModel? selectedCategory;

  bool isLoadingCategories = true;
  Future<void> loadCategories() async {
    final HomeRepositoryImpl homeRepository = HomeRepositoryImpl();
    final result = await homeRepository.getCategoriesList();

    setState(() {
      categories = result;
      isLoadingCategories = false;
    });
  }

  final ImagePicker _picker = ImagePicker();

  Future<void> pickImages() async {
    final pickedImages = await _picker.pickMultiImage(imageQuality: 80);

    if (pickedImages.isEmpty) return;

    setState(() {
      final remaining = 5 - images.length;

      images.addAll(pickedImages.take(remaining).map((e) => File(e.path)));
    });
  }

  String selectedType = "Sale";
  List<File> images = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 25, right: 16, left: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Header
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        AppRouter.router.pop();
                      },
                      child: SvgPicture.asset('assets/images/X.svg'),
                    ),

                    const SizedBox(width: 14),

                    const Text(
                      "New listing",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: "IBM Plex Sans",
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                /// Listing type
                ListingTypeWidget(),

                const SizedBox(height: 28),

                const Text(
                  "Photos (up to 5)",
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: "IBM Plex Sans",
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 16),

                /// Images
                ImagePickerGrid(
                  images: images,
                  onAddPressed: pickImages,
                  onRemovePressed: (imageToRemove) {
                    setState(() {
                      images.remove(imageToRemove);
                    });
                  },
                ),
                const SizedBox(height: 13),

                /// Title
                const Text(
                  "Title",
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: "IBM Plex Sans",
                    fontWeight: FontWeight.w400,
                  ),
                ),

                const SizedBox(height: 5),

                textField(),

                const SizedBox(height: 5),

                /// Price
                const Text(
                  "Price (SYP)",
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: "IBM Plex Sans",
                    fontWeight: FontWeight.w400,
                  ),
                ),

                const SizedBox(height: 5),

                textField(),

                const SizedBox(height: 5),

                /// Category
                SelectCateygoryWidget(
                  isLoadingCategories: isLoadingCategories,
                  selectedCategory: selectedCategory,
                  categories: categories,
                ),
                const SizedBox(height: 16),

                const Text(
                  "Description",
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: "IBM Plex Sans",
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 5),

                textField(),

                const SizedBox(height: 30),

                /// Button
                PublishButton(),
                SizedBox(height: 47),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget textField() {
  return Container(
    height: 56,
    decoration: BoxDecoration(
      color: Color(0xffFFFFFF),
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: const Color(0xffE5E2DC)),
    ),
    child: const TextField(
      decoration: InputDecoration(
        border: InputBorder.none,
        contentPadding: EdgeInsets.symmetric(horizontal: 16),
      ),
    ),
  );
}
