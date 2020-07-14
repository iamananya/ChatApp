import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/services/auth.dart';
import 'package:firebase/services/database.dart';


import 'package:firebase/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:firebase/helper/helperfunction.dart';

import 'package:firebase/view/chatroom.dart';

class SignIn extends StatefulWidget {
final Function toggle;
SignIn(this.toggle);


  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final formKey = GlobalKey<FormState>();
  AuthMethod authMethod = new AuthMethod();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController emailTextEditingController = new TextEditingController();
  TextEditingController passwordTextEditingController = new TextEditingController();
  bool isLoading = false;


  signIn() async{
  if(formKey.currentState.validate()){
    setState(() {
      isLoading = true;
    });
    await  authMethod
        .signInWithEmailAndPassword(emailTextEditingController.text,
        passwordTextEditingController.text)
        .then((val) async{
      if(val != null){
      QuerySnapshot snapshotUserInfo=

     await DatabaseMethods().getUsersByUserEmail(emailTextEditingController.text);


        HelperFunctions.saveUserLoggedInSharedPreference(true);
      HelperFunctions
          .saveUserNameSharedPreference(snapshotUserInfo.documents[0].data["name"]);
      print("${snapshotUserInfo.documents[0].data["name"]}");
      HelperFunctions
          .saveUserEmailSharedPreference(snapshotUserInfo.documents[0].data["email"]);

      Navigator.pushReplacement(context,MaterialPageRoute(
            builder: (context) => ChatRoom()
        ));
      }
      else{
        setState(() {
          isLoading =false;
        });
      }
    });

  }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),

      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - 50,
          alignment: Alignment.bottomCenter,
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Container(

            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Form(
                  key: formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        validator: (val){
                          return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val) ?
                          null : "Please provide valid  email";
                        },
                        controller:emailTextEditingController ,
                        style: simpleTextFieldStyle(),
                        decoration: textFieldInputDecoration("email"),),

                      TextFormField(
                        obscureText: true,
                        validator:  (val){
                          return val.length>6 ? null : "Please provide password 6+ characters";
                        },
                        controller: passwordTextEditingController,
                        style: simpleTextFieldStyle(),
                        decoration: textFieldInputDecoration("password"),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8,),
                Container(
                  alignment: Alignment.centerRight,
                  child:Container(
                    padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                    child: Text("Forget Password",
                      style: simpleTextFieldStyle(),),
                  ) ,
                ),
                SizedBox(height: 8,),
                GestureDetector(
                  onTap: (){
                    signIn();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors:[
                          const Color(0xffFF0000),
                          const Color(0xffB03131),
                        ]
                      ),
                      borderRadius:BorderRadius.circular(30),
                    ),
                    child:Text("Sign In",style: mediumTextFieldStyle(),) ,
                  ),
                ),
                SizedBox(height:16 ,),
                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:BorderRadius.circular(30),
                  ),
                  child:Text("Sign In With Google",style: TextStyle(
                    color: Colors.black,
                    fontSize: 17,
                  ),) ,
                ),
                SizedBox(height:16 ,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Don't have an account? ",style: mediumTextFieldStyle(),),
                    GestureDetector(
                      onTap: (){
                        widget.toggle();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text(" Register Now",style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          decoration: TextDecoration.underline,
                        ),),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 50,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
