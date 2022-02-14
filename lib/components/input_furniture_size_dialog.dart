import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hikkoshi_cost_manager/model/entity/costs.dart';
import 'package:hikkoshi_cost_manager/model/entity/furnitures.dart';
import 'package:hikkoshi_cost_manager/model/repository/costs_repository.dart';
import 'package:hikkoshi_cost_manager/model/repository/furnitures_repository.dart';

Future<void> inputFurnitureSizeDialog(BuildContext context, {Furniture? furniture = null}) async {
  final _formKey = GlobalKey<FormState>();
  return showDialog(
      context: context,
      builder: (context) {
        var furnitureName = null;
        var furnitureWidth = null;
        var furnitureHeight = null;
        var furnitureDepth = null;
        var furnitureRemark = null;
        String? initialFurnitureName = "";
        String? initialFurnitureWidth = "";
        String? initialFurnitureHeight = "";
        String? initialFurnitureDepth = "";
        String? initialFurnitureRemark = "";
        if (furniture != null) {
          // ignore: unnecessary_null_comparison
          initialFurnitureName = furniture.name != null ? furniture.name : "";
          initialFurnitureWidth = furniture.width != null ? furniture.width.toString() : "";
          initialFurnitureHeight = furniture.height != null ? furniture.height.toString() : "";
          initialFurnitureDepth = furniture.depth != null ? furniture.depth.toString() : "";
          initialFurnitureRemark = furniture.remark != null ? furniture.remark : "";
        }
        final TextEditingController _furnitureNameController =
        new TextEditingController(text: initialFurnitureName);
        final TextEditingController _furnitureWidthController =
        new TextEditingController(text: initialFurnitureWidth);
        final TextEditingController _furnitureHeightController =
        new TextEditingController(text: initialFurnitureHeight);
        final TextEditingController _furnitureDepthController =
        new TextEditingController(text: initialFurnitureDepth);
        final TextEditingController _furnitureRemarkController =
        new TextEditingController(text: initialFurnitureRemark);
        return AlertDialog(
          title: Text("寸法を記録"),
          content: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: 400.0,
            ),
            child: Form(
              key: _formKey,
              child: Column(children: <Widget>[
                TextFormField(
                  controller: _furnitureNameController,
                  decoration: InputDecoration(
                    labelText: "家具家電名",
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 0,
                      horizontal: 15,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () => _furnitureNameController.clear(),
                      icon: Icon(Icons.clear),
                    ),
                  ),
                  keyboardType: TextInputType.text,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(12),
                  ],
                  onChanged: (value) {
                    furnitureName = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '家具家電名を入力してください';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _furnitureWidthController,
                  decoration: InputDecoration(
                    labelText: "幅",
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 0,
                      horizontal: 15,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () => _furnitureWidthController.clear(),
                      icon: Icon(Icons.clear),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(7),
                  ],
                  onChanged: (value) {
                    furnitureWidth = value;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _furnitureHeightController,
                  decoration: InputDecoration(
                    labelText: "高さ",
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 0,
                      horizontal: 15,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () => _furnitureHeightController.clear(),
                      icon: Icon(Icons.clear),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(7),
                  ],
                  onChanged: (value) {
                    furnitureHeight = value;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _furnitureDepthController,
                  decoration: InputDecoration(
                    labelText: "奥行",
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 0,
                      horizontal: 15,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () => _furnitureDepthController.clear(),
                      icon: Icon(Icons.clear),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(7),
                  ],
                  onChanged: (value) {
                    furnitureDepth = value;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _furnitureRemarkController,
                  decoration: InputDecoration(
                    labelText: "備考",
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 0,
                      horizontal: 15,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () => _furnitureRemarkController.clear(),
                      icon: Icon(Icons.clear),
                    ),
                  ),
                  keyboardType: TextInputType.text,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(50),
                  ],
                  onChanged: (value) {
                    furnitureRemark = value;
                  },
                ),
              ]),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'キャンセル',
                style: TextStyle(color: Colors.blue),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                primary: Colors.white,
              ),
            ),
            TextButton(
              child: Text(
                'OK',
                style: TextStyle(color: Colors.blue),
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  int? parsedWidth = null;
                  int? parsedHeight = null;
                  int? parsedDepth = null;
                  if (furnitureWidth != null && furnitureWidth != "") {
                    parsedWidth = int.parse(furnitureWidth!);
                    if (parsedWidth == 0) {
                      parsedWidth = null;
                    }
                  }
                  if (furnitureHeight != null && furnitureHeight != "") {
                    parsedHeight = int.parse(furnitureHeight!);
                    if (parsedHeight == 0) {
                      parsedHeight = null;
                    }
                  }
                  if (furnitureDepth  != null && furnitureDepth != "") {
                    parsedDepth = int.parse(furnitureDepth!);
                    if (parsedDepth == 0) {
                      parsedDepth = null;
                    }
                  }
                  FurnitureRepository.create(
                      name: furnitureName,
                      width: parsedWidth,
                      height: parsedHeight,
                      depth: parsedDepth,
                      remark: furnitureRemark,
                  );
                  Navigator.pop(context);
                }
              },
              style: TextButton.styleFrom(
                primary: Colors.white,
              ),
            ),
          ],
        );
      });
}
