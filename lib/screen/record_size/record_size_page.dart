import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hikkoshi_cost_manager/components/input_furniture_size_dialog.dart';
import 'package:hikkoshi_cost_manager/model/db/costs_database.dart';
import 'package:hikkoshi_cost_manager/model/entity/furnitures.dart';
import 'package:hikkoshi_cost_manager/model/repository/furnitures_repository.dart';
import 'package:hooks_riverpod/all.dart';

class RecordSizePage extends StatefulWidget {

  @override
  _RecordSizePageState createState() => new _RecordSizePageState();
}

class _RecordSizePageState extends State<RecordSizePage> {
  @override
  // ignore: must_call_super
  void initState(){
    final CostsDatabase instance = CostsDatabase.instance;
    final db = instance.database;
  }

  @override
  Widget build(BuildContext context) {
    var futureBuilder = FutureBuilder(
      future: FurnitureRepository.getAll(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return mainCardView(context, Furniture.mainCache, false);
          default:
            if (snapshot.hasError)
              return Text('Error: ${snapshot.error}');
            else
              Furniture.mainCache = snapshot.data;
            return mainCardView(context, Furniture.mainCache, true);
        }
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("家具家電の寸法管理"),
        centerTitle: true,
      ),
      body: futureBuilder
    );
  }

  Widget mainCardView(BuildContext context, List<Furniture> furnitures, bool isEnabled) {
    final deviceWidth = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 80),
        child: Consumer(
            builder: (context, watch, child){
              return Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.fromLTRB(40, 30, 30, 15),
                    child: Text(
                      "家具家電の配置場所の寸法を\n記録しましょう",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    child: const Text('寸法を記録'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.lightBlue,
                      onPrimary: Colors.white,
                    ),
                    onPressed: () {
                      if (isEnabled == true) {
                        inputFurnitureSizeDialog(context);
                      }
                    },
                  ),
                  SizedBox(height: 10),
                  ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    final furnitureWidthStr = furnitures[index].width != null ? furnitures[index].width.toString() : "";
                    final furnitureHeightStr = furnitures[index].height != null ? furnitures[index].height.toString() : "";
                    final furnitureDepthStr = furnitures[index].depth != null ? furnitures[index].depth.toString() : "";
                    final furnitureRemark = furnitures[index].remark != null ? furnitures[index].remark : "";
                    return Center(
                      child: SizedBox(
                        width: deviceWidth,
                        child: Card(
                          elevation: 5,
                          shadowColor: Colors.blueGrey,
                          child: InkWell(
                            onTap:() {
                              inputFurnitureSizeDialog(context, furniture: furnitures[index]);
                            },
                            child: Column(
                                children: <Widget> [
                                  Container(
                                    padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      furnitures[index].name,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
                                    alignment: Alignment.bottomLeft,
                                    child: Table(
                                      defaultColumnWidth: IntrinsicColumnWidth(),
                                      children: [
                                        TableRow(
                                          children: [
                                            Text(
                                              '幅: ',
                                              style: TextStyle(
                                                fontSize: 16,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 16,
                                            ),
                                            Text(
                                              '$furnitureWidthStr cm',
                                              style: TextStyle(
                                                fontSize: 16,
                                              ),
                                              textAlign: TextAlign.right,
                                            ),
                                          ],
                                        ),
                                        TableRow(children: [
                                          Text(
                                            '高さ: ',
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 16,
                                          ),
                                          Text(
                                            '$furnitureHeightStr cm',
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                            textAlign: TextAlign.right,
                                          ),
                                        ]),
                                        TableRow(
                                          children: [
                                            Text(
                                              '奥行: ',
                                              style: TextStyle(
                                                fontSize: 16,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 16,
                                            ),
                                            Text(
                                              '$furnitureDepthStr cm',
                                              style: TextStyle(
                                                fontSize: 16,
                                              ),
                                              textAlign: TextAlign.right,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.fromLTRB(25, 0, 25, 10),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      '備考: $furnitureRemark',
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ]
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: furnitures.length,
                  ),
                ],
              );
            }
        )
    );
  }
}