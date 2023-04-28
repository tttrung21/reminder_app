import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/lists.dart';
import '../providers/reminder.dart';

import '../providers/reminders.dart';
import 'bottom_sheet_priority_subtask.dart';
import 'list_item.dart';

class DetailList extends StatefulWidget {
  final bool isDetail;
  final bool isEditReminder;
  final String listId;
  final String reminderId;

  const DetailList(this.isDetail, this.isEditReminder, this.listId,
      this.reminderId, {super.key});

  @override
  State<DetailList> createState() => _DetailListState();
}

class _DetailListState extends State<DetailList> {

  var detail;
  var editReminder;
  String listId = '';
  String reminderId = '';

  var switchDate = false;
  var switchTime = false;
  var switchVal3 = false;
  var switchVal4 = false;
  var switchFlag = false;

  Priority prioRes = Priority.None;
  int subTasksCount = 0;
  List<String> subTasks = [];
  List<String> tags = [];

  Reminder _reminder = Reminder(reminderId: '', listId: '', title: '');

  DateTime selectedDate = DateTime.now();

  // TimeOfDay? time = TimeOfDay.fromDateTime(DateTime.now());
  DateTime time = DateTime.now();
  DateTime now = DateTime.now();
  DateTime? finalTime;
  var imageUrlController = TextEditingController();
  int index = 0;

  List<String> listTags = [];
  List<String> listSubTasks =[];
  var titleController = TextEditingController();
  var notesController = TextEditingController();

