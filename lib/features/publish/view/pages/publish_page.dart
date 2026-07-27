import 'dart:io';
import 'package:dealura/features/home/model/category_model.dart';
import 'package:dealura/features/home/repository/home_repository_impl.dart';
import 'package:dealura/core/utls/app_router.dart';
import 'package:dealura/features/publish/repository/publish_item_repository_impl.dart';
import 'package:dealura/features/publish/view/widgets/custom_publsih_textfield.dart';
import 'package:dealura/features/publish/view/widgets/listing_type_widget.dart';
import 'package:dealura/features/publish/view/widgets/publish_button.dart';
import 'package:dealura/features/publish/view/widgets/publish_theme.dart';
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
  bool isPublishing = false;

  bool validateFields() {
    if (titleController.text.trim().isEmpty) return false;

    if (descriptionController.text.trim().isEmpty) return false;

    if (selectedCategory == null) return false;

    if (images.isEmpty) return false;

    if (selectedType != ListingType.donation) {
      if (priceController.text.trim().isEmpty) return false;

      if (double.tryParse(priceController.text.trim()) == null) {
        return false;
      }
    }

    return true;
  }

  void clearFields() {
    titleController.clear();
    priceController.clear();
    descriptionController.clear();

    setState(() {
      images.clear();
      selectedCategory = null;
      selectedType = ListingType.sale;
    });
  }

  final TextEditingController titleController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
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

  ListingType selectedType = ListingType.sale;
  List<File> images = [];

  @override
  Widget build(BuildContext context) {
    final currentColor = PublishTheme.color(selectedType);
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
                ListingTypeWidget(
                  selectedType: selectedType,
                  onChanged: (type) {
                    setState(() {
                      selectedType = type;
                    });
                  },
                ),

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

                CustomPublishTextField(
                  controller: titleController,
                  color: currentColor,
                ),

                const SizedBox(height: 5),

                /// Price
                if (selectedType != ListingType.donation) ...[
                  Text(
                    selectedType == ListingType.auction
                        ? "Starting Price (SYP)"
                        : "Price (SYP)",
                    style: const TextStyle(
                      fontSize: 15,
                      fontFamily: "IBM Plex Sans",
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 5),
                  CustomPublishTextField(
                    controller: priceController,
                    color: currentColor,
                  ),
                  const SizedBox(height: 5),
                ],

                /// Category
                SelectCategoryWidget(
                  isLoadingCategories: isLoadingCategories,
                  selectedCategory: selectedCategory,
                  categories: categories,
                  onCategorySelected: (category) {
                    setState(() {
                      selectedCategory = category;
                    });
                  },
                ),
                const SizedBox(height: 5),

                const Text(
                  "Description",
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: "IBM Plex Sans",
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 5),

                CustomPublishTextField(
                  controller: descriptionController,
                  color: currentColor,
                ),

                const SizedBox(height: 30),

                /// Button
                PublishButton(
                  onPressed: () async {
                    if (!validateFields()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please fill in all required fields."),
                        ),
                      );
                      return;
                    }

                    setState(() {
                      isPublishing = true;
                    });

                    try {
                      final repository = PublishRepositoryImpl();

                      switch (selectedType) {
                        case ListingType.sale:
                          await repository.publishFixedPrice(
                            name: titleController.text.trim(),
                            description: descriptionController.text.trim(),
                            price: double.parse(priceController.text),
                            categoryId: selectedCategory!.id!,
                            images: images,
                          );
                          break;

                        case ListingType.donation:
                          // publishDonation()
                          break;

                        case ListingType.auction:
                          // publishAuction()
                          break;
                      }

                      clearFields();

                      if (!mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: Colors.green,
                          content: Text("Listing published successfully."),
                        ),
                      );
                    } catch (e) {
                      if (!mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.red,
                          content: Text("Failed to publish listing.\n$e"),
                        ),
                      );
                    } finally {
                      if (mounted) {
                        setState(() {
                          isPublishing = false;
                        });
                      }
                    }
                  },
                  color: currentColor,
                ),
                SizedBox(height: 47),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
