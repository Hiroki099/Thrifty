import 'package:dealura/features/product/models/RatingModel.dart';
import 'package:dealura/features/product/view/widgets/star_rating_widget.dart';
import 'package:dealura/features/profile/repository/profile_repository_impl.dart';
import 'package:dealura/features/profile/view/widgets/rating_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RatingsPage extends StatefulWidget {
  const RatingsPage({super.key});

  @override
  State<RatingsPage> createState() => _RatingsPageState();
}

class _RatingsPageState extends State<RatingsPage> {
  List<RatingModel> givenRatings = [];
  List<RatingModel> receivedRatings = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadRatings();
  }

  Future<void> loadRatings() async {
    try {
      final results = await Future.wait([
        ProfileRepositoryImpl().getMyGivenRatings(),
        ProfileRepositoryImpl().getMyReceivedRatings(),
      ]);

      if (!mounted) return;

      setState(() {
        givenRatings = results[0];
        receivedRatings = results[1];
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Failed to load ratings: $e');

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
    }
  }

  double get averageRating {
    if (receivedRatings.isEmpty) return 0;

    final total = receivedRatings.fold<int>(
      0,
      (sum, rating) => sum + (rating.rating ?? 0),
    );

    return total / receivedRatings.length;
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(right: 16, left: 16, top: 25),
          child: Column(
            children: [
              /// Header
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: SvgPicture.asset(
                      'assets/images/go_back.svg',
                      width: 20,
                      height: 20,
                    ),
                  ),
                  const SizedBox(width: 13),
                  const Text(
                    "ratings",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      fontFamily: "DM Serif Display",
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 26),

              /// Tabs
              Expanded(
                child: DefaultTabController(
                  length: 2,
                  child: Column(
                    children: [
                      const TabBar(
                         indicatorSize: TabBarIndicatorSize.tab,
                    indicatorColor: Color(0xffE8A87C),
                    labelColor: Color(0xffE8A87C),
                    unselectedLabelColor: Color(0xffB5B0A8),
                    labelStyle: TextStyle(
                      fontFamily: "IBM Plex Sans",
                      fontWeight: FontWeight.w600,
                        ),
                        tabs: [
                          Tab(text: "your ratings"),
                          Tab(text: "received ratings"),
                        ],
                      ),

                      const SizedBox(height: 20),

                      Expanded(
                        child: TabBarView(
                          children: [
                            /// YOUR RATINGS
                            _buildGivenRatings(),

                            /// RECEIVED RATINGS
                            _buildReceivedRatings(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReceivedRatings() {
    return Column(
      children: [
        /// Rating summary
        _buildRatingSummary(),

        const SizedBox(height: 18),

        /// Ratings list
        Expanded(
          child: receivedRatings.isEmpty
              ? _emptyRatings("No received ratings yet")
              : ListView.separated(
                  padding: EdgeInsets.zero,
                  itemCount: receivedRatings.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 22),
                  itemBuilder: (context, index) {
                    return RatingListItem(
                      rating: receivedRatings[index],
                      isReceived: true,
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildGivenRatings() {
    if (givenRatings.isEmpty) {
      return _emptyRatings("You haven't rated anyone yet");
    }

    return ListView.separated(
      padding: const EdgeInsets.only(top: 4),
      itemCount: givenRatings.length,
      separatorBuilder: (_, _) => const SizedBox(height: 22),
      itemBuilder: (context, index) {
        return RatingListItem(rating: givenRatings[index], isReceived: false);
      },
    );
  }

  Widget _buildRatingSummary() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xffE8A87C), width: 1.5),
      ),
      child: Column(
        children: [
          Text(
            averageRating.toStringAsFixed(1),
            style: const TextStyle(
              fontSize: 38,
              fontWeight: FontWeight.w500,
              fontFamily: "IBM Plex Sans",
            ),
          ),

          const SizedBox(height: 4),

          StarRating(rating: averageRating, size: 31),

          const SizedBox(height: 8),

          Text(
            "${receivedRatings.length} Reviews",
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xff8A8580),
              fontFamily: "IBM Plex Sans",
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyRatings(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.star_border_rounded,
            size: 60,
            color: Color(0xffB5B0A8),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(
              fontSize: 16,
              fontFamily: "IBM Plex Sans",
              color: Color(0xff8A8580),
            ),
          ),
        ],
      ),
    );
  }
}

String formatRatingDate(DateTime date) {
  const weekdays = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday",
  ];

  final weekday = weekdays[date.weekday - 1];

  int hour = date.hour;
  final minute = date.minute.toString().padLeft(2, '0');

  final period = hour >= 12 ? "PM" : "AM";

  hour %= 12;
  if (hour == 0) hour = 12;

  return "$weekday $hour:$minute $period";
}
