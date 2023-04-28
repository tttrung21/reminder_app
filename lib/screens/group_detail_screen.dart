import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reminder_app/providers/lists.dart';
import 'package:reminder_app/widgets/group_reminder_item.dart';
import '../providers/reminder.dart';
import 'package:reminder_app/providers/list.dart' as LL;

import '../providers/reminders.dart';

class GroupDetailScreen extends StatefulWidget {
  static const routeName = '/group-detail';

  @override
  State<GroupDetailScreen> createState() => _GroupDetailScreenState();
}

class _GroupDetailScreenState extends State<GroupDetailScreen> {
  late String title;
  late Color color;
  var arguments;
  var now = DateTime.now();
  // bool _isLoading = false;
  List<LL.List> list = [];
  List<Reminder> listReminder = [];



  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    arguments = ModalRoute.of(context)?.settings.arguments;
    title = arguments['title'];
    color = arguments['color'];
    listReminder = arguments['listReminder'];
    // something();
  }

  // Future<void> something() async {
  //   setState(() {
  //     _isLoading = true;
  //   });
  //   Provider.of<Lists>(context, listen: false).fetchLists();
  //   list = Provider.of<Lists>(context, listen: false).items;
  //   for (var element in list) {
  //     await Provider.of<Reminders>(context, listen: false)
  //         .fetchReminders(element.listId)
  //         .then((value) {
  //       for (var reminder
  //           in Provider.of<Reminders>(context, listen: false).items) {
  //         listReminder.add(reminder);
  //         // print('Inside loop: $listReminder');
  //       }
  //     });
  //   }
  //   setState(() {
  //     _isLoading = false;
  //   });
  // }

  List<Widget> getScheduled() {
    List<Widget> child = [];
    for (var element in listReminder) {
      if (element.dueDate != null && element.dueDate!.isAfter(now)) {
        child.add(GroupReminderItem(
          element,
          key: ValueKey(element.reminderId),
        ));
      }
    }
    if (child == []) {
      child.add(Container());
      return child;
    }
    return child;
  }

  List<Widget> getAll() {
    List<Widget> child = [];
    for (var element in listReminder) {
      print(element.title);
      child.add(GroupReminderItem(
        element,
        key: ValueKey(element.reminderId),
      ));
    }
    if (child == []) {
      child.add(Container());
      return child;
    }
    return child;
  }

  List<Widget> getToday() {
    List<Widget> child = [];
    for (var element in listReminder) {
      if (element.dueDate != null &&
          element.dueDate?.day == DateTime.now().day &&
          element.dueDate?.month == DateTime.now().month &&
          element.dueDate?.year == DateTime.now().year) {
        print(element.title);
        child.add(GroupReminderItem(
          element,
          key: ValueKey(element.reminderId),
        ));
      }
    }
    if (child == []) {
      child.add(Container());
      return child;
    }
    return child;
  }

  List<Widget> getFlagged() {
    List<Widget> child = [];
    for (var element in listReminder) {
      if (element.flagged) {
        print(element.title);
        child.add(GroupReminderItem(
          element,
          key: ValueKey(element.reminderId),
        ));
      }
    }
    if (child == []) {
      child.add(Container());
      return child;
    }
    return child;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          elevation: 0,
          leading: TextButton.icon(
            onPressed: () {
              // Navigator.of(context).pushNamed(MyHomePage.routeName);
              Navigator.of(context).pop();
            },
            icon: Icon(CupertinoIcons.back,
                size: 26, color: Theme.of(context).primaryColor),
            label: Text(
              'Lists',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          leadingWidth: 100,
          backgroundColor: CupertinoColors.white,
          actions: [
            PopupMenuButton(
                icon: Icon(CupertinoIcons.ellipsis_circle,
                    color: Theme.of(context).primaryColor),
                itemBuilder: (_) => [])
          ]),
      body: Column(
        children: [
          SizedBox(
            height: 550,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    height: 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(title,
                            style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w500,
                                color: color)),
                      ],
                    ),
                  ),
                  SizedBox(
                          height: 500,
                          child: ListView(
                            children: title == 'Today'
                                ? getToday()
                                : title == 'Scheduled'
                                    ? getScheduled()
                                    : title == 'Flagged'
                                        ? getFlagged()
                                            : getAll(),
                          ),
                        )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
