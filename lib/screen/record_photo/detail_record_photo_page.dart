import 'package:flutter/material.dart';
import 'package:hikkoshi_cost_manager/components/photo_select_dialog.dart';
import 'package:hikkoshi_cost_manager/model/entity/photo_folders.dart';
import 'package:hikkoshi_cost_manager/model/entity/photos.dart';
import 'package:hikkoshi_cost_manager/model/repository/photos_repository.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class DetailRecordPhotoPage extends StatefulWidget {
  final PhotoFolder photoFolder;

  DetailRecordPhotoPage(this.photoFolder);

  @override
  _DetailRecordPhotoPageState createState() =>
      new _DetailRecordPhotoPageState();
}

class _DetailRecordPhotoPageState extends State<DetailRecordPhotoPage> {
  bool isEnabled = false;
  File? image;

  @override
  Widget build(BuildContext context) {
    var futureBuilder = FutureBuilder(
      future: PhotoRepository.getFoldersAll(widget.photoFolder.id),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return photoListView(context, Photo.mainCache, false);
          default:
            if (snapshot.hasError)
              return Text('Error: ${snapshot.error}');
            else
              Photo.mainCache = snapshot.data;
            return photoListView(context, Photo.mainCache, true);
        }
      },
    );

    final picker = ImagePicker();
    Future getImage() async {
      final pickedFile = await picker.getImage(source: ImageSource.camera);

      setState(() {
        if (pickedFile != null) {
          image = File(pickedFile.path);
          print(basename(pickedFile.path));
        }
      });
    }


    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.photoFolder.name}"),
        centerTitle: true,
      ),
      body: futureBuilder,
      floatingActionButton: Container(
        margin: EdgeInsets.only(bottom: 50.0),
        child: FloatingActionButton(
          child: Icon(Icons.add_a_photo),
          onPressed:() {
            photoSelectDialog(context);
          }
        ),
      ),
    );
  }

  Widget photoListView(
      BuildContext context, List<Photo> photos, bool isEnabled) {
    final deviceWidth = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 80),
        child: Column(children: <Widget>[
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return Card(
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Ink.image(
                          image: NetworkImage(
                            'https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1327&q=80',
                          ),
                          height: 240,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          bottom: 16,
                          right: 16,
                          left: 16,
                          child: Text(
                            'Cats rule the world!',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.all(16).copyWith(bottom: 0),
                      child: Text(
                        'The cat is the only domesticated species in the family Felidae and is often referred to as the domestic cat to distinguish it from the wild members of the family.',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    ButtonBar(
                      alignment: MainAxisAlignment.start,
                      children: [
                        FlatButton(
                          child: Text('Buy Cat'),
                          onPressed: () {},
                        ),
                        FlatButton(
                          child: Text('Buy Cat Food'),
                          onPressed: () {},
                        )
                      ],
                    ),
                  ],
                ),
              );
            },
            itemCount: photos.length,
          )
        ]));
  }
}