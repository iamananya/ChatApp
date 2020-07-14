import 'package:firebase/helper/authenticate.dart';
import 'package:firebase/helper/helperfunction.dart';
import 'package:firebase/view/chatroom.dart';
import 'package:firebase/view/signin.dart';
import 'package:firebase/view/signup.dart';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool userIsLoggedIn=false;
  @override
  void initState() {
    getLoggedInState();
    super.initState();
  }
getLoggedInState()async{
    await HelperFunctions.getUserLoggedInSharedPreference().then((value) {
    setState(() {
      userIsLoggedIn=value;
    });
    });
}
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Color(0xffCC1D1D),
        scaffoldBackgroundColor: Color(0xff1F1F1F),

        primarySwatch: Colors.blue,

        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home:userIsLoggedIn != null ? userIsLoggedIn ? ChatRoom(): Authenticate()
          :Container(
        child: Center(
          child: Authenticate(),
        ),
      ),
    );
  }
}
