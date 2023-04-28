import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'reminder.dart';

class Reminders with ChangeNotifier {
  List<Reminder> _items = [];

  List<Reminder> get items {
    return [..._items];
  }

  List<Reminder> itemsByListId(String listId) {
    return _items.where((reminder) => reminder.listId == listId).toList();
  }

  Reminder itemByReminderId(String reminderId) {
    return _items.firstWhere((element) => element.reminderId == reminderId);
  }

  List<Priority> get getPrio {
    return Priority.values.toList();
  }

  List<Reminder> completedReminder(String listId) {
    return _items
        .where(
            (element) => element.completed == true && element.listId == listId)
        .toList();
  }

  Future<void> toggleCompleted(
      String listId, String reminderId, bool completed) async {
    var oldVal = !completed;
    final url = Uri.parse(
        'https://6421000282bea25f6d0a4a86.mockapi.io/reminder/$reminderId');
    try {
      var response = await http.patch(url,
          headers: {'content-type': 'application/json'},
          body: json.encode({'completed': completed}));

      if (response.statusCode >= 400) {
        completed = oldVal;
        notifyListeners();
      }
    } catch (error) {
      completed = oldVal;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> fetchReminders() async {
    final url =
        Uri.parse('https://6421000282bea25f6d0a4a86.mockapi.io/reminder');
    try {
      var response = await http.get(url);
      final extractedData = json.decode(response.body);
      final List<Reminder> loadedReminders = [];
      for (var reminderData in extractedData) {
        loadedReminders.add(Reminder(
            reminderId: reminderData['reminderId'],
            listId: reminderData['listId'],
            title: reminderData['title'],
            dueDate: reminderData['dueDate'] == null
                ? null
                : DateTime.parse(reminderData['dueDate']),
            dueTime: reminderData['dueTime'] == null
                ? null
                : DateTime.parse(reminderData['dueTime']),
            flagged: reminderData['flagged'],
            completed: reminderData['completed'],
            tags: reminderData['tags'] == null
                ? null
                : List<String>.from(reminderData['tags']),
            subTasks: reminderData['subTasks'] == null
                ? null
                : List<String>.from(reminderData['subTasks']),
            priority: Priority.values.firstWhere(
                (element) => element.name == reminderData['priority']),
            imageUrl: reminderData['imageUrl'],
            notes: reminderData['notes'],
            repeat: reminderData['repeat']));
      }
      _items = loadedReminders;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addReminder(Reminder reminder) async {
    final url =
        Uri.parse('https://6421000282bea25f6d0a4a86.mockapi.io/reminder');
    try {
      var response = await http.post(url,
          headers: {'content-type': 'application/json'},
          body: json.encode({
            'reminderId': reminder.reminderId,
            'listId': reminder.listId,
            'title': reminder.title,
            'dueDate': reminder.dueDate?.toIso8601String(),
            'dueTime': reminder.dueTime?.toIso8601String(),
            'flagged': reminder.flagged,
            'completed': reminder.completed,
            'tags': reminder.tags,
            'priority': reminder.priority.toString().substring(9),
            'subTasks': reminder.subTasks,
            'imageUrl': reminder.imageUrl,
            'notes': reminder.notes,
            'repeat': reminder.repeat
          }));
      print(response.body);
      final newReminder = Reminder(
          reminderId: reminder.reminderId,
          listId: reminder.listId,
          title: reminder.title,
          dueDate: reminder.dueDate,
          dueTime: reminder.dueTime,
          flagged: reminder.flagged,
          completed: reminder.completed,
          tags: reminder.tags,
          priority: reminder.priority,
          subTasks: reminder.subTasks,
          imageUrl: reminder.imageUrl,
          notes: reminder.notes,
          repeat: reminder.repeat);
      _items.add(newReminder);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateReminder(Reminder reminder) async {
    final reminderIndex = _items
        .indexWhere((element) => element.reminderId == reminder.reminderId);
    final url = Uri.parse(
        'https://6421000282bea25f6d0a4a86.mockapi.io/reminder/${reminder.reminderId}');
    final response = await http.patch(url,
        headers: {'content-type': 'application/json'},
        body: json.encode({
          'reminderId': reminder.reminderId,
          'listId': reminder.listId,
          'title': reminder.title,
          'dueDate': reminder.dueDate?.toIso8601String(),
          'dueTime': reminder.dueTime?.toIso8601String(),
          'flagged': reminder.flagged,
          'completed': reminder.completed,
          'tags': reminder.tags,
          'priority': reminder.priority.toString().substring(9),
          'subTasks': reminder.subTasks,
          'imageUrl': reminder.imageUrl,
          'notes': reminder.notes,
          'repeat': reminder.repeat
        }));
    print(response.body);
    _items[reminderIndex] = reminder;
    notifyListeners();
  }

  Future<void> deleteReminder(String reminderId, String listId) async {
    final url = Uri.parse(
        'https://6421000282bea25f6d0a4a86.mockapi.io/reminder/$reminderId');
    var existingReminderIndex =
        _items.indexWhere((element) => element.reminderId == reminderId);
    Reminder? existingReminder = _items[existingReminderIndex];
    _items.removeAt(existingReminderIndex);

    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingReminderIndex, existingReminder);
      notifyListeners();
      throw response.statusCode;
    }
    existingReminder = null;
  }
}
