import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DetailOtherCostPage extends StatefulWidget {

  @override
  _DetailOtherCostPageState createState() => new _DetailOtherCostPageState();
}

class _DetailOtherCostPageState extends State<DetailOtherCostPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: Text("その他の初期費用"),
        centerTitle: true,
      ),
      body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text('その他'),
                ElevatedButton(
                    child: const Text('もとのページに戻る'),
                    onPressed: () => Navigator.of(context).pop()
                ),
              ]
          )
      )
  );
}