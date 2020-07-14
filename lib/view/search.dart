import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/helper/constants.dart';
import 'package:firebase/helper/helperfunction.dart';
import 'package:firebase/services/database.dart';
import 'package:firebase/view/chatscreen.dart';
import 'package:firebase/widgets/widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  DatabaseMethods databaseMethods =new DatabaseMethods();
  TextEditingController searchTextEditingController = new TextEditingController();
  QuerySnapshot searchSnapShot;

  initiateSearch(){
    databaseMethods.getUsersByUsername(searchTextEditingController.text)
        .then(
            (val){
          setState(() {
            searchSnapShot=val;
          });
        }
    );
  }




  Widget searchList(){
    return searchSnapShot !=null ? ListView.builder(
        itemCount:searchSnapShot.documents.length ,
        shrinkWrap: true,
        itemBuilder: (context,index){
        return SearchTile(
          userName: searchSnapShot.documents[index].data["name"],
          userEmail: searchSnapShot.documents[index].data["email"],
        );
        }) : Container();
  }
  createChatroomAndStartConversation({String userName}){
    print("${Constants.myName}");
   if(userName != Constants.myName){
     String chatRoomId=getChatRoomId(userName,Constants.myName);
     List<String> users=[userName,Constants.myName];
     Map<String,dynamic> chatRoomMap = {
       "users" :users,
       "chatRoomId" :chatRoomId,
     };
     DatabaseMethods().createChatRoom(chatRoomId,chatRoomMap);
     Navigator.push(context,MaterialPageRoute(
         builder:(context) => ConversationScreen(
           chatRoomId
         )

     ));
   }else{
     print("you cannot send message to yourself");
   }

  }
  Widget SearchTile({String userName,
  String userEmail}){
    return Container(
      padding: EdgeInsets.symmetric(horizontal:24, vertical: 16 ),


      color:Colors.red[400],



      child: Row(
        children: <Widget>[
          Column(
            crossAxisAlignment:CrossAxisAlignment.start ,
            children: <Widget>[
              Text(userName,style: mediumTextFieldStyle(),),
              Text(userEmail,style: mediumTextFieldStyle(),),
            ],
          ),
          Spacer(),

          GestureDetector(
            onTap: (){
              createChatroomAndStartConversation(
                  userName : userName
                  );
            },
            child: Container(

              padding: EdgeInsets.all(12),
              child:Icon(Icons.message,
                color: Colors.white,),
            ),
          )
        ],
      ),
    );
  }

@override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
        child:Column(
          children: <Widget>[
           Container(
             color: Colors.white10,
             padding: EdgeInsets.symmetric(vertical:16,horizontal: 24 ),

             child: Row(
               children: <Widget>[
                 Expanded(child: TextField(
                   controller: searchTextEditingController,
                   style: TextStyle(
                     color: Colors.white
                   ),
                   decoration: InputDecoration(
                     hintText: "search username...",
                     hintStyle: TextStyle(
                       color: Colors.white54,
                     ),
                     border: InputBorder.none,

                   ),
                 )),
                 GestureDetector(
                   onTap: (){
                   initiateSearch();
                   },
                   child: Container(
                     decoration: BoxDecoration(
                       gradient: LinearGradient(
                         colors: [
                           const Color(0xffFF0000),
                           const Color(0xffB03131),
                         ]
                       ),
                       borderRadius: BorderRadius.circular(40)
                     ),
                     padding: EdgeInsets.all(12),
                     child: Icon(Icons.search,
                     color: Colors.white,),
                   ),
                 ),
               ],
             ),
           ),
            searchList()
          ],
        ) ,
      ),
    );
  }
}


getChatRoomId(String a,String b){
  if(a.substring(0,1).codeUnitAt(0) > b.substring(0,1).codeUnitAt(0)) {
    return "$b\_$a";
  }
  else{
    return "$a\_$b";
  }
}