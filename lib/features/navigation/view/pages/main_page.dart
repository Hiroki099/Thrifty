import 'package:dealura/features/chat/view/pages/chats_page.dart';
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

  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();
    pages = [
      HomePage(onSearchTap: () => onTabChanged(1)),
      const SearchPage(), // Search
      ChatsPage(), // Chat
      const ProfilePage(), // Profile
    ];
  }

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
