import 'package:chat_app/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../services/chat_helper.dart';
import '../widget/chat_buble.dart';
class ChatPage extends StatelessWidget {
  ChatPage({
    super.key,
    required this.rceverEmail,
    required this.rceverid,
    required this.rceverName,
    required this.rcevergender,
    required this.sendergender
  });

  final String rceverEmail;
  final String rceverid;
  final String rceverName;
  final String rcevergender;
  final String sendergender;

  final ScrollController _scrollController = ScrollController();
  final TextEditingController controller = TextEditingController();
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    var email = user!.email;
    var uid = user!.uid;

    ChatHelper.createChatRoom(uid, rceverid, email!, rceverEmail);

    Stream<QuerySnapshot> messages = ChatHelper.getMessagesStream(uid, rceverid);

    return StreamBuilder<QuerySnapshot>(
      stream: messages,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text(rceverName, style: TextStyle(color: Colors.black)),
              centerTitle: true,
              backgroundColor: Colors.white,
            ),
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Check for errors
        if (snapshot.hasError) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text(rceverName, style: TextStyle(color: Colors.black)),
              centerTitle: true,
              backgroundColor: Colors.white,
            ),
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text(rceverName, style: TextStyle(color: Colors.black)),
              centerTitle: true,
              backgroundColor: Colors.white,
            ),
            body: Center(child: Text('No messages yet')),
          );
        }

        List<Message> messagesList = [];
        for (int i = 0; i < snapshot.data!.docs.length; i++) {
          var doc = snapshot.data!.docs[i];
          messagesList.add(Message.fromJson(doc));
        }

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text(rceverName, style: TextStyle(color: Colors.black)),
            centerTitle: true,
            backgroundColor: Colors.white,
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    reverse: true,
                    controller: _scrollController,
                    itemCount: messagesList.length,
                    itemBuilder: (context, index) {
                      bool isCurrentUserMessage = messagesList[index].sender == uid;
                      return isCurrentUserMessage
                          ? ChatBuble(message: messagesList[index], senderimage: sendergender == 'Male' ? 'assets/images/man.png' : 'assets/images/woman.png')
                          : ChatBubleRecever(message: messagesList[index], receiverimage: rcevergender == 'Male' ? 'assets/images/man.png' : 'assets/images/woman.png');
                    },
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                  padding: EdgeInsets.all(8),
                  margin: EdgeInsets.all(8),
                  child: TextField(
                    controller: controller,
                    style: TextStyle(color: KPrimaryColor),
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: SecendryColor,
                      hintText: 'Message',
                      hintStyle: TextStyle(color: KPrimaryColor),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: SecendryColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: SecendryColor),
                      ),
                      suffixIcon: IconButton(
                        onPressed: () async {
                          final message = controller.text.trim();
                          if (message.isNotEmpty) {
                            // Use ChatHelper to send message
                            await ChatHelper.sendMessage(
                              currentUserId: uid,
                              currentUserEmail: email!,
                              receiverId: rceverid,
                              message: message,
                            );

                            controller.clear();
                            _scrollController.animateTo(
                              _scrollController.position.minScrollExtent,
                              duration: Duration(milliseconds: 500),
                              curve: Curves.fastOutSlowIn,
                            );
                          }
                        },
                        icon: Icon(Icons.send, color: KPrimaryColor),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}