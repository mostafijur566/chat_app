import 'dart:convert';
import 'package:chat_app/utils/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:web_socket_channel/io.dart';
import 'models/dummy_chat.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late IOWebSocketChannel channel;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final GlobalKey textFieldKey = GlobalKey();

  List<ChatMessage> messages = [];

  @override
  void initState() {
    super.initState();
    channel = IOWebSocketChannel.connect('ws://10.0.2.2:8000/ws/chat/12/');

    channel.stream.listen((message) {
      Map<String, dynamic> messageData = jsonDecode(message);
      setState(() {
        messages.add(
          ChatMessage(
            messageContent: messageData['message'],
            messageType: messageData['sender'] == 'user1' ? "sender" : "receiver",
          ),
        );
        _scrollToBottom();
      });
    });
  }

  void _scrollToBottom() {
    Future.delayed(Duration(milliseconds: 300)).then((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: (textFieldKey.currentContext?.findRenderObject() as RenderBox?)?.size.height ?? 50),
              child: ListView.builder(
                controller: _scrollController,
                itemCount: messages.length,
                padding: EdgeInsets.only(top: 10,bottom: 10),
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index){
                  return Container(
                    padding: EdgeInsets.only(left: messages[index].messageType == "receiver" ? 14 : 90.w,right: messages[index].messageType == "receiver" ? 90.w : 14, top: 10,bottom: 10),
                    child: Align(
                      alignment: (messages[index].messageType == "receiver"?Alignment.topLeft:Alignment.topRight),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: (messages[index].messageType  == "receiver"?Colors.white:Colors.blue[200]),
                        ),
                        padding: EdgeInsets.all(16),
                        child: Text(messages[index].messageContent, style: TextStyle(fontSize: 15),),
                      ),
                    ),
                  );
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                key: textFieldKey,
                width: double.infinity,
                color: Colors.white,
                padding: EdgeInsets.only(top: 5, bottom: 5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: (){},
                      icon: Icon(Icons.add_circle_sharp, color: AppColors.mainColor),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        minLines: 1,
                        maxLines: 6,
                        style: GoogleFonts.poppins(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textColor
                        ),
                        decoration: InputDecoration(
                            hintText: 'Message',
                            hintStyle: GoogleFonts.poppins(fontSize: 13.sp),
                            border: InputBorder.none
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: _sendMessage,
                      icon: Icon(CupertinoIcons.paperplane_fill, color: AppColors.mainColor),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      channel.sink.add(
        json.encode({
          'message': _messageController.text,
          'sender': 'user1',
          'receiver': 'user2',
        }),
      );
      _messageController.clear();
      _scrollToBottom();
    }
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }
}
