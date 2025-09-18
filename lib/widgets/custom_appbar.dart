import 'package:flutter/material.dart';
import 'package:location_based_show_items/constant/app_color.dart';

class CustomAppbar extends StatefulWidget implements PreferredSizeWidget{
  final String pageTitle;
  const CustomAppbar({super.key,required this.pageTitle});

  @override
  State<CustomAppbar> createState() => _CustomAppbarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _CustomAppbarState extends State<CustomAppbar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      title: Text(widget.pageTitle),
      backgroundColor: AppColor.primaryColor,
      centerTitle: true,
    );
  }
}
