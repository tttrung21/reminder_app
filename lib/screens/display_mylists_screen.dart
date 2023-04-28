import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/display_mylists_item.dart';

import '../providers/lists.dart';

class DisplayScreen extends StatelessWidget {
  var _isLoading = false;

  Future<void> _onRefresh(BuildContext context) async {
    await Provider.of<Lists>(context, listen: false).fetchLists();
  }

  @override
  Widget build(BuildContext context) {
    // var listData = Provider.of<Lists>(context).items;
    return Container(
      height: 270,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: Container(
        decoration: BoxDecoration(
            color: CupertinoColors.white,
            borderRadius: BorderRadius.circular(15)),
        child: FutureBuilder(
            future: _onRefresh(context),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) =>
                snapshot.connectionState == ConnectionState.waiting
                    ? const Center(child: CupertinoActivityIndicator())
                    : RefreshIndicator(
                        child: Consumer<Lists>(
                          builder: (ctx,listData,_)
                          => ListView.separated(
                              itemCount: listData.items.length,
                              itemBuilder: (BuildContext context, int index) {
                                return DisplayItem(listData.items[index]);
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) =>
                                      const Divider(
                                        thickness: 1,
                                        indent: 70,
                                        height: 2,
                                      )),
                        ),
                        onRefresh: () => _onRefresh(context))),
      ),
    );
  }
}
