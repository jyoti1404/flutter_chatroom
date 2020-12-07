import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MyImageCam extends StatefulWidget {
  @override
  _MyImageCamState createState() => _MyImageCamState();
}

File imgpath;
var imgurl;

class _MyImageCamState extends State<MyImageCam> {
  clickPhoto() async {
    var picker = ImagePicker();
    var imgclick = (await picker.getImage(
      source: ImageSource.camera,
      maxHeight: 400,
      maxWidth: 400,
    ));
    print(imgclick);
    // imgpath = imgclick.path ;
    print(imgpath);
    print("Photo Clicked");
    setState(() {
      imgpath = File(imgclick.path);
    });
    var fbstorage =
        FirebaseStorage.instance.ref().child("myimages").child("my.jpg");
    print(fbstorage);
    fbstorage.putFile(imgpath);
    setState(() async {
      imgurl = await fbstorage.getDownloadURL();
      print(imgurl);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_a_photo),
        onPressed: clickPhoto,
      ),
      appBar: AppBar(
        title: Text("Camera Image"),
        actions: [
          CircleAvatar(
            backgroundImage: imgurl == null
                ? NetworkImage(
                    "https://firebasestorage.googleapis.com/v0/b/flutter-chat-app-a6d52.appspot.com/o/myimages%2Fmy.jpg?alt=media&token=8f06c30e-d77a-4084-aae6-8b74a34d698b")
                : NetworkImage(imgurl),
          ),
        ],
      ),
      body: Container(
        width: 400,
        height: 400,
        color: (Colors.amberAccent),
        child:
            imgpath == null ? Text("Select your Image") : Image.file(imgpath),
      ),
    );
  }
}
