import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:reminder_app/widgets/group_item.dart';
import 'package:reminder_app/dummy_data.dart';
import '../providers/list.dart' as LL;
import '../providers/lists.dart';
import '../providers/reminder.dart';
import '../providers/reminders.dart';

class GroupsScreen extends StatefulWidget {
  final bool edit;

  const GroupsScreen(this.edit);

  @override
  State<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  List<LL.List> list = [];
  List<Reminder> listReminder = [];
  bool _isLoading = false;

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<Reminders>(context, listen: false)
          .fetchReminders()
          .then((value) {
        for (var reminder
            in Provider.of<Reminders>(context, listen: false).items) {
          listReminder.add(reminder);
        }
      });
      setState(() {
        _isLoading = false;
      });
    });
  }

  // Future<void> something() async {
  //   print('Start something');
  //   setState(() {
  //     _isLoading = true;
  //   });
  //   print('Doing something');
  //   Provider.of<Lists>(context, listen: false).fetchLists();
  //   list = Provider.of<Lists>(context, listen: false).items;
  //   for (var element in list) {
  //     await Provider.of<Reminders>(context, listen: false)
  //         .fetchReminders(element.listId)
  //         .then((value) {
  //       for (var reminder
  //           in Provider.of<Reminders>(context, listen: false).items) {
  //         listReminder.add(reminder);
  //       }
  //     });
  //   }
  //   setState(() {
  //     _isLoading = false;
  //   });
  //   print('End something');
  // }

  List<Widget> getGroup() {
    List<Widget> child = [];
    for (int i = 0; i < listGroup.length; i++) {
      child.add(GroupItem(
        listGroup[i]['groupName'] as String,
        listGroup[i]['icon'] as IconData,
        listGroup[i]['color'] as Color,
        widget.edit,
        listReminder,
        key: ValueKey('$i'),
      ));
    }
    return child;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: widget.edit ? 250 : 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
        child: _isLoading
            ? const Center(child: CupertinoActivityIndicator())
            : widget.edit
                ? ReorderableListView(
                    onReorder: (oldIndex, newIndex) {
                      setState(() {
                        if (newIndex > oldIndex) {
                          newIndex -= 1;
                        }
                        var item = listGroup.removeAt(oldIndex);
                        listGroup.insert(newIndex, item);
                      });
                    },
                    children: getGroup(),
                  )
                : GridView(
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                            mainAxisSpacing: 20,
                            crossAxisSpacing: 20,
                            maxCrossAxisExtent: 200,
                            childAspectRatio: 1.5,
                            mainAxisExtent: 80),
                    padding: const EdgeInsets.all(5),
                    children: getGroup()));
  }
}
