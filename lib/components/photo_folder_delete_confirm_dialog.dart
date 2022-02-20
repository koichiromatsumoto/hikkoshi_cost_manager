import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hikkoshi_cost_manager/model/entity/costs.dart';
import 'package:hikkoshi_cost_manager/model/entity/photo_folders.dart';
import 'package:hikkoshi_cost_manager/model/repository/costs_repository.dart';
import 'package:hikkoshi_cost_manager/model/repository/photo_folders_repository.dart';
import 'package:hikkoshi_cost_manager/model/repository/photos_repository.dart';

Future<void> photoFolderDeleteConfirmDialog(
    BuildContext context, PhotoFolder photoFolder, String photosCount) async {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: SizedBox(
            height: 100,
            child: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "${photoFolder.getName}を削除してよろしいですか？",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                Container(
                    alignment: Alignment.centerLeft,
                    child: Text(photosCount != "0"
                        ? "このフォルダに登録されている$photosCount枚の写真も削除されます\n※端末に保存されている写真は削除されません"
                        : "※端末に保存されている写真は削除されません")),
              ],
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
                PhotoFolderRepository.delete(photoFolder.id);
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                primary: Colors.white,
              ),
            ),
          ],
        );
      });
}
