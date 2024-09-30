import 'package:flutter/material.dart';

class ColumnDivider extends StatelessWidget {
  const ColumnDivider({super.key});
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
