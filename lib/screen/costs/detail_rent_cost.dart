import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hikkoshi_cost_manager/components/cost_delete_confirm_dialog.dart';
import 'package:intl/intl.dart';
import 'package:hikkoshi_cost_manager/components/cost_text.dart';
import 'package:hikkoshi_cost_manager/components/cost_page_tabbar.dart';
import 'package:hikkoshi_cost_manager/components/input_cost_name_dialog.dart';
import 'package:hikkoshi_cost_manager/components/input_cost_value_dialog.dart';
import 'package:hikkoshi_cost_manager/components/list_border.dart';
import 'package:hikkoshi_cost_manager/components/sum_cost.dart';
import 'package:hikkoshi_cost_manager/model/entity/costs.dart';
import 'package:hikkoshi_cost_manager/model/repository/costs_repository.dart';
import 'package:hooks_riverpod/all.dart';

class DetailRentCostPage extends StatefulWidget {
  final CostType type;

  DetailRentCostPage(this.type);

  @override
  _DetailRentCostPageState createState() => new _DetailRentCostPageState();
}

class _DetailRentCostPageState extends State<DetailRentCostPage> {
  bool isEnabled = false;

  @override
  Widget build(BuildContext context) {
    var futureBuilder = FutureBuilder(
      future: CostRepository.getTypeAll(widget.type.typeName),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return createListView(context, Cost.costCache, false, widget.type);
          default:
            if (snapshot.hasError)
              return Text('Error: ${snapshot.error}');
            else
              Cost.costCache = snapshot.data;
            return createListView(context, Cost.costCache, true, widget.type);
        }
      },
    );

    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            title: Text("${widget.type.typeStr}の初期費用"),
            centerTitle: true,
            bottom: TabBar(
              tabs: tabs,
              unselectedLabelColor: Colors.white54,
              indicatorColor: Colors.blue,
            ),
          ),
          body: futureBuilder),
    );
  }

  Widget createListView(
      BuildContext context, List<Cost> costs, bool isEnabled, CostType type) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final formatter = NumberFormat("#,###");
    int sumBudget = sumCost(costs, CostKind.budgetCost);
    int sumActual = sumCost(costs, CostKind.actualCost);
    String sumBudgetStr = formatter.format(sumBudget).toString();
    String sumActualStr = formatter.format(sumActual).toString();
    final appBarHeight = AppBar().preferredSize.height;
    return Column(children: <Widget>[
      Container(
        padding: const EdgeInsets.all(16),
        height: 140,
        child: Column(
          children: <Widget>[
            Table(
              defaultColumnWidth: IntrinsicColumnWidth(),
              children: [
                TableRow(
                  children: [
                    Text(
                      "予算",
                      style: TextStyle(fontSize: 15, color: Colors.black87),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Text(
                      sumBudgetStr != "0" ? "$sumBudgetStr 円" : "なし",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.black),
                    ),
                  ],
                ),
                TableRow(children: [
                  Text(
                    "実際の費用",
                    style: TextStyle(fontSize: 15, color: Colors.black87),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Text(
                    sumActualStr != "0" ? "$sumActualStr 円" : "なし",
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        fontSize: 16,
                        color: (sumBudgetStr != "0" &&
                                sumActualStr != "0" &&
                                sumBudget < sumActual)
                            ? Colors.redAccent
                            : Colors.black),
                  ),
                ])
              ],
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              child: const Text('初期費用を追加'),
              style: ElevatedButton.styleFrom(
                primary: Colors.lightBlue,
                onPrimary: Colors.white,
              ),
              onPressed: () {
                if (isEnabled == true) {
                  inputCostNameDialog(context, CostKind.actualCost, type);
                }
              },
            ),
          ],
        ),
      ),
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.7 - (appBarHeight),
        child: TabBarView(
          children: <Widget>[
            SingleChildScrollView(
              child: Container(
                color: Color.fromRGBO(220, 220, 220, 1.0),
                child: Column(children: <Widget>[
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return Row(
                        children: <Widget>[
                          Container(
                            width: deviceWidth,
                            height: 50,
                            child: Row(
                              children: <Widget>[
                                Container(
                                  width: deviceWidth * 0.12,
                                  child: IconButton(
                                    onPressed: () {
                                      costDeleteConfirmDialog(
                                          context, costs[index]);
                                    },
                                    icon: Icon(Icons.clear,color:Colors.grey),
                                  ),
                                ),
                                Container(
                                  width: deviceWidth * 0.88,
                                  child: TextButton(
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(costs[index].getName,
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.black87)),
                                          ),
                                          costText(
                                              costs[index], CostKind.budgetCost),
                                        ],
                                      ),
                                    ),
                                    onPressed: () {
                                      if (isEnabled == true) {
                                        inputCostValueDialog(context,
                                            costs[index], CostKind.budgetCost);
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                            decoration: BoxDecoration(
                              border: listBorder(index),
                              color: Colors.white,
                            ),
                          ),
                        ],
                      );
                    },
                    itemCount: costs.length,
                  ),
                ]),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                color: Color.fromRGBO(220, 220, 220, 1.0),
                child: Column(children: <Widget>[
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return Row(
                        children: <Widget>[
                          Container(
                            width: deviceWidth,
                            height: 50,
                            child: Row(
                              children: <Widget>[
                                Container(
                                  width: deviceWidth * 0.12,
                                  child: IconButton(
                                    onPressed: () {
                                      costDeleteConfirmDialog(
                                          context, costs[index]);
                                    },
                                    icon: Icon(Icons.clear,color:Colors.grey),
                                  ),
                                ),
                                Container(
                                  width: deviceWidth * 0.88,
                                  child: TextButton(
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(costs[index].getName,
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.black87)),
                                          ),
                                          costText(
                                              costs[index], CostKind.actualCost),
                                        ],
                                      ),
                                    ),
                                    onPressed: () {
                                      if (isEnabled == true) {
                                        inputCostValueDialog(context,
                                            costs[index], CostKind.actualCost);
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                            decoration: BoxDecoration(
                              border: listBorder(index),
                              color: Colors.white,
                            ),
                          ),
                        ],
                      );
                    },
                    itemCount: costs.length,
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    ]);
  }
}
