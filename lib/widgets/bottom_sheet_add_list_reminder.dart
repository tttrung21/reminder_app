import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../dummy_data.dart';
import '../providers/reminders.dart';
import 'bottom_sheet_detail_list.dart';
import '../providers/lists.dart';
import '../providers/list.dart' as LL;
import '../providers/reminder.dart';

class AddList extends StatefulWidget {
  final int index;
  final bool isEditList;
  final String listId;

  const AddList(this.index, this.isEditList, this.listId, {super.key});

  @override
  State<AddList> createState() => _AddListState();
}

class _AddListState extends State<AddList> {
  final nameListController = TextEditingController();
  final titleReminderController = TextEditingController();
  final noteReminderController = TextEditingController();
  Color? selectedColor;
  int _colorIndex = 0;
  int _iconIndex = 0;
  int sheetIndex = 0;

  var editList;
  bool detail = true;
  var listId;
  String? listRes = '';

  LL.List _list = LL.List(listId: '', title: '', icon: 0, color: 0);
  Reminder _reminder = Reminder(reminderId: '', listId: '', title: '');

  Future<void> submitReminder() async {
    try {
      await Provider.of<Reminders>(context, listen: false)
          .addReminder(_reminder);
    } catch (error) {
      throw error;
    }
  }

  Future<void> submitList() async {
    try {
      await Provider.of<Lists>(context, listen: false).addList(_list);
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateList() async {
    try {
      await Provider.of<Lists>(context, listen: false)
          .updateList(_list, listId);
    } catch (error) {
      throw error;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sheetIndex = widget.index;
    editList = widget.isEditList;
    listId = widget.listId;
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (listId != '') {
      _list = Provider.of<Lists>(context, listen: false).findByListId(listId);
      nameListController.text = _list.title;
      for (int i = 0; i < listColor.length; i++) {
        if (listColor[i].value == _list.color) {
          _colorIndex = i;
        }
      }
      for (int i = 0; i < listIcon.length; i++) {
        if (listIcon[i].codePoint == _list.icon) {
          _iconIndex = i;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;
    final screenH = MediaQuery.of(context).size.height;

    return Container(
      color: CupertinoColors.systemGrey5,
      height: screenH * 0.9,
      padding: EdgeInsets.only(
          left: 10,
          right: 10,
          top: 10,
          bottom: MediaQuery.of(context).viewInsets.bottom + 10),
      child: sheetIndex == 0
          ? SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      editList
                          ? TextButton(
                              onPressed: () {
                                _list =
                                    Provider.of<Lists>(context, listen: false)
                                        .findByListId(listId);
                                Navigator.of(context)
                                    .pop({'list': _list, 'update': false});
                              },
                              child: Text(
                                'Cancel',
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ))
                          : TextButton(
                              onPressed: () {
                                Navigator.of(context).pop({'update': false});
                              },
                              child: Text(
                                'Cancel',
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              )),
                      editList
                          ? const Text('Edit List',
                              style: TextStyle(fontSize: 18))
                          : const Text('New List',
                              style: TextStyle(fontSize: 18)),
                      editList
                          ? TextButton(
                              onPressed: () {
                                _list = LL.List(
                                    listId: _list.listId,
                                    title: nameListController.text,
                                    icon: listIcon[_iconIndex].codePoint,
                                    color: listColor[_colorIndex].value);
                                // updateList();
                                Navigator.of(context)
                                    .pop({'list': _list, 'update': true});
                              },
                              child: const Text(
                                'Done',
                                style: TextStyle(fontSize: 18),
                              ))
                          : TextButton(
                              onPressed: nameListController.text.isEmpty
                                  ? null
                                  : () {
                                      _list = LL.List(
                                          listId: _list.listId,
                                          title: nameListController.text,
                                          icon: listIcon[_iconIndex].codePoint,
                                          color: listColor[_colorIndex].value);
                                      print(listIcon[_iconIndex].codePoint);
                                      print(listColor[_colorIndex].value);
                                      submitList();
                                      Navigator.of(context).pop();
                                    },
                              child: const Text(
                                'Done',
                                style: TextStyle(fontSize: 18),
                              ))
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 30),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: CupertinoColors.systemGrey6,
                    ),
                    child: Column(
                      children: [
                        CircleAvatar(
                          backgroundColor: listColor[_colorIndex],
                          radius: screenW * 0.1,
                          child: Icon(
                            listIcon[_iconIndex],
                            size: 50,
                            color: CupertinoColors.white,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextField(
                            textAlign: TextAlign.center,
                            decoration: const InputDecoration(
                              hintText: 'List Name',
                              border: InputBorder.none,
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            onSubmitted: (value) {
                              _list = LL.List(
                                  listId: _list.listId,
                                  title: value,
                                  icon: listIcon[_iconIndex].codePoint,
                                  color: listColor[_colorIndex].value);
                            },
                            autofocus: false,
                            controller: nameListController,
                            onChanged: (value) {
                              setState(() {});
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: CupertinoColors.systemGrey6),
                    child: CupertinoListTile(
                        leading: Stack(children: [
                          Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: CupertinoColors.systemBlue,
                            ),
                          ),
                          const Center(
                            child: Icon(
                                CupertinoIcons
                                    .line_horizontal_3_decrease_circle,
                                color: CupertinoColors.white),
                          ),
                        ]),
                        title: const Text('Make into Smart List'),
                        subtitle:
                            const Text('Organize using tags and other filters'),
                        trailing: const CupertinoListTileChevron()),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 9),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: CupertinoColors.systemGrey6,
                      ),
                      child: Center(
                        child: Wrap(
                          spacing: 9,
                          children: [
                            for (int i = 0; i < listColor.length; i++)
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    _colorIndex = i;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          strokeAlign: 5,
                                          color: _colorIndex == i
                                              ? CupertinoColors.systemGrey3
                                              : CupertinoColors.systemGrey6)),
                                  child: CircleAvatar(
                                    radius: screenW * 0.056,
                                    backgroundColor: listColor[i],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      )),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: CupertinoColors.systemGrey6,
                    ),
                    child: Wrap(
                      spacing: 6,
                      children: [
                        for (int i = 0; i < listIcon.length; i++)
                          InkWell(
                            onTap: () {
                              setState(() {
                                _iconIndex = i;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      strokeAlign: 5,
                                      color: _iconIndex == i
                                          ? CupertinoColors.systemGrey3
                                          : CupertinoColors.systemGrey6)),
                              child: CircleAvatar(
                                radius: screenW * 0.062,
                                backgroundColor: CupertinoColors.systemGrey5,
                                child: Icon(
                                  listIcon[i],
                                  color: _iconIndex == i
                                      ? CupertinoColors.systemBlue
                                      : CupertinoColors.systemGrey3,
                                ),
                              ),
                            ),
                          )
                      ],
                    ),
                    // Wrap(
                    //     children: List<Widget>.generate(12, (index) {
                    //   return Padding(
                    //     padding: EdgeInsets.all(6),
                    //     child: InkWell(
                    //       onTap: () {
                    //         setState(() {
                    //           _iconIndex = index;
                    //           print(getIcon(_iconIndex).codePoint);
                    //         });
                    //       },
                    //       child: CircleAvatar(
                    //         radius: screenW * 0.062,
                    //         backgroundColor: CupertinoColors.systemGrey5,
                    //         child: Icon(
                    //           index == 0
                    //               ? CupertinoIcons.smiley
                    //               : index == 1
                    //                   ? CupertinoIcons.list_bullet
                    //                   : index == 2
                    //                       ? CupertinoIcons.bookmark_fill
                    //                       : index == 3
                    //                           ? CupertinoIcons.map_pin
                    //                           : index == 4
                    //                               ? CupertinoIcons.gift_fill
                    //                               : index == 5
                    //                                   ? CupertinoIcons.alarm
                    //                                   : index == 6
                    //                                       ? CupertinoIcons
                    //                                           .hammer
                    //                                       : index == 7
                    //                                           ? CupertinoIcons
                    //                                               .briefcase
                    //                                           : index == 8
                    //                                               ? CupertinoIcons
                    //                                                   .pencil
                    //                                               : index == 9
                    //                                                   ? CupertinoIcons
                    //                                                       .doc_fill
                    //                                                   : index ==
                    //                                                           10
                    //                                                       ? CupertinoIcons
                    //                                                           .book_solid
                    //                                                       : CupertinoIcons
                    //                                                           .folder_solid,
                    //           color: _iconIndex == index
                    //               ? CupertinoColors.systemBlue
                    //               : CupertinoColors.systemGrey3,
                    //         ),
                    //       ),
                    //       //           child: Column(
                    //       //             mainAxisAlignment: MainAxisAlignment.center,
                    //       //             crossAxisAlignment: CrossAxisAlignment.center,
                    //       //             children: <Widget>[
                    //       //               ElevatedButton(
                    //       //                 onPressed: _pickIcon,
                    //       //                 child: const Text('Open IconPicker'),
                    //       //               ),
                    //       //               const SizedBox(height: 10),
                    //       //               AnimatedSwitcher(
                    //       //                 duration: const Duration(milliseconds: 300),
                    //       //                 child: _icon ?? Container(),
                    //       //               ),
                    //       //             ],
                    //       //           ),
                    //     ),
                    //   );
                    // })),
                  )
                ],
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'Cancel',
                            style: Theme.of(context).textTheme.headlineSmall,
                          )),
                      const Text('New Reminder',
                          style: TextStyle(fontSize: 18)),
                      TextButton(
                          onPressed: titleReminderController.text.isEmpty
                              ? null
                              : () {
                                  _reminder = Reminder(
                                      reminderId: _reminder.reminderId,
                                      listId: _reminder.listId,
                                      title: titleReminderController.text,
                                      dueDate: _reminder.dueDate,
                                      dueTime: _reminder.dueTime,
                                      flagged: _reminder.flagged,
                                      completed: _reminder.completed,
                                      tags: _reminder.tags,
                                      priority: _reminder.priority,
                                      subTasks: _reminder.subTasks,
                                      imageUrl: _reminder.imageUrl,
                                      notes: noteReminderController.text,
                                      repeat: _reminder.repeat);
                                  submitReminder();
                                  Navigator.of(context).pop();
                                  print(_reminder.priority);
                                  print(_reminder.dueDate);
                                  print(_reminder.tags);
                                  print(_reminder.subTasks);
                                },
                          child: const Text(
                            'Add',
                            style: TextStyle(fontSize: 18),
                          ))
                    ],
                  ),
                  Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15)),
                      child: Column(
                        children: [
                          TextField(
                            textAlign: TextAlign.left,
                            controller: titleReminderController,
                            decoration: const InputDecoration(
                                hintText: 'Title',
                                filled: true,
                                fillColor: Colors.white,
                                hintStyle: TextStyle(fontSize: 16)),
                            onChanged: (txt) {
                              setState(() {});
                            },
                            onSubmitted: (value) {
                              _reminder = Reminder(
                                  reminderId: _reminder.reminderId,
                                  listId: _reminder.listId,
                                  title: value,
                                  // dueDate: _reminder.dueDate,
                                  // dueTime: _reminder.dueTime,
                                  flagged: _reminder.flagged,
                                  completed: _reminder.completed,
                                  tags: _reminder.tags,
                                  priority: _reminder.priority,
                                  subTasks: _reminder.subTasks,
                                  imageUrl: _reminder.imageUrl,
                                  notes: _reminder.notes,
                                  repeat: _reminder.repeat);
                            },
                          ),
                          TextField(
                              textAlign: TextAlign.left,
                              autofocus: false,
                              controller: noteReminderController,
                              decoration: const InputDecoration(
                                hintText: 'Notes',
                                border: InputBorder.none,
                                filled: true,
                                fillColor: Colors.white,
                                hintStyle: TextStyle(fontSize: 16),
                              )),
                        ],
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Details'),
                          IconButton(
                              onPressed: () {
                                showModalBottomSheet(
                                    isScrollControlled: true,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(10))),
                                    context: context,
                                    builder: (_) {
                                      detail = true;
                                      return DetailList(detail, false, '', '');
                                    }).then((value) {
                                  _reminder.dueDate = value['dueDate'];
                                  _reminder.dueTime = value['dueTime'];
                                  _reminder.flagged = value['flagged'];
                                  _reminder.priority = value['priority'];
                                  _reminder.tags = value['tags'];
                                  _reminder.subTasks = value['subTasks'];
                                  _reminder.imageUrl = value['imageUrl'];
                                });
                              },
                              icon: const Icon(Icons.navigate_next))
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                      padding: const EdgeInsets.only(left: 5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('List'),
                            SizedBox(
                              width: 200,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Flexible(
                                      child: Text(
                                    listRes == null ? '' : listRes!,
                                    overflow: TextOverflow.ellipsis,
                                  )),
                                  IconButton(
                                      onPressed: () {
                                        showModalBottomSheet(
                                            isScrollControlled: true,
                                            shape: const RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.vertical(
                                                        top: Radius.circular(
                                                            10))),
                                            context: context,
                                            builder: (_) {
                                              detail = false;
                                              return DetailList(
                                                  detail, false, '', '');
                                            }).then((value) {
                                          setState(() {
                                            print(value);
                                            // listRes = value == null
                                            //     ? ''
                                            //     : value['title'];
                                            value == null
                                                ? ''
                                                : {
                                                    listRes = value['title'],
                                                    _reminder.listId =
                                                        value['id']
                                                  };
                                          });
                                        });
                                      },
                                      icon: const Icon(Icons.navigate_next)),
                                ],
                              ),
                            )
                          ],
                        ),
                      ))
                ],
              ),
            ),
    );
  }

  Color getColor(int n) {
    switch (n) {
      case 0:
        return const Color(0xffD34329);
      case 1:
        return const Color(0xFFD38a29);
      case 2:
        return const Color(0xFFEacc61);
      case 3:
        return const Color(0xff4bc95e);
      case 4:
        return const Color(0xFF88a3f4);
      case 5:
        return const Color(0xff2e55cb);
      case 6:
        return const Color(0xff482da8);
      case 7:
        return const Color(0xFFA83066);
      case 8:
        return const Color(0xffB058ae);
      case 9:
        return const Color(0xff7b6b59);
      case 10:
        return const Color(0xFF4b4a4a);
      case 11:
        return const Color(0xffB09d9d);
      default:
        return const Color(0xffD34329);
    }
  }

  IconData getIcon(int index) {
    switch (index) {
      case 0:
        return CupertinoIcons.smiley;
      case 1:
        return CupertinoIcons.list_bullet;
      case 2:
        return CupertinoIcons.bookmark_fill;
      case 3:
        return CupertinoIcons.map_pin;
      case 4:
        return CupertinoIcons.gift_fill;
      case 5:
        return CupertinoIcons.alarm;
      case 6:
        return CupertinoIcons.hammer;
      case 7:
        return CupertinoIcons.briefcase;
      case 8:
        return CupertinoIcons.pencil;
      case 9:
        return CupertinoIcons.doc_fill;
      case 10:
        return CupertinoIcons.book_solid;
      case 11:
        return CupertinoIcons.folder_solid;
      default:
        return CupertinoIcons.smiley;
    }
  }
}
