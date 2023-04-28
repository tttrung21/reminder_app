import 'package:flutter/material.dart';

class ListItem extends StatelessWidget {
  final String id;
  final String title;

  const ListItem({super.key, required this.id, required this.title});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          title,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      onTap: () {
        Navigator.of(context).pop({'id': id,'title':title});
      },
    );
  }
}

