import 'package:flutter/material.dart';
import 'package:ict_portal/components/marqueewidget.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  CustomAppBar({required this.title});

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: MarqueeWidget(text: title),
      backgroundColor: Color(0xFF00A6BE),
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.menu),
        onPressed: () {
          // Use a Builder to get the correct context for the Scaffold
          Scaffold.of(context).openDrawer();
        },
      ),
    );
  }
}
