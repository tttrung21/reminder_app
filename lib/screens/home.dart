import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widgets/bottom_sheet_add_list_reminder.dart';
import '../widgets/main_footer.dart';
import 'display_mylists_screen.dart';
import 'group_screen.dart';

class MyHomePage extends StatefulWidget {
  static const routeName = '/home';

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool edit = false;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: CupertinoColors.systemGrey5,
        elevation: 0,
        actions: [
          TextButton(
              onPressed: () {
                setState(() {
                  edit = !edit;
                });
              },
              child: edit
                  ? const Text('Done',
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 18))
                  : const Text(
                      'Edit',
                      style:
                          TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
                    ))
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: 550,
            child: SingleChildScrollView(
              child: Container(
                color: CupertinoColors.systemGrey5,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    CupertinoSearchTextField(
                      onChanged: (_){

                      },
                    ),
                    const SizedBox(height: 10),
                    GroupsScreen(edit),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'My Lists',
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    DisplayScreen(),
                  ],
                ),
              ),
            ),
          ),
          MainFooter()
          // Footer()
        ],
      ),
    );
  }
}

// class Footer extends StatefulWidget {
//
//   @override
//   State<Footer> createState() => _FooterState();
// }
//
// class _FooterState extends State<Footer> {
//   var selected = 0;
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 50,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         crossAxisAlignment: CrossAxisAlignment.end,
//         children: [
//           TextButton.icon(
//               onPressed: () {
//                 showModalBottomSheet(
//                     isScrollControlled: true,
//                     shape: const RoundedRectangleBorder(
//                         borderRadius:
//                         BorderRadius.vertical(top: Radius.circular(10))),
//                     context: context,
//                     builder: (_) {
//                       selected = 1;
//                       return AddList(selected, false,'');
//                     });
//               },
//               icon: const Icon(CupertinoIcons.add_circled_solid),
//               label: Text(
//                 'New Reminder',
//                 style: TextStyle(
//                     color: Theme.of(context).primaryColor,
//                     fontSize: 18,
//                     fontWeight: FontWeight.w500
//                 ),
//               )),
//           TextButton(
//               onPressed: () {
//                 showModalBottomSheet(
//                     shape: const RoundedRectangleBorder(
//                         borderRadius:
//                         BorderRadius.vertical(top: Radius.circular(10))),
//                     isScrollControlled: true,
//                     context: context,
//                     builder: (_) {
//                       selected = 0;
//                       return AddList(selected, false,'');
//                     });
//               },
//               child: Text('Add list',
//                   style: Theme.of(context).textTheme.headlineSmall))
//         ],
//       ),
//     );
//   }
// }

