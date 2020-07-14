import 'package:flutter/material.dart';


Widget appBarMain(BuildContext context){
  return AppBar(

    backgroundColor: Colors.red[500],
    title:Text("Euonia",
    ),



  );
}
InputDecoration textFieldInputDecoration(String hintText)
{
  return InputDecoration(
      hintText:hintText ,
      hintStyle: TextStyle(
        color: Colors.white54,
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
      ),
      enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
              color: Colors.white
          )
      )
  );
}
TextStyle simpleTextFieldStyle(){
  return TextStyle(
    color: Colors.white,
    fontSize: 16,
  );
}
TextStyle mediumTextFieldStyle(){
  return TextStyle(
    color: Colors.white,
    fontSize: 17,
  );
}

