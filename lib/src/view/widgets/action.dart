import 'package:flutter/material.dart';

class AppBarAction extends StatelessWidget {
  const AppBarAction(
      {super.key,
      this.visible = true,
      required this.icon,
      required this.onPressed,
      this.disable = false});

  final bool visible;
  final IconData icon;
  final VoidCallback onPressed;
  final bool disable;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visible,
      child: IconButton(
        icon: Icon(icon),
        onPressed: disable ? null : onPressed,
      ),
    );
  }
}
