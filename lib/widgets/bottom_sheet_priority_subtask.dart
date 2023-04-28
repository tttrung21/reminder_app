import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/priority_item.dart';

import '../providers/reminders.dart';

class PriorityTaskTags extends StatefulWidget {
  final int index;
  final List<String> list;
  PriorityTaskTags(this.index,this.list);
  //Priority 0 SubTasks 1 Tags 2
  @override
  State<PriorityTaskTags> createState() => _PriorityTaskTagsState();
}

class _PriorityTaskTagsState extends State<PriorityTaskTags> {
  final taskTextController = TextEditingController();
  final tagsTextController = TextEditingController();
  final List<String> listTasks = [];
  final List<String> listTags = [];

  @override
  void initState() {
    super.initState();
    if (widget.index == 1) {
      listTasks.addAll(widget.list);
    }
    if (widget.index == 2) {
      listTags.addAll(widget.list);
    }
  }

  void submitSubTasks() {
    var task = taskTextController.text;
    if (task.isEmpty) return;
    listTasks.add(task);
    taskTextController.clear();
  }

  void submitTags() {
    var tag = tagsTextController.text;
    if (tag.isEmpty) return;
    listTags.add(tag);
    tagsTextController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;
    return Container(
      color: CupertinoColors.systemGrey5,
      height: screenH * 0.9,
      padding: EdgeInsets.only(
          left: 10,
          right: 10,
          top: 10,
          bottom: MediaQuery.of(context).viewInsets.bottom + 10),
      child: widget.index == 0
          ? Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Cancel',
                            style: Theme.of(context).textTheme.headlineSmall)),
                    const Text('Priority', style: TextStyle(fontSize: 18)),
                    const Text('                 ',
                        style: TextStyle(
                          fontSize: 18,
                        ))
                  ],
                ),
                Container(
                  height: 500,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: CupertinoColors.systemGrey6,
                  ),
                  child: FutureBuilder(
                      builder: (context, snapshot) =>
                          snapshot.connectionState == ConnectionState.waiting
                              ? const Center(child: CircularProgressIndicator())
                              : Consumer<Reminders>(
                                  builder: (ctx, remindersData, _) => Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: ListView.separated(
                                        itemCount: remindersData.getPrio.length,
                                        separatorBuilder: (ctx, index) {
                                          return const Divider(
                                            indent: 10,
                                            color: Colors.black45,
                                          );
                                        },
                                        itemBuilder: (context, index) =>
                                            PriorityItem(remindersData
                                                .getPrio[index])),
                                  ),
                                )),
                )
              ],
            )
          : widget.index == 1
              ? SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(listTasks);
                              },
                              child: Text('Cancel',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall)),
                          const Text('Subtasks',
                              style: TextStyle(fontSize: 18)),
                          const Text('                 ',
                              style: TextStyle(
                                fontSize: 18,
                              ))
                        ],
                      ),
                      TextField(
                        controller: taskTextController,
                        decoration: const InputDecoration(hintText: 'Task'),
                      ),
                      TextButton(
                          onPressed: () {
                            submitSubTasks();
                            setState(() {});
                          },
                          child: const Text('Add subtask')),
                      Container(
                        height: 400,
                        padding: const EdgeInsets.all(5),
                        child: ListView.builder(
                            itemCount: listTasks.length,
                            itemBuilder: (context, index) => Card(
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Colors.white),
                                    child: Text(
                                      listTasks[index],
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    ),
                                  ),
                                )),
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
                                Navigator.of(context).pop(listTags);
                              },
                              child: Text('Cancel',
                                  style:
                                      Theme.of(context).textTheme.headlineSmall)),
                          const Text('Tags', style: TextStyle(fontSize: 18)),
                          const Text('                 ',
                              style: TextStyle(
                                fontSize: 18,
                              ))
                        ],
                      ),
                      TextField(
                        controller: tagsTextController,
                        decoration: const InputDecoration(hintText: 'Tag'),
                      ),
                      TextButton(
                          onPressed: () {
                            submitTags();
                            setState(() {});
                          },
                          child: const Text('Add tag')),
                      Container(
                        height: 400,
                        padding: const EdgeInsets.all(5),
                        child: ListView.builder(
                            itemCount: listTags.length,
                            itemBuilder: (context, index) => Card(
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Colors.white),
                                    child: Text(
                                      '#${listTags[index]}',
                                      style:
                                          Theme.of(context).textTheme.titleMedium,
                                    ),
                                  ),
                                )),
                      )
                    ],
                  ),
              ),
    );
  }
}
