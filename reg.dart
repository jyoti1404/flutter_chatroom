import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MyReg extends StatefulWidget {
  @override
  MyRegState createState() => MyRegState();
}

File imgpath;
var imgurl;
var furl;

class MyRegState extends State<MyReg> {
  var authc = FirebaseAuth.instance;
  var fs = FirebaseFirestore.instance;
  String email;
  String pass;

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
        FirebaseStorage.instance.ref().child("myimages").child("my1.jpg");
    print(fbstorage);
    fbstorage.putFile(imgpath);
    imgurl = await fbstorage.getDownloadURL();
    print(imgurl);

    await fs.collection("imgurl").add({
      "profileurl": imgurl == null ? "waiting" : imgurl,
    });

    setState(() {
      furl = imgurl;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register User"),
      ),
      body: Container(
        width: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 80.0,
              backgroundImage: furl != null ? NetworkImage(furl) : null,
            ),
            RaisedButton(
              onPressed: clickPhoto,
              child: Text("Click"),
            ),
            TextField(
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) {
                email = value;
              },
              decoration: InputDecoration(
                  hintText: "Enter your email ",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  )),
            ),
            SizedBox(
              height: 40,
            ),
            TextField(
              obscureText: true,
              onChanged: (value) {
                pass = value;
              },
              decoration: InputDecoration(
                  hintText: "Enter your password ",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  )),
            ),
            SizedBox(
              height: 40,
            ),
            Material(
                color: Colors.lightBlueAccent,
                borderRadius: BorderRadius.circular(10),
                elevation: 10,
                child: MaterialButton(
                  minWidth: 200,
                  height: 40,
                  onPressed: () async {
                    try {
                      var user = await authc.createUserWithEmailAndPassword(
                          email: email, password: pass);
                      print(email);
                      print(pass);
                      print(user);

                      if (user.additionalUserInfo.isNewUser == true) {
                        Navigator.pushNamed(context, "chat");
                      }
                    } catch (e) {
                      print(e);
                    }
                  },
                  child: Text("Register"),
                )),
          ],
        ),
      ),
    );
  }
}
