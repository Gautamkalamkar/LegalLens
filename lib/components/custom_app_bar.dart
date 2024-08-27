import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar(
      {super.key, required this.title, this.height = kToolbarHeight});

  final String title;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 8, bottom: 8, left: 8, right: 20),
      child: AppBar(
        title: Text(
          title,
          style: const TextStyle(fontSize: 30),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
