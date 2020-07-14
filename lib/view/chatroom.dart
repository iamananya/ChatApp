import 'package:firebase/helper/authenticate.dart';
import 'package:firebase/helper/constants.dart';
import 'package:firebase/helper/helperfunction.dart';
import 'package:firebase/services/auth.dart';
import 'package:firebase/services/database.dart';
import 'package:firebase/view/chatscreen.dart';
import 'package:firebase/view/search.dart';
import 'package:firebase/view/signin.dart';
import 'package:firebase/widgets/widget.dart';
import 'package:flutter/material.dart';
class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {

  AuthMethod authMethod =new AuthMethod();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  Stream chatRoomsStream ;

  Widget  chatRoomList(){
    return StreamBuilder(
      stream: chatRoomsStream,
      builder: (context,snapshot){
        return snapshot.hasData ?ListView.builder(
            itemCount:snapshot.data.documents.length ,
            itemBuilder: (context,index){
            return ChatRoomTile(
              snapshot.data.documents[index].data["chatRoomId"]
                  .toString().replaceAll("_", "")
                  .replaceAll(Constants.myName, ""),
                snapshot.data.documents[index].data["chatRoomId"]
            );
            }) : Container();
      },
    );
  }
  @override
  void initState() {
    getUserInfo();

    super.initState();
  }
  getUserInfo()async{
    Constants.myName =await HelperFunctions.getUserNameSharedPreference();
    databaseMethods.getChatRooms(Constants.myName).then((value){
        setState(() {
          chatRoomsStream=value;
        });
      });
      setState(() {

      });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: Text("Chat room"),
        backgroundColor: Colors.red,
        actions: [
          GestureDetector(
            onTap: (){
              authMethod.signOut();
              Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) => Authenticate()
              ));
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal:16 ),
              child: Icon(Icons.exit_to_app),
            ),
          )

            ],
        ),
      body: chatRoomList(),
      floatingActionButton:FloatingActionButton(
        backgroundColor: Colors.red,
        child: Icon(Icons.search,),
        onPressed: (){
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => SearchScreen()
        ));
        },
      ) ,

      );


  }
}

class ChatRoomTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;
  ChatRoomTile(this.userName ,this.chatRoomId);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => ConversationScreen(chatRoomId)
        ));
      },
      child: Container(
        color: Colors.black26,
        padding:EdgeInsets.symmetric(horizontal: 24,vertical:16 ),
        child: Row(
          children: <Widget>[


            Container(
              height: 40,
                width: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Text("${userName.substring(0,1).toUpperCase()}",
                  style: mediumTextFieldStyle(),)

            ),
            SizedBox(width: 8,),
            Text(userName ,
                style: mediumTextFieldStyle(),)
          ],
        ),
      ),
    );
  }
}
