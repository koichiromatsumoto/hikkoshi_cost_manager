import 'package:flutter/material.dart';

Future photoSelectDialog(context) async {
  showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        final deviceWidth = MediaQuery.of(context).size.width;
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Container(
            width: deviceWidth * 0.7,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blueAccent, width: 3),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox(
                  height: 24.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: deviceWidth * 0.55,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shadowColor: Colors.grey,
                          elevation: 5,
                          primary: Colors.blueAccent,
                          onPrimary: Colors.white,
                          shape: const StadiumBorder(),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Padding(
                          padding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 36),
                          child: Text('カメラを起動する'),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 24.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: deviceWidth * 0.55,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shadowColor: Colors.grey,
                          elevation: 5,
                          primary: Colors.blueAccent,
                          onPrimary: Colors.white,
                          shape: const StadiumBorder(),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Padding(
                          padding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 36),
                          child: Text('写真を選択する'),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 24.0,
                ),
              ],
            ),
          ),
        );
      });
}