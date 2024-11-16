import 'package:flutter/material.dart';
import 'package:your_chef/core/widgets/tiles/custom_list_tile.dart';

class ActionTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final void Function() onTap;
  const ActionTile({
    super.key,
    required this.title,
    required this.onTap,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return CustomListTile(
      onTap: onTap,
      leading: Icon(icon),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
      ),
    );
  }
}