  Future<void> updateReminder() async {
    if (switchDate ||
        (switchDate && switchTime)) {
      finalTime = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          time.hour,
          time.minute);
    }
    else {
      finalTime = null;
    }
    try {
      _reminder = Reminder(
          reminderId: reminderId,
          listId: listId,
          title: titleController.text,
          dueDate
          : finalTime,
          dueTime
          : switchTime ? finalTime : null,
          priority
          : prioRes,
          tags
          : tags,
          subTasks
          : subTasks,
          flagged
          : switchFlag,
          imageUrl
          : imageUrlController.text,
          notes: notesController.text,
          repeat
          : _reminder.repeat);
      await Provider.of<Reminders>(context,listen: false).updateReminder(
          _reminder);
    }
    catch (error) {
      throw error;
    }
  }

  @override
  void initState() {
    super.initState();
    detail = widget.isDetail;
    editReminder = widget.isEditReminder;
    listId = widget.listId;
    reminderId = widget.reminderId;
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (listId != '' && reminderId != '') {
      Provider.of<Reminders>(context, listen: false).fetchReminders();
      _reminder =
          Provider.of<Reminders>(context, listen: false).itemByReminderId(
              reminderId);
      titleController.text = _reminder.title;
      notesController.text = _reminder.notes ?? notesController.text;
      imageUrlController.text = _reminder.imageUrl ?? imageUrlController.text;
      if (_reminder.dueDate != null && _reminder.dueDate!.isAfter(now)) {
        switchDate = true;
        selectedDate = _reminder.dueDate!;
        if (_reminder.dueTime != null) {
          switchTime = true;
          time = _reminder.dueTime!;
        }
      }
      else{
        selectedDate = selectedDate;
        time = time;
      }

      listTags = _reminder.tags ?? listTags;
      listSubTasks = _reminder.subTasks ?? listSubTasks;
      switchFlag = _reminder.flagged;
      prioRes = _reminder.priority;
      subTasksCount = _reminder.subTasks?.length ?? subTasksCount;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery
        .of(context)
        .size
        .height;
    return Container(
        color: CupertinoColors.systemGrey5,
        height: screenH * 0.9,
        padding: EdgeInsets.only(
            left: 10,
            right: 10,
            top: 10,
            bottom: MediaQuery
                .of(context)
                .viewInsets
                .bottom + 10),
        child: SingleChildScrollView(
          child: detail
              ? Column(
            children: [
              Stack(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: editReminder
                        ? TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancel', style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w400),))
                        : TextButton.icon(
                      onPressed: () {
                        if (switchDate ||
                            (switchDate && switchTime)) {
                          finalTime = DateTime(
                              selectedDate.year,
                              selectedDate.month,
                              selectedDate.day,
                              time.hour,
                              time.minute);
                        }
                        else {
                          finalTime = null;
                        }
                        print(finalTime);
                        Navigator.of(context).pop({
                          'dueDate': finalTime,
                          'dueTime': switchTime ? finalTime : null,
                          'flagged': switchFlag,
                          'tags': tags,
                          'priority': prioRes,
                          'subTasks': subTasks,
                          'imageUrl': imageUrlController.text
                        });
                      },
                      icon: const Icon(Icons.navigate_before),
                      label: Text('New Reminder',
                          style: Theme
                              .of(context)
                              .textTheme
                              .headlineSmall),
                    ),
                  ),
                  const Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.only(top: 14.0),
                      child:
                      Text('Details', style: TextStyle(fontSize: 18)),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: editReminder
                        ? TextButton(
                        onPressed: () {
                          updateReminder();
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'Done',
                          style: TextStyle(fontSize: 18),
                        ))
                        : const TextButton(
                        onPressed: null,
                        child: Text(
                          'Add',
                          style: TextStyle(fontSize: 18),
                        )),
                  )
                ],
              ),
              editReminder
                  ? Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                ),
                margin: const EdgeInsets.only(top: 15),
                padding: const EdgeInsets.only(left: 15),
                child: Column(
                  children: [
                    TextField(
                      decoration: const InputDecoration(
                          hintText: 'Reminder Title',
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: CupertinoColors.systemGrey5
                              )
                          )
                      ),
                      controller: titleController,
                      autofocus: false,
                    ),
                    TextField(
                      autofocus: false,
                      decoration: const InputDecoration(
                          hintText: 'Notes',
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: CupertinoColors.systemGrey5
                              )
                          )
                      ),
                      controller: notesController,
                    ),
                    TextField(
                      autofocus: false,
                      decoration: const InputDecoration(
                          hintText: 'URL',
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: CupertinoColors.systemGrey5
                              )
                          )
                      ),
                      controller: imageUrlController,
                    )
                  ],
                ),
              )
                  : Container(),
              editReminder ? const SizedBox(height: 15) : const SizedBox(),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                ),
                margin: editReminder ? EdgeInsets.zero : const EdgeInsets.only(
                    top: 15),
                padding: const EdgeInsets.all(5),
                child: Column(
                  children: [
                    ListTile(
                      leading: Container(
                          height: 35,
                          width: 35,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.red),
                          child: const Icon(
                            Icons.calendar_month,
                            color: Colors.white,
                          )),
                      title: const Text('Date'),
                      subtitle: !switchDate
                          ? Container()
                          : selectedDate.day == DateTime
                          .now()
                          .day
                          ? const Text('Today')
                          : Text(DateFormat.yMMMd()
                          .format(selectedDate)),
                      trailing: CupertinoSwitch(
                          value: switchDate,
                          onChanged: (val) =>
                              setState(() {
                                switchDate = val;
                              })),
                    ),
                    !switchDate
                        ? Container()
                        : CalendarDatePicker(
                        initialDate: selectedDate,
                        firstDate: now,
                        lastDate: DateTime(now.year + 2),
                        onDateChanged: (picked) {
                          setState(() {
                            selectedDate = picked;
                          });
                        }),
                    const Divider(thickness: 1),
                    ListTile(
                      leading: Container(
                          height: 35,
                          width: 35,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.blue),
                          child: const Icon(
                            Icons.watch_later_outlined,
                            color: Colors.white,
                          )),
                      title: const Text('Time'),
                      subtitle: !switchTime
                          ? Container()
                          : time.minute < 10
                          ? Text('${time.hour}:0${time.minute}')
                          : Text('${time.hour}:${time.minute}'),
                      trailing: CupertinoSwitch(
                          value: switchTime,
                          onChanged: (val) {
                            setState(() {
                              switchTime = val;
                            });
                            // switchVal2 = val;
                            // time = (await _timePicker(context,val).then((value) {
                            //   if(value==null) {
                            //   switchVal2=false;
                            // }
                            // }))
                            //?? TimeOfDay(hour: time!.hour, minute: time!.minute);
                          }),
                    ),
                    !switchTime
                        ? Container()
                        : SizedBox(
                      height: 150,
                      child: CupertinoDatePicker(
                          mode: CupertinoDatePickerMode.time,
                          minuteInterval: 1,
                          use24hFormat: true,
                          initialDateTime: time,
                          onDateTimeChanged: (DateTime value) {
                            setState(() {
                              time = value;
                            });
                          }),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                ),
                padding: const EdgeInsets.all(5),
                child: ListTile(
                    leading: Container(
                        height: 35,
                        width: 35,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.blueGrey),
                        child: const Icon(
                          Icons.tag,
                          color: Colors.white,
                        )),
                    title: const Text('Tags'),
                    trailing: IconButton(
                        onPressed: () {
                          showModalBottomSheet(
                              isScrollControlled: true,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20))
                              ),
                              context: context,
                              builder: (_) {
                                index = 2;
                                return PriorityTaskTags(index, listTags);
                              }).then((value) {
                            setState(() {
                              tags = value;
                            });
                          });
                        },
                        icon: const Icon(Icons.navigate_next))),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                ),
                padding: const EdgeInsets.all(5),
                child: ListTile(
                  leading: Container(
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.blue),
                      child: const Icon(
                        CupertinoIcons.location_fill,
                        color: Colors.white,
                      )),
                  title: const Text('Location'),
                  trailing: CupertinoSwitch(
                      value: switchVal3,
                      onChanged: (val) =>
                          setState(() {
                            switchVal3 = val;
                          })),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                ),
                padding: const EdgeInsets.all(5),
                child: ListTile(
                  leading: Container(
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.green),
                      child: const Icon(
                        CupertinoIcons.chat_bubble_fill,
                        color: Colors.white,
                      )),
                  title: const Text('When Messaging'),
                  trailing: CupertinoSwitch(
                      value: switchVal4,
                      onChanged: (val) =>
                          setState(() {
                            switchVal4 = val;
                          })),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  height: 30,
                  child: const Text(
                      'Selecting this option will show the reminder '
                          'notification when chatting with a person in Messages',
                      style: TextStyle(
                          overflow: TextOverflow.clip,
                          fontStyle: FontStyle.italic,
                          color: CupertinoColors.systemGrey))),
              const SizedBox(
                height: 15,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                ),
                padding: const EdgeInsets.all(5),
                child: ListTile(
                  leading: Container(
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.deepOrangeAccent),
                      child: const Icon(
                        CupertinoIcons.flag_fill,
                        color: Colors.white,
                      )),
                  title: const Text('Flag'),
                  trailing: CupertinoSwitch(
                      value: switchFlag,
                      onChanged: (val) =>
                          setState(() {
                            switchFlag = val;
                          })),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                ),
                padding: const EdgeInsets.only(
                    left: 20, right: 5, top: 5, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Priority',
                        style: Theme
                            .of(context)
                            .textTheme
                            .titleMedium),
                    SizedBox(
                      width: 200,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(prioRes.name),
                          IconButton(
                              onPressed: () {
                                showModalBottomSheet(
                                    isScrollControlled: true,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(20))
                                    ),
                                    context: context,
                                    builder: (_) {
                                      index = 0;
                                      return PriorityTaskTags(index, []);
                                    }).then((value) {
                                  setState(() {
                                    prioRes = value ?? prioRes;
                                  });
                                });
                              },
                              icon: const Icon(Icons.navigate_next))
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                ),
                padding: const EdgeInsets.only(
                    left: 20, right: 5, top: 5, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Sub tasks',
                        style: Theme
                            .of(context)
                            .textTheme
                            .titleMedium),
                    SizedBox(
                      width: 200,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          subTasksCount == 0
                              ? const Text('0')
                              : Text('$subTasksCount'),
                          IconButton(
                              onPressed: () {
                                showModalBottomSheet(
                                    isScrollControlled: true,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(20))
                                    ),
                                    context: context,
                                    builder: (_) {
                                      index = 1;
                                      return PriorityTaskTags(
                                          index, listSubTasks);
                                    }).then((value) {
                                  setState(() {
                                    subTasksCount = value.length;
                                    subTasks = value;
                                  });
                                });
                              },
                              icon: const Icon(Icons.navigate_next))
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                ),
                padding: const EdgeInsets.all(5),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TextButton(
                            onPressed: () {
                              if (imageUrlController.text.isEmpty) {
                                print('Empty url');
                              } else if (!imageUrlController.text
                                  .startsWith('https:') &&
                                  !imageUrlController.text.endsWith('.jpg') &&
                                  !imageUrlController.text
                                      .endsWith('.jpeg') &&
                                  !imageUrlController.text.endsWith('.png')) {
                                print('Wrong format');
                              } else {
                                print('successful');
                              }
                            },

                            child: Text(
                              'Add image',
                              style:
                              Theme
                                  .of(context)
                                  .textTheme
                                  .headlineSmall,
                            )),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    editReminder ? Container() : TextField(
                      textAlign: TextAlign.left,
                      autofocus: false,
                      controller: imageUrlController,
                      decoration: const InputDecoration(
                        hintText: 'URL',
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Colors.white,
                        hintStyle: TextStyle(fontSize: 16),
                      ),
                    )
                  ],
                ),
              )
            ],
          )
              : Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Cancel',
                          style:
                          Theme
                              .of(context)
                              .textTheme
                              .headlineSmall)),
                  const Text('Lists', style: TextStyle(fontSize: 18)),
                  const Text('                 ',
                      style: TextStyle(
                        fontSize: 18,
                      ))
                ],
              ),
              Container(
                height: 550,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: CupertinoColors.systemGrey6,
                ),
                child: FutureBuilder(
                    builder: (context, snapshot) =>
                    snapshot.connectionState ==
                        ConnectionState.waiting
                        ? const Center(
                        child: CupertinoActivityIndicator())
                        : Consumer<Lists>(
                      builder: (ctx, listData, _) =>
                          Padding(
                            padding: const EdgeInsets.all(5),
                            child: ListView.separated(
                                itemCount: listData.items.length,
                                separatorBuilder: (ctx, index) {
                                  return const Divider(
                                    indent: 10,
                                    color: Colors.black45,
                                  );
                                },
                                itemBuilder: (context, index) =>
                                    ListItem(
                                        id: listData
                                            .items[index].listId,
                                        title: listData
                                            .items[index].title)),
                          ),
                    )),
              )
            ],
          ),
        ));
  }
}
