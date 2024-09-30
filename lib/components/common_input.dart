import 'package:flutter/material.dart';

class ColumnInput extends StatelessWidget {
  const ColumnInput({this.title, this.height, super.key});

  final String? title;
  final int? height;

  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 40,
      thickness: 1,
      indent: 0,
      endIndent: 0,
      color: Color(0xffC6C6C6),
    );
  }
}
