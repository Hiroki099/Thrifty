import 'package:dealura/features/product/models/RatingModel.dart';
import 'package:dealura/features/product/view/widgets/star_rating_widget.dart';
import 'package:dealura/features/profile/repository/profile_repository_impl.dart';
import 'package:dealura/features/profile/view/pages/Ratings_page.dart';
import 'package:flutter/material.dart';

class RatingListItem extends StatelessWidget {
  const RatingListItem({
    super.key,
    required this.rating,
    required this.isReceived,
    this.onRatingUpdated,
  });

  final RatingModel rating;
  final bool isReceived;

  final VoidCallback? onRatingUpdated;

  static const Color backgroundColor = Color(0xffFFFFFF);
  static const Color primaryColor = Color(0xffE8A87C);
  static const Color textColor = Color(0xff24211E);
  static const Color secondaryTextColor = Color(0xff8A8580);
  static const Color avatarBackground = Color(0xffF3EDE4);

  Future<void> _deleteRating(BuildContext context) async {
    if (rating.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to delete this rating')),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xffFBF8F2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: const Text(
            'Delete rating?',
            style: TextStyle(
              fontFamily: 'DM Serif Display',
              fontSize: 23,
              color: Color(0xff24211E),
            ),
          ),
          content: const Text(
            'Are you sure you want to delete this rating? This action cannot be undone.',
            style: TextStyle(
              fontFamily: 'IBM Plex Sans',
              fontSize: 14,
              height: 1.4,
              color: Color(0xff8A8580),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  fontFamily: 'IBM Plex Sans',
                  fontWeight: FontWeight.w500,
                  color: Color(0xff8A8580),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text(
                'Delete',
                style: TextStyle(
                  fontFamily: 'IBM Plex Sans',
                  fontWeight: FontWeight.w600,
                  color: Color(0xffC96F5B),
                ),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    try {
      await ProfileRepositoryImpl().deleteRate(rating.id);

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Rating deleted successfully'),
          backgroundColor: Colors.green,
        ),
      );

      onRatingUpdated?.call();
    } catch (e) {
      debugPrint('DELETE RATING ERROR: $e');

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to delete rating'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _showEditRatingSheet(BuildContext context) async {
    if (rating.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to edit this rating')),
      );
      return;
    }

    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xffFBF8F2),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) {
        return EditRatingBottomSheet(rating: rating);
      },
    );

    if (result == true) {
      onRatingUpdated?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = isReceived ? rating.rater : rating.seller;

    final username = user?.username?.trim().isNotEmpty == true
        ? user!.username!
        : "Unknown user";

    final hasComment =
        rating.comment != null && rating.comment!.trim().isNotEmpty;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.fromLTRB(14, 13, 14, 14),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xffEFE9E2), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAvatar(user?.profilePictureUrl),

              const SizedBox(width: 11),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            username,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              fontFamily: "IBM Plex Sans",
                              color: textColor,
                              height: 1.2,
                            ),
                          ),
                        ),

                        if (rating.createdAt != null) ...[
                          const SizedBox(width: 8),
                          Text(
                            formatRatingDate(rating.createdAt!),
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                              fontFamily: "IBM Plex Sans",
                              color: secondaryTextColor,
                            ),
                          ),
                        ],
                      ],
                    ),

                    const SizedBox(height: 6),

                    Row(
                      children: [
                        StarRating(
                          rating: (rating.rating ?? 0).toDouble(),
                          size: 17,
                        ),

                        const SizedBox(width: 7),

                        Text(
                          '${rating.rating ?? 0}.0',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            fontFamily: "IBM Plex Sans",
                            color: secondaryTextColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              if (!isReceived) ...[
                const SizedBox(width: 5),

                // Edit
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      _showEditRatingSheet(context);
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: const Padding(
                      padding: EdgeInsets.all(6),
                      child: Icon(
                        Icons.edit_outlined,
                        size: 19,
                        color: Color(0xff8A8580),
                      ),
                    ),
                  ),
                ),

                // Delete
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      _deleteRating(context);
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: const Padding(
                      padding: EdgeInsets.all(6),
                      child: Icon(
                        Icons.delete_outline_rounded,
                        size: 19,
                        color: Color(0xffC96F5B),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),

          if (hasComment) ...[
            const SizedBox(height: 11),

            Padding(
              padding: const EdgeInsets.only(left: 63),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(11, 9, 11, 9),
                decoration: BoxDecoration(
                  color: const Color(0xffFBF8F3),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  rating.comment!.trim(),
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.4,
                    fontFamily: "IBM Plex Sans",
                    fontWeight: FontWeight.w400,
                    color: textColor,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAvatar(String? imageUrl) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: avatarBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: imageUrl == null || imageUrl.isEmpty
          ? const Icon(
              Icons.person_outline_rounded,
              size: 25,
              color: Color(0xffB5AEA5),
            )
          : Image.network(
              imageUrl,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) {
                return const Icon(
                  Icons.person_outline_rounded,
                  size: 25,
                  color: Color(0xffB5AEA5),
                );
              },
            ),
    );
  }
}

class EditRatingBottomSheet extends StatefulWidget {
  const EditRatingBottomSheet({super.key, required this.rating});

  final RatingModel rating;

  @override
  State<EditRatingBottomSheet> createState() => _EditRatingBottomSheetState();
}

class _EditRatingBottomSheetState extends State<EditRatingBottomSheet> {
  late final TextEditingController commentController;

  late int selectedRating;

  bool isSaving = false;

  static const Color primaryColor = Color(0xffE8A87C);
  static const Color textColor = Color(0xff24211E);
  static const Color secondaryTextColor = Color(0xff8A8580);

  @override
  void initState() {
    super.initState();

    selectedRating = widget.rating.rating ?? 5;

    commentController = TextEditingController(
      text: widget.rating.comment ?? '',
    );
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  Future<void> _saveRating() async {
    if (isSaving) return;

    final rateId = widget.rating.id;
    if (rateId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Rating ID is missing')));
      return;
    }

    final newComment = commentController.text.trim();

    setState(() {
      isSaving = true;
    });

    try {
      final repository = ProfileRepositoryImpl();

      await repository.editRate(rateId, newComment, selectedRating);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Rating updated successfully'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      debugPrint('EDIT RATING ERROR: $e');

      if (!mounted) return;

      setState(() {
        isSaving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to update rating'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(24, 24, 24, 24 + bottomInset),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Edit your rating',
                        style: TextStyle(
                          fontFamily: 'DM Serif Display',
                          fontSize: 25,
                          color: textColor,
                        ),
                      ),

                      const SizedBox(height: 5),
                      const Text(
                        'Update your experience',
                        style: TextStyle(
                          fontFamily: 'IBM Plex Sans',
                          fontSize: 14,
                          color: secondaryTextColor,
                        ),
                      ),
                    ],
                  ),
                ),

                IconButton(
                  onPressed: isSaving ? null : () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.close_rounded,
                    color: secondaryTextColor,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),
            const Center(
              child: Text(
                'Your rating',
                style: TextStyle(
                  fontFamily: 'IBM Plex Sans',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: secondaryTextColor,
                ),
              ),
            ),

            const SizedBox(height: 12),

            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(5, (index) {
                  final starNumber = index + 1;

                  return GestureDetector(
                    onTap: isSaving
                        ? null
                        : () {
                            setState(() {
                              selectedRating = starNumber;
                            });
                          },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: Icon(
                        starNumber <= selectedRating
                            ? Icons.star_rounded
                            : Icons.star_outline_rounded,
                        size: 37,
                        color: primaryColor,
                      ),
                    ),
                  );
                }),
              ),
            ),

            const SizedBox(height: 8),

            Center(
              child: Text(
                '$selectedRating / 5',
                style: const TextStyle(
                  fontFamily: 'IBM Plex Sans',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ),

            const SizedBox(height: 24),
            const Text(
              'Comment',
              style: TextStyle(
                fontFamily: 'IBM Plex Sans',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: commentController,
              enabled: !isSaving,
              maxLines: 4,
              maxLength: 500,
              textInputAction: TextInputAction.newline,
              decoration: InputDecoration(
                hintText: 'Write a comment about your experience...',

                hintStyle: const TextStyle(
                  fontFamily: 'IBM Plex Sans',
                  color: Color(0xffA29D97),
                  fontSize: 14,
                ),

                filled: true,
                fillColor: Colors.white,
                counterStyle: const TextStyle(
                  fontFamily: 'IBM Plex Sans',
                  color: secondaryTextColor,
                  fontSize: 11,
                ),

                contentPadding: const EdgeInsets.all(14),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),

                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),

                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: primaryColor, width: 1.5),
                ),
              ),
            ),

            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: isSaving ? null : _saveRating,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: primaryColor.withValues(alpha: 0.55),
                  disabledForegroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: isSaving
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.3,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Save changes',
                        style: TextStyle(
                          fontFamily: 'IBM Plex Sans',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }
}
