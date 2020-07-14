import 'package:firebase/helper/constants.dart';
import 'package:firebase/services/database.dart';
import 'package:firebase/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ConversationScreen extends StatefulWidget {
 final String chatRoomId;
 ConversationScreen(this.chatRoomId);
  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {


DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController messageController = new TextEditingController();
    Stream chatMessageStream;

  Widget ChatMessageList(){
  return StreamBuilder(
    stream:chatMessageStream ,
    builder: (context,snapshot){
      return snapshot.hasData ? ListView.builder(
        itemCount: snapshot.data.documents.length,
          itemBuilder: (context,index){
          return MessageTile(snapshot.data.documents[index].data["message"],
              snapshot.data.documents[index].data["sendBy"] ==Constants.myName);
          }):Container() ;
    },
  );
  }
  sendMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "message": messageController.text,
        "sendBy": Constants.myName,
        "time":DateTime.now().millisecondsSinceEpoch,
      };
      databaseMethods.addConversationMessages(widget.chatRoomId,messageMap);
      messageController.text ="";
    }
  }
@override
  void initState() {
    databaseMethods.getConversationMessages(widget.chatRoomId).then((value){
      setState(() {
        chatMessageStream =value;
      });
      });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
        child: Stack(
          children: <Widget>[
          ChatMessageList(),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Colors.white10,
                padding: EdgeInsets.symmetric(vertical:16,horizontal: 24 ),

                child: Row(
                  children: <Widget>[
                    Expanded(child: TextField(
                      controller:messageController ,
                      style: TextStyle(
                          color: Colors.white
                      ),
                      decoration: InputDecoration(
                        hintText: "Message...",
                        hintStyle: TextStyle(
                          color: Colors.white54,
                        ),
                        border: InputBorder.none,

                      ),
                    )),
                    GestureDetector(
                      onTap: (){
                      sendMessage();
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
                        child: Icon(Icons.chevron_right,
                          color: Colors.white,),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

    );
  }
}
class MessageTile extends StatelessWidget {
  final String message;
  final bool isSendByMe;
  MessageTile( this.message,this.isSendByMe);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top:8,bottom: 8,
          left: isSendByMe ? 0: 24,
          right: isSendByMe ? 24:0),
      width: MediaQuery.of(context).size.width,
      alignment: isSendByMe ? Alignment.centerRight :Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        padding: EdgeInsets.symmetric(horizontal: 24,vertical: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: isSendByMe ?  [
                const Color(0xffFF0000),
                const Color(0xffB03131),
              ] : [
                const Color(0x1AFFFFFF),
                const Color(0x1AFFFFFF),
              ]
          ),
          borderRadius: isSendByMe ?
              BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
                bottomLeft: Radius.circular(23),
              ) :
          BorderRadius.only(
            topLeft: Radius.circular(23),
            topRight: Radius.circular(23),
            bottomRight: Radius.circular(23),
          )
        ),
        child: Text(message,
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
          ),),
      ),
    );
  }
}
