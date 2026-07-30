import 'package:dealura/features/home/model/item_model.dart';
import 'package:flutter/material.dart';

class EditProductBottomSheet extends StatefulWidget {
  const EditProductBottomSheet({
    super.key,
    required this.product,
    required this.onSave,
  });

  final ItemModel product;
  final Future<void> Function(Map<String, dynamic> body) onSave;

  @override
  State<EditProductBottomSheet> createState() => _EditProductBottomSheetState();
}

class _EditProductBottomSheetState extends State<EditProductBottomSheet> {
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController priceController;

  bool loading = false;

  late Color primaryColor;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(text: widget.product.name);

    descriptionController = TextEditingController(
      text: widget.product.description,
    );

    priceController = TextEditingController(
      text: widget.product.price?.toString() ?? "",
    );

    switch (widget.product.listingType) {
      case "auction":
        primaryColor = const Color(0xFF8B7EC8);
        break;

      case "donation":
        primaryColor = const Color(0xFF5BAB8B);
        break;

      default:
        primaryColor = const Color(0xFFE8A87C);
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    super.dispose();
  }

  InputDecoration decoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.all(16),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: primaryColor, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 45,
                height: 5,
                decoration: BoxDecoration(
                  color: const Color(0xffD3D1C7),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),

            const SizedBox(height: 28),

            const Text(
              "Edit Product",
              style: TextStyle(fontFamily: "DM Serif Display", fontSize: 28),
            ),

            const SizedBox(height: 8),

            const Text(
              "Update your product information.",
              style: TextStyle(color: Color(0xff8A8580)),
            ),

            const SizedBox(height: 25),

            const Text("Product Name"),

            const SizedBox(height: 10),

            TextField(
              controller: nameController,
              decoration: decoration("Enter product name"),
            ),

            const SizedBox(height: 18),

            const Text("Description"),

            const SizedBox(height: 10),

            TextField(
              controller: descriptionController,
              maxLines: 4,
              decoration: decoration("Description"),
            ),

            if (widget.product.listingType == "fixed_price") ...[
              const SizedBox(height: 18),

              const Text("Price"),

              const SizedBox(height: 10),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: decoration("Price"),
              ),
            ],

            const SizedBox(height: 28),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: loading
                    ? null
                    : () async {
                        setState(() {
                          loading = true;
                        });

                        final body = {
                          "name": nameController.text.trim(),
                          "description": descriptionController.text.trim(),
                        };

                        if (widget.product.listingType == "fixed_price") {
                          body["price"] = priceController.text.trim();
                        }

                        await widget.onSave(body);

                        if (mounted) {
                          Navigator.pop(context);
                        }
                      },
                child: loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Save Changes",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
