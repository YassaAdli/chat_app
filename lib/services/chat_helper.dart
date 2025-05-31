import 'package:cloud_firestore/cloud_firestore.dart';

class ChatHelper {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Generate chat ID consistently between two users
  static String getChatId(String userId1, String userId2) {
    List<String> ids = [userId1, userId2];
    ids.sort(); // Sort to ensure consistent chat ID regardless of order
    return ids.join('_');
  }

  // Create or get existing chat room
  static Future<void> createChatRoom(
      String currentUserId,
      String receiverId,
      String currentUserEmail,
      String receiverEmail
      ) async {
    // Don't create chat room with yourself
    if (currentUserId == receiverId) {
      return;
    }

    String chatId = getChatId(currentUserId, receiverId);

    DocumentReference chatRoomRef = _firestore.collection('chat_rooms').doc(chatId);

    // Check if chat room already exists
    DocumentSnapshot chatRoomSnapshot = await chatRoomRef.get();

    if (!chatRoomSnapshot.exists) {
      // Create new chat room
      await chatRoomRef.set({
        'chatId': chatId,
        'participants': [currentUserId, receiverId], // Two different users
        'participantEmails': [currentUserEmail, receiverEmail], // Two different emails
        'createdAt': FieldValue.serverTimestamp(),
        'lastMessage': '',
        'lastMessageTime': FieldValue.serverTimestamp(),
      });
    }
  }

  // Send message
  static Future<void> sendMessage({
    required String currentUserId,
    required String currentUserEmail,
    required String receiverId,
    required String message,
  }) async {
    String chatId = getChatId(currentUserId, receiverId);

    // Add message to messages subcollection
    await _firestore
        .collection('chat_rooms')
        .doc(chatId)
        .collection('messages')
        .add({
      'sender': currentUserId,
      'senderEmail': currentUserEmail,
      'receiver': receiverId,
      'message': message,
      'timestamp': FieldValue.serverTimestamp(),
    });

    // Update last message in chat room
    await _firestore.collection('chat_rooms').doc(chatId).update({
      'lastMessage': message,
      'lastMessageTime': FieldValue.serverTimestamp(),
    });
  }

  // Get messages stream
  static Stream<QuerySnapshot> getMessagesStream(String currentUserId, String receiverId) {
    String chatId = getChatId(currentUserId, receiverId);

    return _firestore
        .collection('chat_rooms')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: false) // Order by timestamp ascending
        .snapshots();
  }
}