import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../constants.dart';
import '../helper/show_snak_bar.dart';
import '../widget/custombutton.dart';
import '../widget/customtextfield.dart';

class Signupcard extends StatefulWidget {
  final VoidCallback onSigninTap;
  const Signupcard({super.key, required this.onSigninTap});

  @override
  State<Signupcard> createState() => _SignupcardState();
}
enum Glender { Male, Female }
class _SignupcardState extends State<Signupcard> {
  Glender? _glendertype = Glender.Male;
  FirebaseFirestore firestore = FirebaseFirestore.instance;


  GlobalKey<FormState> formKey =GlobalKey();
  bool _obscureText = true;
  String? email, password, name, phone;

  bool isLoading = false;
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
                    'Sign Up',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
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
                    hintText: 'Example@example.com',
                    validator: emailValidator ,
                  ),
                  const SizedBox(height: 12),

                  const Text(
                    'Your Name',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  CustomTextField(obscureText: false,
                    validator: nameValidator ,
                    onChanged: (value){
                      name = value;
                    },
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Your Phone Number',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  CustomTextField(obscureText: false,
                    validator: phoneValidator ,
                    onChanged: (value){
                      phone = value;
                    },
                  ),
                  const SizedBox(height: 12),
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
                      onPressed: () => setState(() => _obscureText = !_obscureText),
                    ),
                  ),
                  const SizedBox(height: 12),

                  const SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.only(right: 24),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Gender : ',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        Row(
                          children: [
                            Radio<Glender>(
                              activeColor: KPrimaryColor,
                              value: Glender.Male,
                              groupValue: _glendertype,
                              onChanged: (Glender? value) {
                                setState(() {
                                  _glendertype = value;
                                });
                              },
                            ),
                            Text('Male',style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),),
                          ],
                        ),
                        Row(
                          children: [
                            Radio<Glender>(
                              activeColor: KPrimaryColor,
                              value: Glender.Female,
                              groupValue: _glendertype,
                              onChanged: (Glender? value) {
                                setState(() {
                                  _glendertype = value;
                                });
                              },
                            ),
                            Text('Female',style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),),
                          ],
                        ),
                        Spacer(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  CustomButton(
                    text: 'Sign Up',
                    onTap: () async {
                      if (formKey.currentState!.validate()) {
                        setState(() => isLoading = true);
                        try {
                          await registerUser();
                          showSnackBar(context,'Successfully created account');
                          await Future.delayed(const Duration(seconds: 1)); // optional delay
                          widget.onSigninTap();
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'weak-password') {
                            showSnackBar(context,'The password provided is too weak.');
                          } else if (e.code == 'email-already-in-use') {
                            showSnackBar(context,'The account already exists for that email.');
                            await Future.delayed(const Duration(seconds: 1)); // optional delay
                            widget.onSigninTap();
                          }
                        } catch (e) {
                          showSnackBar(context,e.toString());
                        }
                        setState(() => isLoading = false);

                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: TextButton(
                      onPressed: widget.onSigninTap,
                      child: const Text(
                        'Already have an account? Sign in',
                        style: TextStyle(color: KPrimaryColor),
                      ),
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
  Future<void> registerUser() async {
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: email!,
      password: password!,
    );
    String uid = userCredential.user!.uid;
    await FirebaseFirestore.instance.collection(KUserCollection).doc(uid).set({
      'uid': uid,
      'email': email,
      'name': name,
      'phone': phone,
      'gender': _glendertype == Glender.Male ? 'Male' : 'Female',
      'createdAt': FieldValue.serverTimestamp(),
    }).then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }
  String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email cannot be empty';
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }
  String? nameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name cannot be empty';
    } else if (!RegExp(r'^[A-Za-z]+(?:\s+[A-Za-z]+)+$').hasMatch(value)) {
      return 'Enter your full name';
    }
    return null;
  }
  String? phoneValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone cannot be empty';
    } else if (!RegExp(r'^01\d{9}$').hasMatch(value)) {
      return 'Enter a valid phone number ex(01xxxxxxxxx)';
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
