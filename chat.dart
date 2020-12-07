import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socialchat/reg.dart';

class MyChat extends StatefulWidget {
  @override
  _MyChatState createState() => _MyChatState();
}

class _MyChatState extends State<MyChat> {
  var authc = FirebaseAuth.instance;
  String chatmsg;
  var msgTextController = TextEditingController();

  var fs = FirebaseFirestore.instance;

  // var mrs = MyRegState();
  // mrs

  // getmsglive() async {
  //   await for (var i in fs.collection("chat").snapshots()) {
  //     for (var j in i.docs) {
  //       print(j.data());
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    var deviceWidth = MediaQuery.of(context).size.width;
    // return Scaffold(
    //     appBar: AppBar(
    //       title: Text("Chat"),
    //       actions: [
    //         IconButton(
    //             icon: Icon(Icons.close),
    //             onPressed: () async {
    //               try {
    //                 print("Log Off");
    //                 await authc.signOut();
    //                 Navigator.pushNamed(context, "home");
    //               } catch (e) {
    //                 print(e);
    //               }
    //             })
    //       ],
    //     ),
    //     body: Column(
    //       children: [
    //         TextField(
    //           onChanged: (value) {
    //             msg = value;
    //           },
    //         ),
    //         FlatButton(
    //             onPressed: () async {
    //               await fs.collection('chat').add({
    //                 "text": msg,
    //                 "sender": authc.currentUser.email,
    //               });
    //             },
    //             child: Text("Send Msg")),
    //         FlatButton(
    //             onPressed: () {
    //               getmsglive();
    //             },
    //             child: Text("Get Streaming Data")),
    //         FlatButton(
    //             onPressed: () async {
    //               var msgdoc = await fs.collection('chat').get();
    //               // print(msgdoc.docs[0].data());
    //               for (var i in msgdoc.docs) {
    //                 print(i.data());
    //               }
    //               print(msg);
    //             },
    //             child: Text("Get Msg")),
    //         RaisedButton(
    //           onPressed: () {
    //             var user = authc.currentUser;
    //             print(user.email);
    //           },
    //           child: Text("Click to know who you are"),
    //         ),
    //       ],
    //     ));
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat"),
        actions: [
          CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(
                "https://firebasestorage.googleapis.com/v0/b/flutter-chat-app-a6d52.appspot.com/o/myimages%2Fmy1.jpg?alt=media&token=105e0029-5336-4024-ad1b-7797550fac29"),
          )
        ],
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            StreamBuilder<QuerySnapshot>(
              builder: (context, snapshots) {
                print("new data comes");
                var msg = snapshots.data.docs;
                // print(msg);
                // print(msg[0].data());
                List<Widget> y = [];
                for (var i in msg) {
                  // print(i.data());
                  // print(i.data()['text']);
                  // y.add(i.data());
                  var msgText = i.data()['text'];
                  var msgSender = i.data()['sender'];
                  // var msgWidget = Text("This $msgText comes from $msgSender");
                  var msgWidget = Text("$msgText : $msgSender");
                  y.add(msgWidget);
                }
                print(y);
                return Container(
                    child: Column(
                  children: [
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: y.length,
                        itemBuilder: (context, index) {
                          var item = y[index];
                          return ListTile(
                            dense: false,
                            title: Container(
                              alignment: Alignment.centerRight,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                              ),
                              child: Card(
                                color: Colors.lightBlue.shade100,
                                child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Text(
                                    "$item",
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        })
                  ],
                ));
              },
              stream: fs.collection("chat").snapshots(),
            ),
            Row(
              children: [
                Container(
                  width: deviceWidth * 0.70,
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(10),
                  child: TextField(
                      controller: msgTextController,
                      decoration: InputDecoration(
                        hintText: ("Enter your message...."),
                      ),
                      onChanged: (value) {
                        chatmsg = value;
                      }),
                ),
                Container(
                  width: deviceWidth * 0.20,
                  child: FlatButton(
                    onPressed: () async {
                      msgTextController.clear();
                      await fs.collection("chat").add({
                        "text": chatmsg,
                        "sender": authc.currentUser.email,
                      });
                    },
                    child: Text(
                      "SEND",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                )
              ],
            ),
            RaisedButton(
                child: Text("Go to Next Page"),
                onPressed: () {
                  Navigator.pushNamed(context, "imagecam");
                })
          ],
        ),
      ),
    );
  }
}
