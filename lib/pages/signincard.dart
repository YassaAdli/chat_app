import 'package:chat_app/pages/chatpage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../helper/show_snak_bar.dart';
import '../widget/custombutton.dart';
import '../widget/customtextfield.dart';

class Signincard extends StatefulWidget {
  final VoidCallback onSignupTap;

  const Signincard({super.key, required this.onSignupTap});

  @override
  State<Signincard> createState() => _SignincardState();
}

class _SignincardState extends State<Signincard> {
  bool _obscureText = true;
  GlobalKey<FormState> formKey = GlobalKey();
  bool isLoading = false;
  String? email, password;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Form(
          key: formKey,
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  const SizedBox(height: 80),
                  const Text(
                    'Welcome Back',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Enter your details below',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 40),

                  const Text(
                    'Email Address',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  CustomTextField(
                    obscureText: false,
                    onChanged: (value) {
                      email = value;
                    },
                    validator: emailValidator,
                  ),
                  const SizedBox(height: 24),

                  const Text(
                    'Password',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  CustomTextField(
                    onChanged: (value) {
                      password = value;
                    },
                    validator: passwordValidator,
                    obscureText: _obscureText,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed:
                          () => setState(() => _obscureText = !_obscureText),
                    ),
                  ),
                  const SizedBox(height: 16),
                  CustomButton(
                    text: 'Sign in',
                    onTap: () async {
                      if (formKey.currentState!.validate()) {
                        setState(() => isLoading = true);
                        try {
                          await loginUser();
                          showSnackBar(context, 'Successfully logged in');
                          await Future.delayed(const Duration(seconds: 1));
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'user-not-found'||e.code == 'invalid-credential') {
                            showSnackBar(
                              duration: 1,
                              context,
                              'No user found for that email.',
                            );
                            await Future.delayed(const Duration(seconds: 1));

                            widget.onSignupTap();
                            showSnackBar(
                              context,
                              'Register a new account',
                            );
                          } else if (e.code == 'wrong-password') {
                            showSnackBar(
                              context,
                              'Wrong password provided for that user.',
                            );
                          } else {
                            print('error occurred: $e');
                            showSnackBar(context, e.message ?? 'Authentication error');
                          }
                        } catch (e) {
                          print('error occurred: $e');
                          showSnackBar(context, e.toString());
                        }
                        setState(() => isLoading = false);
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Don\'t have an account?',
                          style: TextStyle(color: KPrimaryColor),
                        ),
                        TextButton(
                          onPressed: widget.onSignupTap,
                          child: const Text(
                            'Sign up',
                            style: TextStyle(color: KPrimaryColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (isLoading)
          Positioned.fill(
            child: Container(
              color: Colors.black.withValues(alpha: 0.5),
              child: const Center(
                child: CircularProgressIndicator(
                  color: KPrimaryColor,
                  strokeWidth: 5,
                  backgroundColor: Colors.white30,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Future<void> loginUser() async {
   UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email!, password: password!);
   // await FirebaseFirestore.instance.collection(KUserCollection).doc(userCredential.user!.uid).set({
   //   'uid': userCredential.user!.uid,
   //   'email': email,
   // }).then((value) => print("User Added"))
   //     .catchError((error) => print("Failed to add user: $error"));
  }

  String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email cannot be empty';
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password cannot be empty';
    } else if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }
}
