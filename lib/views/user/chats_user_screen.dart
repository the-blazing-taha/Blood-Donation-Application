import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'chat_screen.dart';

class ChatUsersScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ChatUsersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String currentUserId = _auth.currentUser!.uid;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          "Messages",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        centerTitle: true,
        elevation: 4,
        backgroundColor: Colors.deepPurple,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('users')
            .doc(currentUserId)
            .collection('chats')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          var chatUsers = snapshot.data!.docs;

          if (chatUsers.isEmpty) {
            return const Center(
              child: Text(
                "No chats yet.",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: chatUsers.length,
            itemBuilder: (context, index) {
              var chatUser = chatUsers[index];

              return Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  leading: CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.deepPurple[200],
                    child: const Icon(Icons.person, color: Colors.white),
                  ),
                  title: Text(
                    chatUser['chatWithName'],
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                  subtitle: chatUser['lastMessage'] != null
                      ? Text(
                    chatUser['lastMessage'],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  )
                      : null,
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
                      const SizedBox(height: 5),
                      if ((chatUser['unreadCount'] ?? 0) > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            chatUser['unreadCount'].toString(),
                            style: const TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                    ],
                  ),
                  onTap: () async {
                    // Reset unread count when opening chat
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(currentUserId)
                        .collection('chats')
                        .doc(chatUser.id)
                        .update({'unreadCount': 0});

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(
                          receiverId: chatUser['chatWith'],
                          receiverName: chatUser['chatWithName'],
                        ),
                      ),
                    );
                  },
                ),

              );
            },
          );
        },
      ),
    );
  }
}
