import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hikkoshi_cost_manager/screen/costs/cost_manage_page.dart';
import 'package:hikkoshi_cost_manager/screen/record_photo/record_photo_page.dart';
import 'package:hikkoshi_cost_manager/screen/record_size/record_size_page.dart';
import 'package:hikkoshi_cost_manager/state/navigation_history_provider.dart';
import 'package:hooks_riverpod/all.dart';

class MainPage extends StatelessWidget {

  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        body: Consumer(
            builder: (context, watch, child) {
              return CupertinoTabScaffold(
                  controller: context.read(navigationHistoryProvider).controller,
                  tabBar: CupertinoTabBar(
                    items: const <BottomNavigationBarItem>[
                      BottomNavigationBarItem(
                          icon: Icon(CupertinoIcons.money_yen_circle), label: '初期費用'),
                      BottomNavigationBarItem(
                          icon: Icon(CupertinoIcons.square_list), label: '寸法記録'),
                      BottomNavigationBarItem(
                          icon: Icon(CupertinoIcons.rectangle_paperclip), label: '入居時記録'),
                    ],
                    activeColor: Colors.blueAccent,
                  ),
                  tabBuilder: (BuildContext context, int index) =>
                      Navigator(
                          initialRoute: 'main/tabs',
                          onGenerateRoute: (RouteSettings settings) =>
                              MaterialPageRoute<PageRoute<Widget>>(
                                  settings: settings,
                                  builder: (_) =>
                                  <Widget>[
                                    CostManagePage(),
                                    RecordSizePage(),
                                    RecordPhotoPage(),
                                  ][index]
                              )
                      )
              );
            }
        )
    );
  }
}