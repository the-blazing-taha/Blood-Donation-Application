import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Create a chat room ID (simple way)
  String getChatRoomId(String user1, String user2) {
    return user1.hashCode <= user2.hashCode
        ? '${user1}_$user2'
        : '${user2}_$user1';
  }
  Future<String?> getUserFullName(String senderId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(senderId)
          .get();

      if (snapshot.exists && snapshot.data() != null) {
        return snapshot.data()!['fullName'] as String?; // Safely access 'fullName'
      } else {
        print('User with ID $senderId not found.');
        return null; // Or return a default value like 'Unknown'
      }
    } catch (e) {
      print('Error fetching user $senderId: $e');
      return null; // Or handle the error appropriately
    }
  }

  // Send a message
  Future<void> sendMessage(String receiverId, String message) async {
    String senderId = _auth.currentUser!.uid;
    String chatRoomId = getChatRoomId(senderId, receiverId);
    String? senderName = await getUserFullName(senderId);
    String? receiverName = await getUserFullName(receiverId);

    // Send the message
    await _firestore.collection('chats')
        .doc(chatRoomId)
        .collection('messages')
        .add({
      'senderId': senderId,
      'receiverId': receiverId,
      'message': message,
      'timestamp': FieldValue.serverTimestamp(),
    });

    // Add receiver to sender's chat list
    await FirebaseFirestore.instance
        .collection('users')
        .doc(senderId)
        .collection('chats')
        .doc(receiverId)
        .set({
      'chatWith': receiverId,
      'chatWithName': receiverName,
      'lastMessage': message,
      'timestamp': Timestamp.now(),
      'unreadCount': 0, // sender's unread always 0
    });

    await FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(senderId)
        .set({
      'chatWith': senderId,
      'chatWithName': senderName,
      'lastMessage': message,
      'timestamp': Timestamp.now(),
      'unreadCount': FieldValue.increment(1),
    });
    final docRef = FirebaseFirestore.instance
        .collection('chats')
        .doc(senderId)
        .collection(receiverId)
        .doc(); // Auto-generated ID

    await docRef.set({
      'id': docRef.id,
      'senderId': senderId,
      'receiverId': receiverId,
      'message': message,
      'timestamp': Timestamp.now(),
    });
  }


  // Stream messages
  Stream<QuerySnapshot> getMessages(String receiverId) {
    String senderId = _auth.currentUser!.uid;
    String chatRoomId = getChatRoomId(senderId, receiverId);

    return _firestore
        .collection('chats')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }


  Future<String?> getUserProfileImage(String userId) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        // Get the fullName field
        String img = userDoc.get('profileImage');
        return img;
      } else {
        print('User not found.');
        return null;
      }
    } catch (e) {
      print('Error fetching profile image: $e');
      return null;
    }
  }
}
