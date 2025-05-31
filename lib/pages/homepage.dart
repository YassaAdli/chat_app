import 'package:chat_app/constants.dart';
import 'package:chat_app/models/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'chatpage.dart';

class Homepage extends StatefulWidget {
  Homepage({super.key});
  static String id = 'HomePage';

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String searchQuery = '';
  String genderValue = 'Male';
  TextEditingController searchController = TextEditingController();
  Stream<QuerySnapshot> users =
      FirebaseFirestore.instance.collection('users').snapshots();

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final currentUserUid = currentUser?.uid;
    final currentUserEmail = currentUser?.email;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
              backgroundImage:
                  genderValue == 'Male'
                      ? AssetImage('assets/images/man.png')
                      : AssetImage('assets/images/woman.png'),

              backgroundColor: Colors.white,
            ),
            Text('Chats', style: TextStyle(color: Colors.black)),
            IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              icon: Icon(Icons.logout_outlined, color: Colors.black),
              iconSize: 30,
              color: Colors.black,
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: StreamBuilder(
        stream: users,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("error");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text('Loading');
          }
          if (snapshot.data!.docs.isEmpty) {
            return Text('No data');
          }
          for (int i = 0; i < snapshot.data!.docs.length; i++) {
            Users user = Users.fromJson(snapshot.data!.docs[i]);
            if (user.uid == currentUserUid || user.email == currentUserEmail) {
              if (genderValue != user.gender) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  setState(() {
                    genderValue = user.gender;
                  });
                });
              }
              break;
            }
          }
          List<Users> UsersList = [];
          List<Users> filteredUsersList = [];
          for (int i = 0; i < snapshot.data!.docs.length; i++) {
            Users user = Users.fromJson(snapshot.data!.docs[i]);
            if (user.uid != currentUserUid && user.email != currentUserEmail) {
              UsersList.add(user);
            } else {

              genderValue = user.gender;
            }
          }
          if (searchQuery.isEmpty) {
            filteredUsersList = UsersList;
          } else {
            filteredUsersList =
                UsersList.where((user) {
                  return user.fullName.toLowerCase().contains(
                        searchQuery.toLowerCase(),
                      ) ||
                      user.email.toLowerCase().contains(
                        searchQuery.toLowerCase(),
                      );
                }).toList();
          }
          if (filteredUsersList.isEmpty) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Column(
                children: [
                  TextField(
                    controller: searchController,
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Search users...',
                      hintStyle: TextStyle(color: KPrimaryColor),
                      filled: true,
                      fillColor: SecendryColor,
                      prefixIcon: Icon(Icons.search, color: KPrimaryColor),
                      suffixIcon:
                          searchQuery.isNotEmpty
                              ? IconButton(
                                icon: Icon(Icons.clear, color: KPrimaryColor),
                                onPressed: () {
                                  setState(() {
                                    searchController.clear();
                                    searchQuery = '';
                                  });
                                },
                              )
                              : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    style: TextStyle(color: Colors.black),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: Center(
                      child: Text(
                        searchQuery.isEmpty
                            ? 'No other users available to chat with'
                            : 'No users found matching "$searchQuery"',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Column(
              children: [
                // Custom Search TextField
                TextField(
                  controller: searchController,
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search users...',
                    hintStyle: TextStyle(color: KPrimaryColor),
                    filled: true,
                    fillColor: SecendryColor,
                    prefixIcon: Icon(Icons.search, color: KPrimaryColor),
                    suffixIcon:
                        searchQuery.isNotEmpty
                            ? IconButton(
                              icon: Icon(Icons.clear, color: KPrimaryColor),
                              onPressed: () {
                                setState(() {
                                  searchController.clear();
                                  searchQuery = '';
                                });
                              },
                            )
                            : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: KPrimaryColor, width: 1),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  style: TextStyle(color: Colors.black),
                ),
                SizedBox(height: 16),
                // Horizontal user list (stories-like)
                SizedBox(
                  height: 150,
                  child: ListView.builder(
                    itemCount: filteredUsersList.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) {
                      List<String> nameParts = filteredUsersList[index].fullName
                          .split(' ');
                      String firstName = nameParts[0];
                      bool isMale = filteredUsersList[index].gender =='Male';

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => ChatPage(
                                    rceverEmail: filteredUsersList[index].email,
                                    rceverid: filteredUsersList[index].uid,
                                    rceverName: filteredUsersList[index].fullName,
                                    rcevergender: filteredUsersList[index].gender,
                                    sendergender: genderValue,
                                  ),
                            ),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 8),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircleAvatar(
                                backgroundImage: isMale ? AssetImage(
                                  'assets/images/man.png',
                                ):AssetImage(
                                  'assets/images/woman.png',
                                ),
                                backgroundColor: Colors.white,
                                radius: 40,
                              ),
                              SizedBox(height: 8),
                              Text(
                                firstName,
                                style: TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 16),
                // Vertical user list
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredUsersList.length,
                    scrollDirection: Axis.vertical,

                    itemBuilder: (BuildContext context, int index) {
                      bool isMale = filteredUsersList[index].gender =='Male';

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => ChatPage(
                                    rceverEmail: filteredUsersList[index].email,
                                    rceverid: filteredUsersList[index].uid,
                                    rceverName: filteredUsersList[index].fullName,
                                    rcevergender: filteredUsersList[index].gender,
                                    sendergender: genderValue,
                                  ),
                            ),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundImage:isMale? AssetImage(
                                  'assets/images/man.png',
                                ):AssetImage(
                                  'assets/images/woman.png',
                                ),
                                backgroundColor: Colors.white,
                                radius: 45,
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    RichText(
                                      text: _buildHighlightedText(
                                        filteredUsersList[index].fullName,
                                        searchQuery,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    RichText(
                                      text: _buildHighlightedText(
                                        filteredUsersList[index].email,
                                        searchQuery,
                                        isEmail: true,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  TextSpan _buildHighlightedText(
    String text,
    String query, {
    bool isEmail = false,
  }) {
    if (query.isEmpty) {
      return TextSpan(
        text: text,
        style: TextStyle(
          color: isEmail ? KPrimaryColor : Colors.black,
          fontSize: isEmail ? 18 : 22,
          fontWeight: isEmail ? FontWeight.normal : FontWeight.w500,
        ),
      );
    }

    List<TextSpan> spans = [];
    String lowerText = text.toLowerCase();
    String lowerQuery = query.toLowerCase();

    int start = 0;
    int index = lowerText.indexOf(lowerQuery);

    while (index != -1) {
      if (index > start) {
        spans.add(
          TextSpan(
            text: text.substring(start, index),
            style: TextStyle(
              color: isEmail ? KPrimaryColor : Colors.black,
              fontSize: isEmail ? 18 : 22,
              fontWeight: isEmail ? FontWeight.normal : FontWeight.w500,
            ),
          ),
        );
      }

      spans.add(
        TextSpan(
          text: text.substring(index, index + query.length),
          style: TextStyle(
            color: isEmail ? KPrimaryColor : Colors.black,
            fontSize: isEmail ? 18 : 22,
            fontWeight: FontWeight.bold,
            backgroundColor: Colors.yellow.withOpacity(0.3),
          ),
        ),
      );

      start = index + query.length;
      index = lowerText.indexOf(lowerQuery, start);
    }

    if (start < text.length) {
      spans.add(
        TextSpan(
          text: text.substring(start),
          style: TextStyle(
            color: isEmail ? KPrimaryColor : Colors.black,
            fontSize: isEmail ? 18 : 22,
            fontWeight: isEmail ? FontWeight.normal : FontWeight.w500,
          ),
        ),
      );
    }

    return TextSpan(children: spans);
  }
}
