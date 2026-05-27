import 'package:dealura/features/home/view/widgets/filter_item.dart';
import 'package:flutter/material.dart';

class CustiomFilterList extends StatelessWidget {
  const CustiomFilterList({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      width: 343,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 10,
        itemBuilder: (context, index) {
          return FilterItem();
        },
      ),
    );
  }
}
