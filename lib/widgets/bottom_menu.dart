import 'package:flutter/material.dart';
import 'package:funnavi/screens/caterory_screen.dart';
import 'package:funnavi/screens/main_screen.dart';
import 'package:funnavi/screens/map_screen.dart';

import 'bottom_menu_button.dart';

class BottomMenu extends StatelessWidget {
  bool list;
  bool map;
  bool filter;
  BottomMenu({
    super.key,
    required this.list,
    required this.map,
    required this.filter,
  });

  @override
  Widget build(BuildContext context) {
    String selectedScreen = 'lista';
    return Container(
      width: double.infinity,
      height: 65,
      decoration: BoxDecoration(
        color: Color(0xFF1E3A8A),
        // borderRadius: BorderRadius.only(
        //   topLeft: Radius.circular(20),
        //   topRight: Radius.circular(20),
        // ),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BottomMenuButton(
                is_checked: list,
                ekran: MainScreen.id,
                ikona: Icons.format_list_bulleted,
              ),
              BottomMenuButton(
                is_checked: map,
                ekran: MapScreen.id,
                ikona: Icons.map,
              ),
              BottomMenuButton(
                is_checked: filter,
                ekran: CategoryScreen.id,
                ikona: Icons.filter_alt,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
