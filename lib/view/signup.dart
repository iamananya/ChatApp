import 'package:firebase/helper/helperfunction.dart';
import 'package:firebase/services/auth.dart';
import 'package:firebase/services/database.dart';
import 'package:firebase/view/chatroom.dart';
import 'package:firebase/widgets/widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class SignUp extends StatefulWidget {

  final Function toggle;
  SignUp(this.toggle);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  bool isLoading =false;

  AuthMethod authMethods=new AuthMethod();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  HelperFunctions helperFunctions = new HelperFunctions();
  final formKey = GlobalKey<FormState>();
  TextEditingController userNameTextEditingController = new TextEditingController();
  TextEditingController emailTextEditingController = new TextEditingController();
  TextEditingController passwordTextEditingController = new TextEditingController();

  signMeUp(){
    
    if(formKey.currentState.validate()){
      Map<String,String>userInfoMap ={
        "name": userNameTextEditingController.text,
        "email":emailTextEditingController.text,
      };



      setState(() {
        isLoading=true;
      });
      authMethods.signInWithEmailAndPassword(emailTextEditingController.text,
          passwordTextEditingController.text).then((val){
        //print("${val.uid}");

        databaseMethods.uploadUserInfo(userInfoMap);
        HelperFunctions.saveUserLoggedInSharedPreference(true);
        HelperFunctions.saveUserEmailSharedPreference(emailTextEditingController.text);
        HelperFunctions.saveUserNameSharedPreference(userNameTextEditingController.text);

        Navigator.pushReplacement(context,MaterialPageRoute(
          builder: (context) => ChatRoom()
        ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
        body:isLoading ?Container(
          child:Center(child: CircularProgressIndicator()) ,
        ) :SingleChildScrollView(
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
                           return val.isEmpty || val.length <4 ? "Please provide valid username " :null;
                         },
                         controller: userNameTextEditingController,
                         style: simpleTextFieldStyle(),
                         decoration: textFieldInputDecoration("Username"),),

                       TextFormField(
                         validator: (val){
                           return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val) ?
                           null : "Please provide valid  email";
                         },
                         controller: emailTextEditingController,
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
                    signMeUp();
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
                      child:Text("Sign Up",style: mediumTextFieldStyle(),) ,
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
                    child:Text("Sign Up With Google",style: TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                    ),) ,
                  ),
                  SizedBox(height:16 ,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Already have an account? ",style: mediumTextFieldStyle(),),
                      GestureDetector(
                        onTap: (){
                          widget.toggle();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text(" Sign In ",style: TextStyle(
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
        )

    );
  }
}
