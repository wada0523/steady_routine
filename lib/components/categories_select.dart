import 'package:flutter/material.dart';
import 'package:steady_routine/model/category_type.dart';

class CategoriesSelect extends StatefulWidget {
  @override
  State<CategoriesSelect> createState() => CategoriesSelectState();

  const CategoriesSelect({super.key});
}

class CategoriesSelectState extends State<CategoriesSelect> {
  CategoryType? selectedType;

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
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedType = index.toCategoryType();
                });
              },
              child: Card(
                  color: selectedType == index.toCategoryType()
                      ? const Color(0xfff88273)
                      : Colors.white,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          CategoryType.values[index].toImagePath(),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          CategoryType.values[index].name,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  )),
            );
          }),
    );
  }
}
