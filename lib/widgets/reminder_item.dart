import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reminder_app/widgets/bottom_sheet_detail_list.dart';
import '../providers/reminder.dart';
import '../providers/reminders.dart';

class ReminderItem extends StatefulWidget {
  String reminderId;
  String listId;
  String title;
  DateTime? dueDate;
  DateTime? dueTime;
  bool flagged;
  bool completed;
  List<String>? tags;
  Priority priority;
  List<String>? subTasks;
  String? imageUrl;
  String? notes;
  int? repeat;
  bool hideCompleted;

  ReminderItem(
      {super.key,
      required this.reminderId,
      required this.listId,
      required this.title,
      this.dueDate,
      this.dueTime,
      required this.flagged,
      required this.completed,
      required this.hideCompleted,
      this.tags,
      required this.priority,
      this.subTasks,
      this.imageUrl,
      this.notes,
      this.repeat});

  @override
  State<ReminderItem> createState() => _ReminderItemState();
}

class _ReminderItemState extends State<ReminderItem> {
  var titleController = TextEditingController();
  var focusTitle = FocusNode();
  bool isVisible = false;

  @override
  void initState() {
    super.initState();
    titleController.text = widget.title;
  }

  @override
  void dispose() {
    super.dispose();
    focusTitle.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.hideCompleted && widget.hideCompleted == widget.completed
        ? Container()
        : Column(
            children: [
              Row(
                children: [
                  Checkbox(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      value: widget.completed,
                      onChanged: (val) {
                        setState(() {
                          val == null
                              ? widget.completed = false
                              : widget.completed = val;
                          // print(widget.completed);
                          Provider.of<Reminders>(context, listen: false)
                              .toggleCompleted(widget.listId, widget.reminderId,
                                  widget.completed);
                        });
                      }),
                  Expanded(
                      child: TextField(
                    autofocus: false,
                    focusNode: focusTitle,
                    controller: titleController,
                    style: widget.completed
                        ? const TextStyle(color: Colors.grey)
                        : const TextStyle(),
                    decoration: InputDecoration(
                        suffixIcon: isVisible
                            ? Visibility(
                                visible: isVisible,
                                child: SizedBox(
                                  height: 35,
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: [
                                      Container(
                                        color: CupertinoColors.systemGrey2,
                                        child: TextButton(
                                          onPressed: () {
                                            setState(() {
                                              showModalBottomSheet(
                                                  isScrollControlled: true,
                                                  context: context,
                                                  builder: (_) {
                                                    isVisible = false;
                                                    return DetailList(
                                                        true,
                                                        true,
                                                        widget.listId,
                                                        widget.reminderId);
                                                  });
                                            });
                                          },
                                          child: const Text(
                                            'Details',
                                            style: TextStyle(
                                                color: CupertinoColors.white),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        color: CupertinoColors.systemOrange,
                                        child: TextButton(
                                          onPressed: () {
                                            setState(() {
                                              Provider.of<Reminders>(context,
                                                      listen: false)
                                                  .updateReminder(Reminder(
                                                      reminderId:
                                                          widget.reminderId,
                                                      listId: widget.listId,
                                                      title: widget.title,
                                                      dueDate: widget.dueDate,
                                                      dueTime: widget.dueTime,
                                                      flagged: !widget.flagged,
                                                      completed:
                                                          widget.completed,
                                                      tags: widget.tags,
                                                      subTasks: widget.subTasks,
                                                      priority: widget.priority,
                                                      imageUrl: widget.imageUrl,
                                                      notes: widget.notes,
                                                      repeat: widget.repeat));
                                              isVisible = false;
                                            });
                                          },
                                          child: const Text('Flag',
                                              style: TextStyle(
                                                  color:
                                                      CupertinoColors.white)),
                                        ),
                                      ),
                                      Container(
                                        color: CupertinoColors.destructiveRed,
                                        child: TextButton(
                                          onPressed: () {
                                            setState(() {
                                              Provider.of<Reminders>(context,
                                                      listen: false)
                                                  .deleteReminder(
                                                      widget.reminderId,
                                                      widget.listId);
                                              isVisible = false;
                                            });
                                          },
                                          child: const Text('Delete',
                                              style: TextStyle(
                                                  color:
                                                      CupertinoColors.white)),
                                        ),
                                      )
                                    ],
                                  ),
                                ))
                            : IconButton(
                                onPressed: () {
                                  setState(() {
                                    isVisible = !isVisible;
                                  });
                                },
                                icon: const Icon(CupertinoIcons.info_circle))),
                  ))
                ],
              ),
              const SizedBox(
                height: 10,
              )
            ],
          );
  }
}
