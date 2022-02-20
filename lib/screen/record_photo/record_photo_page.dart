import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hikkoshi_cost_manager/components/input_photo_folders_dialog.dart';
import 'package:hikkoshi_cost_manager/components/list_border.dart';
import 'package:hikkoshi_cost_manager/components/photo_folder_delete_confirm_dialog.dart';
import 'package:hikkoshi_cost_manager/model/entity/photo_folders.dart';
import 'package:hikkoshi_cost_manager/model/repository/photo_folders_repository.dart';
import 'package:hikkoshi_cost_manager/model/repository/photos_repository.dart';
import 'package:hooks_riverpod/all.dart';

import 'detail_record_photo_page.dart';

class RecordPhotoPage extends StatefulWidget {

  @override
  _RecordPhotoPageState createState() => new _RecordPhotoPageState();
}

class _RecordPhotoPageState extends State<RecordPhotoPage> {
  @override
  Widget build(BuildContext context) {
    var futureBuilder = FutureBuilder(
      future: PhotoFolderRepository.getAll(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return mainFoldersView(context, PhotoFolder.mainCache, false);
          default:
            if (snapshot.hasError)
              return Text('Error: ${snapshot.error}');
            else
              PhotoFolder.mainCache = snapshot.data;
            return mainFoldersView(context, PhotoFolder.mainCache, true);
        }
      },
    );

    return Scaffold(
        appBar: AppBar(
          title: Text("入居時の状態を記録"),
          centerTitle: true,
        ),
        body: futureBuilder
    );
  }

  Widget mainFoldersView(BuildContext context, List<PhotoFolder> photoFolders, bool isEnabled) {
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
                      "お部屋の入居時の状態を\n写真で記録しましょう",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    child: const Text('フォルダを追加'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blueAccent,
                      onPrimary: Colors.white,
                      elevation: 5,
                      shadowColor: Colors.deepOrangeAccent,
                    ),
                    onPressed: () {
                      if (isEnabled == true) {
                        inputPhotoFoldersDialog(context);
                      }
                    },
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  SingleChildScrollView(
                    child: Container(
                      color: Color.fromRGBO(220, 220, 220, 1.0),
                      child: Column(children: <Widget>[
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            final photosCountAlign = FutureBuilder(
                                future: PhotoRepository.getFoldersCount(photoFolders[index].id),
                                builder: (BuildContext context, AsyncSnapshot snapshot) {
                                  switch (snapshot.connectionState) {
                                    case ConnectionState.none:
                                    case ConnectionState.waiting:
                                      return Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(PhotoFolder.countCache.toString(),
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.black87)),
                                      );
                                    default:
                                      if (snapshot.hasError)
                                        return Text('Error: ${snapshot.error}');
                                      else
                                        PhotoFolder.countCache = snapshot.data;
                                      return Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(PhotoFolder.countCache.toString(),
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.black87)),
                                      );
                                  }
                                },
                            );
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
                                            photoFolderDeleteConfirmDialog(
                                                context, photoFolders[index], PhotoFolder.countCache.toString());
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
                                                  child: Text(photoFolders[index].getName,
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.black87)),
                                                ),
                                                photosCountAlign,
                                                Icon(
                                                    Icons.arrow_forward_ios
                                                ),
                                              ],
                                            ),
                                          ),
                                          onPressed: () => Navigator.of(context).push(
                                            MaterialPageRoute<PageRoute<Widget>>(
                                                builder: (_) => returnPage(photoFolders[index])
                                            ),
                                          ),
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
                          itemCount: photoFolders.length,
                        ),
                      ]),
                    ),
                  ),
                ],
              );
            }
        )
    );
  }

  Widget returnPage(PhotoFolder photoFolder) {
    return DetailRecordPhotoPage(photoFolder);
  }
}