import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reminder_app/screens/group_detail_screen.dart';

import '../providers/reminder.dart';

class GroupItem extends StatefulWidget {
  final String title;
  final IconData icon;
  final Color color;
  final bool edit;
  final List<Reminder> listReminder;

  const GroupItem(
      this.title, this.icon, this.color, this.edit, this.listReminder,
      {super.key});

  @override
  State<GroupItem> createState() => _GroupItemState();
}

class _GroupItemState extends State<GroupItem> {
  bool show = true;
  int reminderCount = 0;
  var now = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    count();
  }

  int count() {
    for (var element in widget.listReminder) {
      if (widget.title == 'Today') {
        if (element.dueDate != null &&
            element.dueDate?.day == DateTime.now().day &&
            element.dueDate?.month == DateTime.now().month &&
            element.dueDate?.year == DateTime.now().year) {
          reminderCount++;
        }
      } else if (widget.title == 'Scheduled') {
        if (element.dueDate != null && element.dueDate!.isAfter(now)) {
          reminderCount++;
        }
      } else if (widget.title == 'Flagged') {
        if (element.flagged) {
          reminderCount++;
        }
      }  else if (widget.title == 'All') {
        reminderCount++;
      }
    }
    return reminderCount;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: CupertinoColors.white),
      padding: const EdgeInsets.all(10),
      child: widget.edit
          ? CheckboxListTile(
              value: show,
              onChanged: (val) {
                setState(() {
                  val == null ? show = false : show = val;
                });
              },
              checkboxShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              controlAffinity: ListTileControlAffinity.leading,
              title: Row(
                children: [
                  CircleAvatar(
                    radius: 17,
                    backgroundColor: widget.color,
                    child: Icon(
                      widget.icon,
                      color: CupertinoColors.white,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(widget.title)
                ],
              ),
              secondary: const Icon(CupertinoIcons.line_horizontal_3),
            )
          : InkWell(
              onTap: () {
                Navigator.of(context)
                    .pushNamed(GroupDetailScreen.routeName, arguments: {
                  'title': widget.title,
                  'color': widget.color,
                  'listReminder': widget.listReminder
                });
              },
              borderRadius: BorderRadius.circular(15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                          radius: 17,
                          backgroundColor: widget.color,
                          foregroundColor: Colors.white,
                          child: Icon(widget.icon)),
                      Text(widget.title,
                          style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                  Text('$reminderCount',
                      style: const TextStyle(
                          fontSize: 30, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
    );
  }
}
