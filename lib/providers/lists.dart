import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:reminder_app/providers/reminder.dart';
import 'list.dart' as LL;

class Lists with ChangeNotifier {
  List<LL.List> _items = [];
  List<Reminder> _listReminder = [];

  List<LL.List> get items {
    return [..._items];
  }

  LL.List findByListId(String listId) {
    return _items.firstWhere((list) => list.listId == listId);
  }

  int remindersCount(String id) {
    int num = _listReminder.where((list) => list.listId == id).length;
    if (num == 0) {
      return 0;
    }
    return num;
  }

  Future<void> fetchLists() async {
    final url = Uri.parse('https://6421000282bea25f6d0a4a86.mockapi.io/list');
    try {
      var response = await http.get(url);
      final extractedData = json.decode(response.body);
      final List<LL.List> loadedLists = [];
      for (var listData in extractedData) {
        loadedLists.add(LL.List(
            listId: listData['listId'],
            title: listData['title'],
            icon: listData['icon'],
            color: listData['color']));
      }
      _items = loadedLists;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addList(LL.List list) async {
    final url = Uri.parse('https://6421000282bea25f6d0a4a86.mockapi.io/list');
    print(list.title);
    try {
      final response = await http.post(url,
          headers: {'content-type': 'application/json'},
          body: json.encode({
            'listId': list.listId,
            'title': list.title,
            'icon': list.icon,
            'color': list.color
          }));
      print(response.body);
      final newList = LL.List(
          listId: list.listId,
          title: list.title,
          icon: list.icon,
          color: list.color);
      _items.add(newList);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateList(LL.List list, String listId) async {
    var listIndex = _items.indexWhere((element) => element.listId == listId);
    final url =
        Uri.parse('https://6421000282bea25f6d0a4a86.mockapi.io/list/$listId');
    final response = await http.patch(url,
        headers: {'content-type': 'application/json'},
        body: json.encode({
          'listId': listId,
          'title': list.title,
          'icon': list.icon,
          'color': list.color
        }));
    print(response.body);
    _items[listIndex] = list;
    notifyListeners();
  }

  Future<void> deleteList(String listId) async {
    final url =
        Uri.parse('https://6421000282bea25f6d0a4a86.mockapi.io/list/$listId');
    var existingListIndex =
        _items.indexWhere((element) => element.listId == listId);
    LL.List? existingList = _items[existingListIndex];
    _items.removeAt(existingListIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingListIndex, existingList);
      notifyListeners();
      throw response.statusCode;
    }
    existingList = null;
  }
}
