import 'package:flutter/material.dart';
import 'package:steady_routine/model/category_type.dart';

class CategoriesSelect extends StatefulWidget {
  final CategoryType? initialSelectedType;

  @override
  State<CategoriesSelect> createState() => CategoriesSelectState();

  const CategoriesSelect({super.key, this.initialSelectedType});
}

class CategoriesSelectState extends State<CategoriesSelect> {
  CategoryType? selectedType;

  @override
  void initState() {
    super.initState();
    selectedType = widget.initialSelectedType;
  }

  void _updateState(int index) {
    setState(() {
      selectedType = index.toCategoryType();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: CategoryType.values.length,
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 100.0,
        ),
        itemBuilder: (BuildContext context, int index) {
          final categoryType =
              CategoryType.values[index]; // Get the category type

          return GestureDetector(
            onTap: () {
              _updateState(index);
            },
            child: Card(
              color: selectedType == categoryType
                  ? const Color(0xfff88273) // Change color if selected
                  : Colors.white,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      categoryType.toImagePath(), // Use the category type
                    ),
                    const SizedBox(height: 10),
                    Text(
                      categoryType.name, // Use the category type
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
