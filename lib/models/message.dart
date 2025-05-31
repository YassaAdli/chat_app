import 'package:chat_app/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Message{
  final Timestamp createdAt;
  final String message,receiver,sender, senderEmail;
  Message( this.message,this.receiver, this.sender, this.createdAt, this.senderEmail);
  factory Message.fromJson(json) {
    return Message(
      json[KMessage],
      json[KReceiver],
      json[KSender],
      json[KCreatedAt]??Timestamp.now(),
      json[KSenderEmail],

    );
  }

}