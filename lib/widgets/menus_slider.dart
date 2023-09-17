import 'package:flutter/material.dart';

class MenuCard extends StatelessWidget {
  final String menus;
  const MenuCard({super.key, required this.menus});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6),
      height: 100,
      width: 100,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Center(
          child: Text(
        menus,
        textAlign: TextAlign.center,
      )),
    );
  }
}
