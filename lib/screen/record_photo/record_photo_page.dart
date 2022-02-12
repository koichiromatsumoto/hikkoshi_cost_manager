import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/all.dart';

class RecordPhotoPage extends StatefulWidget {

  @override
  _RecordPhotoPageState createState() => new _RecordPhotoPageState();
}

class _RecordPhotoPageState extends State<RecordPhotoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("入居時の状態を記録"),
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
                    "お部屋の入居時の状態を\n写真で記録しましょう",
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