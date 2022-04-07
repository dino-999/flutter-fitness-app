import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'message_bubble.dart';

class Messages extends StatelessWidget {
  final chatDocId;
  var userData;
  var adminData;
  final currentUser = FirebaseAuth.instance.currentUser;

  Messages(this.chatDocId);

  Future<void> _getUserDocs() async {
    userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser!.uid)
        .get();

    adminData = await FirebaseFirestore.instance
        .collection('users')
        .doc('9EAXrUIg5ffzH6ZBA7rAIkiMjwp1')
        .get();
  }

  @override
  Widget build(BuildContext context) {
    _getUserDocs();
    print(chatDocId + 'dino');
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chats')
          .doc(chatDocId)
          .collection('messages')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (ctx, AsyncSnapshot<QuerySnapshot> chatSnapshot) {
        if (chatSnapshot.hasError) {
          return const Center(
            child: Text('Something went wrong!'),
          );
        }
        if (chatSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (chatSnapshot.hasData) {
          final messageDocs = chatSnapshot.data!.docs;
          return ListView.builder(
            reverse: true,
            itemCount: messageDocs.length,
            itemBuilder: (ctx, index) => MessageBubble(
              messageDocs[index].data()['text'],
              messageDocs[index].data()['uid'] == currentUser!.uid
                  ? userData.data()['username']
                  : adminData.data()['username'],
              messageDocs[index].data()['uid'] == currentUser!.uid
                  ? userData.data()['image_url']
                  : adminData.data()['image_url'],
              messageDocs[index].data()['uid'] == currentUser!.uid,
            ),
          );
        } else {
          return Container(
            height: 200,
          );
        }
      },
    );
  }
}
