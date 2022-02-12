import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DetailFurnitureCostPage extends StatefulWidget {

  @override
  _DetailFurnitureCostPageState createState() => new _DetailFurnitureCostPageState();
}

class _DetailFurnitureCostPageState extends State<DetailFurnitureCostPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: Text("家具家電の初期費用"),
        centerTitle: true,
      ),
      body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text('家具家電'),
                ElevatedButton(
                    child: const Text('もとのページに戻る'),
                    onPressed: () => Navigator.of(context).pop()
                ),
              ]
          )
      )
  );
}