import 'package:dealura/features/navigation/view/widgets/custom_navigation_bar.dart';
import 'package:dealura/features/profile/view/pages/profile_page.dart';
import 'package:dealura/features/search/view/pages/search_page.dart';
import 'package:flutter/material.dart';
import 'package:dealura/features/home/view/pages/home_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 0;

  final List<Widget> pages = [
    const HomePage(),
    const SearchPage(), // Search
    const Placeholder(), // Chat
    const ProfilePage(), // Profile
  ];

  void onTabChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: currentIndex,
        onTap: onTabChanged,
      ),
    );
  }
}
