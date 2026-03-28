import 'package:flutter/material.dart';
import 'package:read_quest/screens/widgets/logo_menu.dart';

class MenuHeader extends StatelessWidget {
  const MenuHeader({
    super.key,
    required this.headerText,
    required this.subHeaderText,
    this.headerStyle = const TextStyle(
      color: Colors.black,
      fontSize: 24,
      fontFamily: 'IBM Plex Sans',
      fontWeight: FontWeight.w700,
    ),
    this.subHeaderStyle = const TextStyle(
      color: Color(0xFF797979),
      fontSize: 14,
      fontFamily: 'IBM Plex Sans',
      fontWeight: FontWeight.w400,
    ),
    this.trailingWidget = const SizedBox(),
  });

  final String headerText;
  final String subHeaderText;
  final TextStyle headerStyle;
  final TextStyle subHeaderStyle;
  final Widget trailingWidget;

  @override
  Widget build(BuildContext context) {
    return Row(
        children: [
          ReadQuestLogoMenu(),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(headerText, style: headerStyle),
                SizedBox(height: 4),
                Text(subHeaderText, style: subHeaderStyle),
              ],
            ),
          ),
          trailingWidget,
        ],
      );
  }
}
