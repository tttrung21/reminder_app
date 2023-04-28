import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/list.dart' as LL;
import '../screens/mylists_detail_screen.dart';
import '../providers/reminders.dart';

class DisplayItem extends StatefulWidget {
  final LL.List listData;

  const DisplayItem(this.listData, {super.key});

  @override
  State<DisplayItem> createState() => _DisplayItemState();
}

class _DisplayItemState extends State<DisplayItem> {
  var count = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<Reminders>(context, listen: false)
        .fetchReminders()
        .then((value) {
      setState(() {
        count = Provider.of<Reminders>(context,listen: false)
            .itemsByListId(widget.listData.listId)
            .length;
      });
      // print('${widget.listData.listId}:  $count');
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Container(
          decoration: BoxDecoration(color: Color(widget.listData.color)),
          width: 30,
          height: 30,
          child: Icon(IconData(widget.listData.icon,fontFamily: CupertinoIcons.iconFont,fontPackage: CupertinoIcons.iconFontPackage),
            color: CupertinoColors.white,
            size: 18,
          ),
        ),
      ),
      title: Row(children: [
        Flexible(
            child: Padding(
          padding: const EdgeInsets.all(5),
          child: Text(
            widget.listData.title,
            style: Theme.of(context).textTheme.titleSmall,
            overflow: TextOverflow.ellipsis,
          ),
        )),
      ]),
      padding: const EdgeInsets.all(15),
      additionalInfo: Text('$count'),
      trailing: const CupertinoListTileChevron(),
      onTap: () {
        Navigator.of(context).pushNamed(MylistsDetailScreen.routeName,
            arguments: widget.listData.listId);
      },
    );
  }
}
