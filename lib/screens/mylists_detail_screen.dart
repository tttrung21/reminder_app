import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:reminder_app/dummy_data.dart';

import '../widgets/bottom_sheet_add_list_reminder.dart';
import 'home.dart';
import '../widgets/reminder_item.dart';
import '../providers/list.dart' as LL;
import '../providers/lists.dart';
import '../providers/reminder.dart';
import '../providers/reminders.dart';

class MylistsDetailScreen extends StatefulWidget {
  static const routeName = '/mylists-detail';

  const MylistsDetailScreen({super.key});

  @override
  State<MylistsDetailScreen> createState() => _MylistsDetailScreenState();
}

class _MylistsDetailScreenState extends State<MylistsDetailScreen> {
  bool hideCompleted = false;
  String listTitle = '';
  List<Reminder> listReminder = [];
  var listId;
  var _isLoading = false;
  var completedCount = 0;
  bool isEditList = true;
  int color = 0;
  bool visible = false;
  bool cbValue = false;
  var titleTEC = TextEditingController();
  Reminder _reminder = Reminder(reminderId: '', listId: '', title: '');

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    listId = ModalRoute.of(context)!.settings.arguments as String;
    fetchReminder();
    listReminder =
        Provider.of<Reminders>(context, listen: false).itemsByListId(listId);
    listTitle =
        Provider.of<Lists>(context, listen: false).findByListId(listId).title;
    color =
        Provider.of<Lists>(context, listen: false).findByListId(listId).color;
  }

  void fetchReminder() {
    setState(() {
      _isLoading = true;
    });
    Provider.of<Reminders>(context, listen: false)
        .fetchReminders()
        .then((value) {
      setState(() {
        completedCount = Provider.of<Reminders>(context, listen: false)
            .completedReminder(listId)
            .length;
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Scaffold(body: Center(child: CupertinoActivityIndicator()))
        : Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              elevation: 0,
              leading: visible
                  ? TextButton(
                      onPressed: () {
                        setState(() {
                          visible = false;
                          titleTEC.clear();
                        });
                      },
                      child: Text('Cancel',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              color: Color(color))))
                  : TextButton.icon(
                      onPressed: () {
                        Navigator.of(context)
                            .pushReplacementNamed(MyHomePage.routeName);
                        // Navigator.of(context).pop();
                      },
                      icon: Icon(CupertinoIcons.back,
                          size: 26, color: Color(color)),
                      label: Text(
                        'Lists',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: Color(color)),
                      ),
                    ),
              leadingWidth: 100,
              backgroundColor: CupertinoColors.white,
              actions: [
                visible
                    ? TextButton(
                        onPressed: titleTEC.text.isEmpty
                            ? null
                            : () {
                                setState(() {
                                  _reminder = Reminder(
                                      reminderId: _reminder.reminderId,
                                      listId: listId,
                                      title: titleTEC.text);
                                  Provider.of<Reminders>(context, listen: false)
                                      .addReminder(_reminder);
                                  visible = false;
                                  titleTEC.clear();
                                });
                              },
                        child: Text(
                          'Done',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              color: titleTEC.text.isEmpty
                                  ? Colors.grey
                                  : Color(color)),
                        ))
                    : PopupMenuButton(
                        icon: Icon(CupertinoIcons.ellipsis_circle,
                            color: Color(color)),
                        itemBuilder: (_) => [
                              PopupMenuItem(
                                onTap: () {
                                  Future.delayed(
                                      const Duration(seconds: 0),
                                      () => showModalBottomSheet(
                                              isScrollControlled: true,
                                              context: context,
                                              builder: (_) {
                                                return AddList(0, true, listId);
                                              }).then((value) {
                                            if (value['update'] == true) {
                                              setState(() {
                                                _isLoading = true;
                                              });
                                              LL.List list = value['list'];
                                              try {
                                                Provider.of<Lists>(context,
                                                        listen: false)
                                                    .updateList(list, listId)
                                                    .then((value) {
                                                  color = Provider.of<Lists>(context,
                                                          listen: false)
                                                      .findByListId(listId).color;
                                                  listTitle = Provider.of<Lists>(context,
                                                      listen: false)
                                                      .findByListId(listId).title;
                                                  setState(() {
                                                    _isLoading = false;
                                                  });
                                                });
                                              } catch (error) {
                                                throw error;
                                              }
                                            }
                                          }));
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Show List Info',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
                                    ),
                                    const Icon(
                                      CupertinoIcons.pencil,
                                      color: Colors.black,
                                      size: 16,
                                    ),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                  child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Share List',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall),
                                  const Icon(
                                    CupertinoIcons
                                        .person_crop_circle_badge_plus,
                                    color: Colors.black,
                                    size: 16,
                                  )
                                ],
                              )),
                              PopupMenuItem(
                                  child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Select Reminders',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall),
                                  const Icon(
                                    CupertinoIcons.check_mark_circled,
                                    color: Colors.black,
                                    size: 16,
                                  )
                                ],
                              )),
                              PopupMenuItem(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Sort',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall),
                                      const Icon(
                                        CupertinoIcons.arrow_up_arrow_down,
                                        color: Colors.black,
                                        size: 16,
                                      )
                                    ],
                                  ),
                                  onTap: () {
                                    setState(() {
                                      listReminder.sort((a, b) {
                                        print(a.title);
                                        print(b.title);
                                        return a.title[0]
                                            .toLowerCase()
                                            .compareTo(
                                                b.title[0].toLowerCase());
                                      });
                                    });
                                  }),
                              PopupMenuItem(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    hideCompleted
                                        ? Text('Show completed',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall)
                                        : Text('Hide completed',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall),
                                    hideCompleted
                                        ? const Icon(
                                            CupertinoIcons.eye,
                                            color: Colors.black,
                                            size: 16,
                                          )
                                        : const Icon(
                                            CupertinoIcons.eye_slash,
                                            color: Colors.black,
                                            size: 16,
                                          )
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    hideCompleted = !hideCompleted;
                                  });
                                },
                              ),
                              PopupMenuItem(
                                  child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Print',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall),
                                  const Icon(
                                    CupertinoIcons.printer,
                                    color: Colors.black,
                                    size: 16,
                                  )
                                ],
                              )),
                              PopupMenuItem(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: const [
                                    Text('Delete list',
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.red)),
                                    Icon(
                                      CupertinoIcons.delete,
                                      color: Colors.red,
                                      size: 16,
                                    )
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    Provider.of<Lists>(context, listen: false)
                                        .deleteList(listId);
                                  });
                                  Navigator.of(context).pop();
                                },
                              ),
                            ])
              ],
            ),
            body: Column(
              children: [
                SizedBox(
                  height: 550,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 5),
                          height: 40,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(listTitle,
                                  style: TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.w500,
                                      color: Color(color))),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 3, horizontal: 20),
                          height: 40,
                          child: Row(
                            children: [
                              Text('$completedCount Completed',
                                  style: const TextStyle(
                                      fontSize: 18,
                                      color: CupertinoColors.systemGrey)),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 2, bottom: 2, left: 8, right: 5),
                                child: Container(
                                  width: 5.0,
                                  height: 5.0,
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: CupertinoColors.systemGrey2),
                                ),
                              ),
                              TextButton(
                                  onPressed: completedCount == 0 ? null : () {},
                                  child: Text('Clear',
                                      style: TextStyle(
                                          fontSize: 18, color: Color(color))))
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            Consumer<Reminders>(
                              builder: (ctx, reminderData, _) => Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: reminderData
                                            .itemsByListId(listId)
                                            .isEmpty
                                        ? 0
                                        : reminderData
                                            .itemsByListId(listId)
                                            .length,
                                    itemBuilder: (ctx, index) => Column(
                                      children: [
                                        ReminderItem(
                                          reminderId: reminderData
                                              .itemsByListId(listId)[index]
                                              .reminderId,
                                          listId: reminderData
                                              .itemsByListId(listId)[index]
                                              .listId,
                                          title: reminderData
                                              .itemsByListId(listId)[index]
                                              .title,
                                          flagged: reminderData
                                              .itemsByListId(listId)[index]
                                              .flagged,
                                          completed: reminderData
                                              .itemsByListId(listId)[index]
                                              .completed,
                                          priority: reminderData
                                              .itemsByListId(listId)[index]
                                              .priority,
                                          hideCompleted: hideCompleted,
                                          dueDate: reminderData
                                              .itemsByListId(listId)[index]
                                              .dueDate,
                                          dueTime: reminderData
                                      .itemsByListId(listId)[index]
                                      .dueTime,
                                          tags: reminderData
                                              .itemsByListId(listId)[index]
                                              .tags,
                                          subTasks: reminderData
                                              .itemsByListId(listId)[index]
                                              .subTasks,
                                          imageUrl: reminderData
                                              .itemsByListId(listId)[index]
                                              .imageUrl,
                                          notes: reminderData
                                              .itemsByListId(listId)[index]
                                              .notes,
                                          repeat: reminderData
                                              .itemsByListId(listId)[index]
                                              .repeat,
                                        ),
                                      ],
                                    ),
                                  )),
                            ),
                            Visibility(
                              visible: visible,
                              child: Row(
                                children: [
                                  Checkbox(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      value: cbValue,
                                      onChanged: (bool? value) {}),
                                  Expanded(
                                      child: TextField(
                                    onChanged: (_) {
                                      setState(() {});
                                    },
                                    autofocus: visible ? true : false,
                                    controller: titleTEC,
                                    style: const TextStyle(color: Colors.grey),
                                  ))
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextButton.icon(
                        onPressed: () {
                          setState(() {
                            visible = true;
                          });
                        },
                        icon: Icon(CupertinoIcons.add_circled_solid,
                            color: Color(color)),
                        label: Text(
                          'New reminder',
                          style: TextStyle(fontSize: 18, color: Color(color)),
                        )),
                  ],
                )
              ],
            ));
  }
}
