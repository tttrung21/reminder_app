import 'package:flutter/material.dart';
import '../providers/reminder.dart';

class PriorityItem extends StatelessWidget {

  final Priority priority;

  const PriorityItem(this.priority, {super.key});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(priority.name,style: Theme.of(context).textTheme.headlineMedium,),
      ),
      onTap: () {
        print(priority.name);
        Navigator.of(context).pop(priority);
      },

    );
  }
}
