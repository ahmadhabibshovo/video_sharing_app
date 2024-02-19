import 'package:flutter/material.dart';

import '../../../../core/constant/constant.dart';

class SelectCategory extends StatefulWidget {
  const SelectCategory({super.key});

  @override
  State<SelectCategory> createState() => _SelectCategoryState();
}

class _SelectCategoryState extends State<SelectCategory> {
  String selected = 'All';
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: videoCategoriesSelect.map((category) {
          return GestureDetector(
            onTap: () {
              setState(() {
                selected = category;
              });
            },
            child: Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: selected == category
                      ? Theme.of(context).primaryColor
                      : Colors.grey),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(category),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
