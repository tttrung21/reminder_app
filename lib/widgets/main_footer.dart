import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reminder_app/widgets/bottom_sheet_add_list_reminder.dart';

class MainFooter extends StatelessWidget {
  var selected = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          TextButton.icon(
              onPressed: () {
                showModalBottomSheet(
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(10))),
                    context: context,
                    builder: (_) {
                      selected = 1;
                      return AddList(selected, false,'');
                    });
              },
              icon: const Icon(CupertinoIcons.add_circled_solid),
              label: Text(
                'New Reminder',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w500
                ),
              )),
          TextButton(
              onPressed: () {
                showModalBottomSheet(
                    shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(10))),
                    isScrollControlled: true,
                    context: context,
                    builder: (_) {
                      selected = 0;
                      return AddList(selected, false,'');
                    });
              },
              child: Text('Add list',
                  style: Theme.of(context).textTheme.headlineSmall))
        ],
      ),
    );
  }
}
