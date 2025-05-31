import 'package:chat_app/pages/authscreen.dart';
import 'package:chat_app/pages/chatpage.dart';
import 'package:chat_app/pages/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});
  static String id = 'AuthGate';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(stream: FirebaseAuth.instance.authStateChanges(), builder: (context,snapshot){
        if (snapshot.hasData){
          return Homepage();
        }else{
          return const AuthScreen();
        }
      }),
    );
  }
}
