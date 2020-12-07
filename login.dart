import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class MyLogin extends StatefulWidget {
  @override
  _MyLoginState createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {
  var authc = FirebaseAuth.instance;
  String email;
  String pass;
  bool sspin = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Log In To my Page"),
      ),
      body: ModalProgressHUD(
        inAsyncCall: sspin,
        child: Center(
          child: Container(
            width: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                        setState(() {
                          sspin = true;
                        });
                        // sspin = true;
                        try {
                          var usersigin =
                              await authc.signInWithEmailAndPassword(
                                  email: email, password: pass);
                          print(usersigin);
                          if (usersigin != null) {
                            Navigator.pushNamed(context, "chat");
                            setState(() {
                              sspin = false;
                            });
                          }
                        } catch (e) {
                          print(e);
                        }
                      },
                      child: Text("Log In"),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
