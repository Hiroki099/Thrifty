import 'package:dealura/features/home/view/widgets/home_page_body.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final VoidCallback onSearchTap;
  const HomePage({super.key, required this.onSearchTap});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: HomePageBody(onSearchTap: onSearchTap));
  }
}
