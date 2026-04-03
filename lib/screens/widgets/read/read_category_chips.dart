import 'package:flutter/material.dart';
import 'package:read_quest/screens/view/home_tabs/read_tab.dart';
import 'package:read_quest/styles/app_colors.dart';

class ReadCategoryChips extends StatelessWidget {
  final ReadCategory value;
  final ValueChanged<ReadCategory> onChanged;

  const ReadCategoryChips({
    super.key,
    required this.value,
    required this.onChanged,
  });

  Widget buildChip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
    required double width,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: 34,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.accent : const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : const Color(0xFF727A8A),
            fontSize: 16,
            fontFamily: 'IBM Plex Sans',
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          buildChip(
            label: 'All',
            selected: value == ReadCategory.all,
            onTap: () => onChanged(ReadCategory.all),
            width: 63,
          ),
          const SizedBox(width: 16),
          buildChip(
            label: 'Stories',
            selected: value == ReadCategory.stories,
            onTap: () => onChanged(ReadCategory.stories),
            width: 93,
          ),
          const SizedBox(width: 16),
          buildChip(
            label: 'Articles',
            selected: value == ReadCategory.articles,
            onTap: () => onChanged(ReadCategory.articles),
            width: 101,
          ),
          const SizedBox(width: 16),
          buildChip(
            label: 'Passages',
            selected: value == ReadCategory.passages,
            onTap: () => onChanged(ReadCategory.passages),
            width: 109,
          ),
        ],
      ),
    );
  }
}