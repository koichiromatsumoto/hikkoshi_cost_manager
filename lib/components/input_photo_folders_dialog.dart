import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hikkoshi_cost_manager/model/repository/photo_folders_repository.dart';

Future<void> inputPhotoFoldersDialog(BuildContext context) async {
  final _formKey = GlobalKey<FormState>();
  return showDialog(
      context: context,
      builder: (context) {
        var folderName = null;
        final TextEditingController _folderNameController =
            new TextEditingController(text: folderName);

        return AlertDialog(
          title: Text("フォルダを追加"),
          content: Form(
            key: _formKey,
            child: TextFormField(
              controller: _folderNameController,
              decoration: InputDecoration(
                labelText: "フォルダ名",
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 15,
                ),
                suffixIcon: IconButton(
                  onPressed: () => _folderNameController.clear(),
                  icon: Icon(Icons.clear),
                ),
              ),
              keyboardType: TextInputType.text,
              inputFormatters: [
                LengthLimitingTextInputFormatter(12),
              ],
              onChanged: (value) {
                folderName = value;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'フォルダ名を入力してください';
                }
                return null;
              },
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
                  PhotoFolderRepository.create(
                    name: folderName,
                  );
                  Navigator.pop(context);
                }
              },
              style: TextButton.styleFrom(
                primary: Colors.white,
              ),
            )
          ],
        );
      });
}
