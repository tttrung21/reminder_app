import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reminder_app/providers/reminder.dart';

import '../providers/reminders.dart';

class GroupReminderItem extends StatefulWidget {
  Reminder reminder;

  GroupReminderItem(this.reminder, {super.key});

  @override
  State<GroupReminderItem> createState() => _GroupReminderItemState();
}

class _GroupReminderItemState extends State<GroupReminderItem> {
  bool show = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Checkbox(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              value: widget.reminder.completed,
              onChanged: (value) {
                setState(() {
                  value == null
                      ? widget.reminder.completed = false
                      : widget.reminder.completed = value;
                  Provider.of<Reminders>(context, listen: false)
                      .toggleCompleted(
                          widget.reminder.listId,
                          widget.reminder.reminderId,
                          widget.reminder.completed);
                });
              },
            ),
            Expanded(
              child: ListTile(
                title: Text(widget.reminder.title,
                    style: widget.reminder.completed
                        ? const TextStyle(color: Colors.grey)
                        : const TextStyle()),
                subtitle: widget.reminder.dueDate == null
                    ? const Text('Reminders')
                    : widget.reminder.dueDate!.minute < 10
                        ? Text(
                            'Reminders - ${widget.reminder.dueDate?.hour}:0${widget.reminder.dueDate?.minute}',
                            style: widget.reminder.completed
                                ? const TextStyle(color: Colors.grey)
                                : const TextStyle())
                        : Text(
                            'Reminders - ${widget.reminder.dueDate?.hour}:${widget.reminder.dueDate?.minute}',
                            style: widget.reminder.completed
                                ? const TextStyle(color: Colors.grey)
                                : const TextStyle()),
                trailing: widget.reminder.flagged
                    ? const Icon(CupertinoIcons.flag_fill,
                        color: CupertinoColors.activeOrange)
                    : const Icon(null),
              ),
            )
          ],
        ),
        // CheckboxListTile(
        //   value: show,
        //   onChanged: (value) {
        //     setState(() {
        //       value == null ? show = false : show = value;
        //     });
        //   },
        //   checkboxShape:
        //       RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        //   controlAffinity: ListTileControlAffinity.leading,
        //   title: Text(widget.reminder.title),
        //   subtitle: widget.reminder.dueDate == null
        //       ? const Text('Reminders')
        //       : widget.reminder.dueDate!.minute < 10
        //           ? Text(
        //               'Reminders - ${widget.reminder.dueDate?.hour}:0${widget.reminder.dueDate?.minute}')
        //           : Text(
        //               'Reminders - ${widget.reminder.dueDate?.hour}:${widget.reminder.dueDate?.minute}'),
        //   secondary: widget.reminder.flagged
        //       ? const Icon(CupertinoIcons.flag_fill,
        //           color: CupertinoColors.activeOrange)
        //       : const Icon(null),
        // ),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }
}
