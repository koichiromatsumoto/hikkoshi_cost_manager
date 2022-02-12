import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/all.dart';

class RecordSizePage extends StatefulWidget {

  @override
  _RecordSizePageState createState() => new _RecordSizePageState();
}

class _RecordSizePageState extends State<RecordSizePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("家具家電の寸法管理"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 80),
        child: Consumer(
          builder: (context, watch, child){
            return Column(
              children: <Widget>[
                Container(
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
              ],
            );
          }
        )
      ),
    );
  }
}