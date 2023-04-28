import 'package:flutter/cupertino.dart';

var listColor = const [
  Color(0xffD34329),
  Color(0xFFD38a29),
  Color(0xFFEacc61),
  Color(0xff4bc95e),
  Color(0xFF88a3f4),
  Color(0xff2e55cb),
  Color(0xff482da8),
  Color(0xFFA83066),
  Color(0xffB058ae),
  Color(0xff7b6b59),
  Color(0xFF4b4a4a),
  Color(0xffB09d9d),
];

var listIcon = const [
  CupertinoIcons.smiley,
  CupertinoIcons.list_bullet,
  CupertinoIcons.bookmark_fill,
  CupertinoIcons.map_pin,
  CupertinoIcons.gift_fill,
  CupertinoIcons.alarm,
  CupertinoIcons.hammer,
  CupertinoIcons.briefcase,
  CupertinoIcons.pencil,
  CupertinoIcons.doc_fill,
  CupertinoIcons.book_solid,
  CupertinoIcons.folder_solid
];

var listGroup = [
  {
    'groupName': 'Today',
    'icon': CupertinoIcons.calendar_today,
    'color' : CupertinoColors.systemBlue,
    'show' : true
  },
  {
    'groupName': 'Scheduled',
    'icon': CupertinoIcons.calendar,
    'color' : CupertinoColors.destructiveRed,
    'show' : true
  },
  {
    'groupName': 'All',
    'icon': CupertinoIcons.tray_fill,
    'color' : CupertinoColors.systemGrey,
    'show' : true
  },
  {
    'groupName': 'Flagged',
    'icon': CupertinoIcons.flag_fill,
    'color' : CupertinoColors.activeOrange,
    'show' : true
  }
  ];