import 'package:chat_app/pages/authscreen.dart';
import 'package:chat_app/pages/chatpage.dart';
import 'package:chat_app/services/auth/auth_gate.dart';
import 'package:chat_app/pages/homepage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        AuthScreen.id : (context)=> const AuthScreen(),
        Homepage.id : (context)=>  Homepage(),
        AuthGate.id : (context)=> const AuthGate(),
      },

      initialRoute: AuthGate.id,
    );
  }
}
